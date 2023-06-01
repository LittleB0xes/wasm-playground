# My Old Friend, Pythagoras
Let's take our module from before and reuse it to calculate the length of the hypotena of a right triangle. Actually, we're just going to calculate the sum of two squared numbers, but the Pythagorean invocation is more impressive :-P (and by the way, we'll see how to call a wasm function in a wasm module)

# The WASM Part

To call a wasm function, simply use the `call` function, followed by the name of the function. But be careful, don't forget to fill the stack with all the parameters necessary to use the function.

In return, after consuming the arguments, the function will push the result onto the stack

```wasm
(func $pythagoras_summoning (param $a i32) (param $b i32) (result i32)
    local.get $a
    call $square

    local.get $b
    call $square

    i32.add
 )
 ```

In wasm, a module is a big S expression and with this in mind, we can also code the previous 5 lines of code in a more compact way (one line), but a little less readable :-D
But it also works

```wasm
(func $pythagoras_summoning (param $a i32) (param $b i32) (result i32)
    (i32.add (call $square (local.get $a)) (call $square (local.get $b))) 
)
```

# The JS Part
Nothing too fancy : we just need to use our new incantation

```js
import fs from 'fs'

const first = fs.readFileSync('./first.wasm');

let my_module = await WebAssembly.instantiate(new Uint8Array(first))
    .then(res => res.instance.exports)

console.log("3^2 + 5^2 = " + my_module.pythagoras(3, 5))
```

