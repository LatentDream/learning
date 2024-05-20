fetch("./checkers.wasm").then(response =>
    response.arrayBuffer()
).then(bytes =>
    WebAssembly.instantiate(bytes, {
        events: {
            piecemoved: (fromx, fromy, tox, toy) => {
                console.log(`Piece moved from ${fromx},${fromy} to ${tox},${toy}`);
            },
            piececrowned: (x, y) => {
                console.log(`Piece crowned at ${x},${y}`);
            }
        },
    }
)).then(results => {
    instance = results.instance;

    instance.exports.initBoard();
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
