# Day 1 - First Function


## The WASM Part
Let's write some function.

First of all, we can start with a great programming classic: the `square` function... so much fun.

A little discussion of wasm types is in order. From this point of view, wasm is very rustic (very very). Wasm offers us an exuberant amount of data types... Four. Yes, four data type (i32, i64, f32, f64). I'll arrest you right away: no string !!

We will therefore work with this minimalist approach. On the other hand, for those who have already used assembler, it is rather rich

So, let's go !

wasm function looks like this
```wasm
;; (func $my_function (param <type>) (result <type>)
;;      ... do some stuff here
;; )

;; this one take one i32 argument and return nothing
(func $my_function (param i32)
    ;; ....
)

;; this one take two i32 argument and return a i32

(func $my_function (param i32) (param i32) (result i32)
    ;; ...
)
```

Our function should look like this :
```wasm
(func $square (param i32) (result i32)

    ;; highly scientific computing inside ;-)

)
```

Wasm is a stack based machine with a bunch of function usefull for stack manipulation

```wasm
(func $square (param i32) (result i32)
    local.get 0     ;; take the first parameter (index 0) and put it on the top of the stack 
    local.get 0     ;; take the first parameter (index 0) and put it on the top of the stack

    i32.mul         ;; take (and remove) the last two element on the top of the stack
                    ;; multiply them and put the result on the top of the stack 
)
```

Our wasm function's result (aka return value) is the last element of the stack

But for now, our function is only visible from inside our wasm module. It must therefore be exported to make it visible from the outside.

So we need to add this in our module to make it a bit less...introverted
```wasm
    (export "square" (func $square))
```


## The JS Part

```js
import fs from 'fs'

const first = fs.readFileSync('first.wasm');

let my_module = await WebAssembly.instantiate(new Uint8Array(first)).
    then(res => res.instance.exports)           // To export all our wasm functions

// Let's call our function
console.log("The squared value of 5 is " + my_module.square(5));
console.log("The squared value of -2 is " + my_module.square(-2));

```

And now, `node index.js` ... we can admire the result of the magnificent work we have done.

## A Few Comments...

### Stack and result
You must ensure that the stack contains exactly what is expected at the end. If there is no result type, the stack must be empty.
If you expect two i64s, you should end up with exactly two i64s, no more, no less.


### Export
We can also directly export the function in the declaration, like this :
```wasm
(module
    (func $square (export "square") (param i32) (result i32)
        local.get 0
        local.get 0
        i32.mul
    )
)
```

### Parameter name
Instead of a fairly anonymous naming like this
```wasm
    (func $add (param i32) (param i32) (result i32)
        local.get 0
        local.get 1

        i32.mul
    )
```

You can give a name to the parameter of a function, for convenience and readability
```wasm
    (func $add (param $a i32) (param $b i32) (result i32)
        local.get $a
        local.get $b

        i32.mul
    )
```

### Just for curious
Here is our 43 bytes wasm binary

```
00000000: 0061 736d 0100 0000 0106 0160 017f 017f  .asm.......`....
00000010: 0302 0100 070a 0106 7371 7561 7265 0000  ........square..
00000020: 0a09 0107 0020 0020 006c 0b              ..... . .l.
```

