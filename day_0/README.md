# Day 0 - An Empty Module
This step has, in itself, little interest. it's just a matter of creating our first file and testing our setup with a compilation without surprises :


## The WASM part
First, we create a `.wat` file, the text version of wasm language
```wasm
;; hello module
( module )
```
And it's done..

Now, we can compile with WABT :
`wat2wasm empty.wat -o empty.wasm`

Now, if we look inside our wasm file (with `xxd empty.wasm`), we've got a beutyful binary file
```
00000000: 0061 736d 0100 0000                      .asm....
```

`00 61 73 6d` is the magic number for wasm file

## The JS part
For now, I'm not going to bother with an HTML/JS file and a local server, I'm just going to use a very small JS file to use with NodeJS (don't forget npm init...)

```js
import fs from 'fs'

const empty = fs.readFileSync('empty.wasm');

let test = await WebAssembly.instantiate(new Uint8Array(empty)).
    then(res => res.instance.exports)
```

And when we launch it with node: it happen... Nothing, no error... Nothing 
It's ok. We can now go forward.




