# Checker written in pure WASM
Learning WebAssembly, basic

## Install the tooling:
[Wabt](https://github.com/WebAssembly/wabt)

## Run:
```
wat2wasm func_test.wat
python3 -m http.server
http://localhost:8000/
```

## Test:
```
wat2wasm func_test.wat
python3 -m http.server
http://localhost:8000/func_test.html
```
