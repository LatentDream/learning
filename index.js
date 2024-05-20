board = new Array(32);

function initBoard() {
    for (let i = 0; i < 8; i++) {
        for (let j = 0; j < 4; j++) {
            board[i * 4 + j] = " ";
        }
    }
    for (let i = 0; i < 3; i++) {
        for (let j = 0; j < 4; j++) {
            if ((i + j) % 2 == 1) {
                board[i * 4 + j] = "b";
            }
        }
    }
    for (let i = 5; i < 8; i++) {
        for (let j = 0; j < 4; j++) {
            if ((i + j) % 2 == 1) {
                board[i * 4 + j] = "w";
            }
        }
    }
}

function printBoard() {
    let boardStr = "";
    for (let i = 0; i < 8; i++) {
        for (let j = 0; j < 4; j++) {
            boardStr += board[i * 4 + j] + " ";
        }
        boardStr += "\n";
    }
    console.log(boardStr);
}

fetch("./checkers.wasm").then(response =>
    response.arrayBuffer()
).then(bytes =>
    WebAssembly.instantiate(bytes, {
        events: {
            piecemoved: (fromx, fromy, tox, toy) => {
                console.log(`Piece moved from ${fromx},${fromy} to ${tox},${toy}`);
                board[toy * 4 + tox] = board[fromy * 4 + fromx];
                board[fromy * 4 + fromx] = " ";
                printBoard();
            },
            piececrowned: (x, y) => {
                console.log(`Piece crowned at ${x},${y}`);
                board[y * 4 + x] = board[y * 4 + x].toUpperCase();
                printBoard();
            }
        },
    }
)).then(results => {
    instance = results.instance;

    instance.exports.initBoard();
    initBoard();
    console.log("At Start, Turn owner is" + instance.exports.getTurnOwner());

    instance.exports.move(0, 5, 0, 4); // B
    instance.exports.move(1, 0, 1, 1); // W
    instance.exports.move(0, 4, 0, 3); // B
    instance.exports.move(1, 1, 1, 0); // W
    instance.exports.move(0, 3, 0, 2); // B
    instance.exports.move(1, 0, 1, 1); // W
    instance.exports.move(0, 2, 0, 0); // B - Crown
    instance.exports.move(1, 1, 1, 0); // W

    let res = instance.exports.move(0, 0, 0, 2);

    document.getElementById("container").innerText = res;
    console.log("After moving, Turn owner is" + instance.exports.getTurnOwner());

}).catch(console.error);
