import fs from 'fs'

const first = fs.readFileSync('./first.wasm');

let my_module = await WebAssembly.instantiate(new Uint8Array(first))
    .then(res => res.instance.exports)

// Let's call our function
console.log("The squared value of 5 is " + my_module.square(5));
console.log("The squared value of -2 is " + my_module.square(-2));