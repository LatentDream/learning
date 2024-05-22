
checkers.wasm:	file format wasm 0x1

Section Details:

Type[10]:
 - type[0] (i32, i32, i32, i32) -> nil
 - type[1] (i32, i32) -> nil
 - type[2] (i32, i32) -> i32
 - type[3] (i32) -> i32
 - type[4] (i32, i32, i32) -> nil
 - type[5] (i32, i32, i32) -> i32
 - type[6] () -> i32
 - type[7] () -> nil
 - type[8] (i32) -> nil
 - type[9] (i32, i32, i32, i32) -> i32
Import[3]:
 - func[0] sig=0 <events.piecemoved> <- events.piecemoved
 - func[1] sig=1 <events.piececrowned> <- events.piececrowned
 - func[2] sig=1 <events.pieceremoved> <- events.pieceremoved
Function[23]:
 - func[3] sig=2
 - func[4] sig=2
 - func[5] sig=3 <isCrowned>
 - func[6] sig=3
 - func[7] sig=3
 - func[8] sig=3
 - func[9] sig=3
 - func[10] sig=4
 - func[11] sig=2 <getPiece>
 - func[12] sig=5
 - func[13] sig=6 <getTurnOwner>
 - func[14] sig=7
 - func[15] sig=8
 - func[16] sig=3
 - func[17] sig=2
 - func[18] sig=1
 - func[19] sig=2
 - func[20] sig=9
 - func[21] sig=2
 - func[22] sig=2
 - func[23] sig=9 <move>
 - func[24] sig=9
 - func[25] sig=7 <initBoard>
Memory[1]:
 - memory[0] pages: initial=1
Global[4]:
 - global[0] i32 mutable=0 - init i32=1
 - global[1] i32 mutable=0 - init i32=2
 - global[2] i32 mutable=0 - init i32=4
 - global[3] i32 mutable=1 - init i32=0
Export[6]:
 - func[11] <getPiece> -> "getPiece"
 - func[5] <isCrowned> -> "isCrowned"
 - func[25] <initBoard> -> "initBoard"
 - func[13] <getTurnOwner> -> "getTurnOwner"
 - func[23] <move> -> "move"
 - memory[0] -> "memory"
Code[23]:
 - func[3] size=10
 - func[4] size=11
 - func[5] size=10 <isCrowned>
 - func[6] size=10
 - func[7] size=10
 - func[8] size=7
 - func[9] size=7
 - func[10] size=13
 - func[11] size=36 <getPiece>
 - func[12] size=13
 - func[13] size=4 <getTurnOwner>
 - func[14] size=19
 - func[15] size=6
 - func[16] size=10
 - func[17] size=23
 - func[18] size=28
 - func[19] size=7
 - func[20] size=48
 - func[21] size=32
 - func[22] size=32
 - func[23] size=31 <move>
 - func[24] size=57
 - func[25] size=198 <initBoard>
