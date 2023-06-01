import fs from 'fs'

const empty = fs.readFileSync('empty.wasm');

let test = await WebAssembly.instantiate(new Uint8Array(empty))