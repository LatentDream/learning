;; ..24bit..00000000 Unoccupied square
;; ..24bit..00000001 Black Piece
;; ..24bit..00000010 White Piece
;; ..24bit..00000100 Crowned Piece 
(module

  ;; Import -------------------------------------------------------------------
  (; (import "events" "piecemoved" ;)
  (;         (func $notify_piecemoved (param $fromX i32) (param $fromY i32) (param $toX i32) (param $toY i32))) ;)

  (import "events" "piececrowned"
          (func $notify_piececrowned (param $pieceX i32) (param $pieceY i32)))

  ;; Memomy -------------------------------------------------------------------
  (memory $mem 1)  ;; mem: must have 64KB

  ;; Global variable ----------------------------------------------------------
  (global $BLACK   i32 (i32.const 1))
  (global $WHITE   i32 (i32.const 2))
  (global $CROWN   i32 (i32.const 4))
  (global $currentTurn (mut i32) (i32.const 0))


  ;; INIT GAME STEP -----------------------------------------------------------
    (func $indexForPosition (param $x i32) (param $y i32) (result i32)
      (i32.add
        (i32.mul
          (i32.const 8)
          (local.get $y)
        )
        (local.get $x)
      )
    )

    ;; Offset = ( x + y * 8 ) * 4  ;; 32-bit int, we need 4 bytes 
    (func $offsetForPosition (param $x i32) (param $y i32) (result i32)
      (i32.mul
        (call $indexForPosition (local.get $x) (local.get $y))
        (i32.const 4)
      )
    )

  ;; UTIL FUNC ----------------------------------------------------------------

    ;; Is a piece crowned
    (func $isCrowned (param $piece i32) (result i32)
      (i32.eq
        (i32.and (local.get $piece) (global.get $CROWN))
        (global.get $CROWN)
      )
    )
    ;; Is a piece black
    (func $isBlack (param $piece i32) (result i32)
      (i32.eq
        (i32.and (local.get $piece) (global.get $BLACK))
        (global.get $BLACK)
      )
    )
    ;; Is a piece crowned
    (func $isWhite (param $piece i32) (result i32)
      (i32.eq
        (i32.and (local.get $piece) (global.get $WHITE))
        (global.get $WHITE)
      )
    )

    ;; Adds crown to a piece (no mutation)
    (func $withCrown (param $piece i32) (result i32)
      (i32.or (local.get $piece) (global.get $CROWN))
    )
    ;; Removes crown of a piece (no mutation)
    (func $withoutCrown (param $piece i32) (result i32)
      (i32.and (local.get $piece) (i32.const 3))
    )

  ;; SET GAME FUNC ------------------------------------------------------------

    ;; Sets a piece on the board (store the value in a memory position
    (func $setPiece (param $x i32) (param $y i32) (param $piece i32)
      (i32.store
        (call $offsetForPosition
          (local.get $x)
          (local.get $y)
        )
        (local.get $piece)
      )
    )

    ;; Gets a piece from the board. Out of range causes a trap
    (func $getPiece (param $x i32) (param $y i32) (result i32)
      (if (result i32)
        (block (result i32)  ;; A bit like an anonymous function that is use by the if
          (i32.and
            (call $inRange
              (i32.const 0)
              (i32.const 7)
              (local.get $x)
            )
            (call $inRange
              (i32.const 0)
              (i32.const 7)
              (local.get $y)
            )
          )
        )
      (then
        (i32.load
          (call $offsetForPosition
            (local.get $x)
            (local.get $y)
          )
        )
      )
      (else
        (unreachable)
        )
      )
    )

    ;; Detect of out of range
    (func $inRange (param $low i32) (param $high i32) (param $value i32) (result i32)
      (i32.and
        (i32.ge_s (local.get $value) (local.get $low))
        (i32.le_s (local.get $value) (local.get $high))
      )
    )

    ;; Get the current turn owner (white or black)
    (func $getTurnOwner (result i32)
      (global.get $currentTurn)
    )

    ;; At the end of a turn, switch turn owner to the other player
    (func $toggleTurnOwner
      (if (i32.eq (call $getTurnOwner) (i32.const 1))
        (then (call $setTurnOwner (i32.const 2)))
        (else (call $setTurnOwner (i32.const 1)))
      )
    )

    ;; Sets the turn owner
    (func $setTurnOwner (param $piece i32)
      (global.set $currentTurn (local.get $piece))
    )

    ;; Determine if it's a player's turn
    (func $isPlayersTurn (param $player i32) (result i32)
      (i32.gt_s
        (i32.and (local.get $player) (call $getTurnOwner))
        (i32.const 0)
      )
    )

  ;; GAME RULE ----------------------------------------------------------------

    ;; Crown black pieces in row 0, white pieces in row 7
    (func $shouldCrown (param $pieceY i32) (param $piece i32) (result i32)
      (i32.or
        (i32.and
          (i32.eq
            (local.get $pieceY)
            (i32.const 0)
          )
          (call $isBlack (local.get $piece))
        )
        (i32.and
          (i32.eq
            (local.get $pieceY)
            (i32.const 7)
          )
          (call $isWhite (local.get $piece))
        )
      )
    )

    ;; Convert a piece into a crowned piece and invokes a host notifier
    (func $crownPiece (param $x i32) (param $y i32)
      (local $piece i32)  ;; local variable - scoped to the function
      (local.set $piece (call $getPiece (local.get $x) (local.get $y)))
      (call $setPiece (local.get $x) (local.get $y)
        (call $withCrown (local.get $piece)))
      (call $notify_piececrowned (local.get $x) (local.get $y))
    )

    (func $distance (param $x i32)(param $y i32)(result i32)
      (i32.sub (local.get $x) (local.get $y))
    )

    ;; TODO jump & multi-jump

  ;; Player moving ------------------------------------------------------------

    ;; Check if a move is valid
    (func $isValidMove (param $fromX i32) (param $fromY i32) (param $toX i32) (param $toY i32) (result i32)
      (local $player i32)
      (local $target i32)

      (local.set $player (call $getPiece (local.get $fromX) (local.get $fromY)))
      (local.set $target (call $getPiece (local.get $toX) (local.get $toY)))
      (if (result i32)
        (block (result i32)
          (i32.and
            (call $validJumpDistance (local.get $fromY) (local.get $toY))
            (i32.and
              (call $isPlayersTurn (local.get $player))
              ;; target must be unoccupied
              (i32.eq (local.get $target) (i32.const 0))
            )
          )
        )
        (then
          (i32.const 1)
        )
        (else
          (i32.const 0)
        )
      )
    )

    ;; Ensures travel is 1 or 2 squares
    (func $validJumpDistance (param $from i32) (param $to i32) (result i32)
      (local $d i32)
      (local.set $d
        (if (result i32)
          (i32.gt_s (local.get $to) (local.get $from))
          (then
            (call $distance (local.get $to) (local.get $from)) ;; No abs, order is importance
          )
          (else
            (call $distance (local.get $from) (local.get $to))
          )
        )
      )
      (i32.le_u
        (local.get $d)
        (i32.const 2)
      )
    )

    ;; Exported move functioin to be called by the game host
    (func $move (param $fromX i32) (param $fromY i32)
                (param $toX i32) (param $toY i32) (result i32)
      (if (result i32)
        (block (result i32)
          (call $isValidMove (local.get $fromX) (local.get $fromY) (local.get $toX) (local.get $toY))
        )
        (then
          (call $do_move (local.get $fromX) (local.get $fromY) (local.get $toX) (local.get $toY))
        )
        (else
          (i32.const 0)
        )
      )
    )
    ;; Internal move function that perform the actual move
    ;; TODO:
    ;;  - Removing oppenent piece dureng a jump
    ;;  - detecting win condition
    (func $do_move (param $fromX i32) (param $fromY i32) (param $toX i32) (param $toY i32) (result i32)
      (local $curpiece i32)
      (local.set $curpiece (call $getPiece (local.get $fromX) (local.get $fromY)))

      (call $toggleTurnOwner)
      (call $setPiece (local.get $toX) (local.get $toY) (local.get $curpiece))
      (call $setPiece (local.get $fromX) (local.get $fromY) (i32.const 0))
      (if (call $shouldCrown (local.get $toY) (local.get $curpiece))
        (then (call $crownPiece (local.get $toX) (local.get $toY)))
      )
      (call $notify_piecemoved  (local.get $fromX i32) (local.get $fromY i32) (local.get $toX i32) (local.get $toY i32))
      (i32.const 1)
    )



)

