import fs from 'fs'

const speaker = fs.readFileSync('./parrot.wasm');

const importObject = {
    "console": {"log": console.log},
    // Add the super power you need from JS
}
let parrot = await WebAssembly.instantiate(new Uint8Array(speaker), importObject)
    .then(res => res.instance.exports)

parrot.count_to(10);