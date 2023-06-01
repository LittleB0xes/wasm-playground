import fs from 'fs'

const first = fs.readFileSync('./first.wasm');

let my_module = await WebAssembly.instantiate(new Uint8Array(first))
    .then(res => res.instance.exports)

console.log("3^2 + 5^2 = " + my_module.pythagoras(3, 5))