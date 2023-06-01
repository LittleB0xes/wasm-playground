# Can You write something ?

It's time to go a little further, just a little bit. How do I write something with wasm? Basically, wasm doesn't know how to do it: he needs help. Here, Javascript will give it this power.

To boost wasm's capabilities a bit, we need to make the host share functions with it. Here, we'll give wasm the ability to display stuff in the console: we'll start with the simplest, the only thing wasm knows, numbers

## The JS Part

Let's fix the JS part right away to focus on the fun stuff next.

We need to explicitly declare the functions we want to share with our module, like this
```js
const importObject = {
    // Add the super power you need from JS
    "console": {"log": console.log},
}
```

We then need to import the `importObject` into our WebAssembly instance

```js
let my_module = await WebAssembly.instantiate(new Uint8Array(fib), importObject)
    .then(res => res.instance.exports)

```

And that's all

## The WASM part

It's fine to have passed functions to import, but now we have to tell wasm what to do with them.

```wasm
(module
    (import "console" "log" (func $log (param i32)))
)
```

Come on, let's make him say something totally useless

```wasm
(module
    (import "console" "log" (func $log (param i32)))

    (func $say_number (param i32)
        local.get 0     ;; push the parameter onto the stack
        call $log       ;; and print it in the console
    )

    (export "say_number"(func $say_number))
)
```

Now, we can add `my_module.say_number(123)`, run `node index.js`and Ô Miracle, the console say `123`...

We just created a parrot

### Let's teach him to count
Our parrot is still a little young and immature, let's teach him a little more. Now that he can talk, maybe we can teach him to count

The parrot must remember what number it has reached. So, we ca add a local variable to do this.
We will also have to make it count until it reaches the requested number. For this, a loop, a comparison and a conditional branch...

```wasm
(func $count_to (param $limit i32)
    (local $counter i32)       ;; The short term memory of our parrot

    (loop $count_loop
    
        ;; counting logic here    


        local.get $counter          ;; get the counter value
        local.get $limit            ;; get the limit
        i32.lt_s                    ;; And let's compare them both (less than)
        br_if $counter_loop         ;; if it's smaller, we go back to the start of the loop
    )
)

```

`lt_s` (or `lt_u` for unsigned) compare the two elements (`$counter` and `$limit`) on the top of the stack and push 1 if `$counter < $limit` or 0 if `$counter > $limit`

`br_if` is a conditional branch that returns to our loop's label if the previous condition is met, i.e. if `1` is on our stack

Now, we can add the counter logic :
- take the counter value
- add 1
- store the new counter value
- print the counter value

```wasm
(func $count_to (param $limit i32)
    (local $counter i32)        ;; The short term memory of our parrot

    (loop $count_loop
    

        local.get $counter      ;; get the counter value
        i32.const 1             ;; push 1 onto the stack
        i32.add                 ;; add the two values

        local.set $counter      ;; Set the new value of the counter
        local.get $counter      ;; Push the countr's value on the top of the stack
        call $log               ;; And print it

        

        local.get $counter      ;; get the counter value
        local.get $limit        ;; get the limit
        i32.lt_s                ;; And let's compare them both (less than)
        br_if $count_loop       ;; if it's smaller, we go back to the start of the loop
    )
)

```

We can also use another function to avoid repetition :
```wasm
local.tee $counter      ;; Store stack value and no consume it
call $log

;; do the same thing than

local.set $counter      ;; Set the new value of the counter
local.get $counter      ;; Push the countr's value on the top of the stack
call $log               ;; And print it
```

Now, if we add `parrot.count_to(42)` at the end of `index.js`, after launching, our parrot is smarter : it can count.
