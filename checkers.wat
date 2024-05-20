;; ..24bit..00000000 Unoccupied square
;; ..24bit..00000001 Black Piece
;; ..24bit..00000010 White Piece
;; ..24bit..00000100 Crowned Piece 
(module
  ;; Global variable
  (global $BLACK   i32 (i32.const 1))
  (global $WHITE   i32 (i32.const 2))
  (global $CROWN   i32 (i32.const 4))

  (memory $mem 1)  ;; mem: must have 64KB

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
    (func $offSetForPosition (param $x i32) (param $y i32) (result i32)
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


)
