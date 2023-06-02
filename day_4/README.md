# Parrot Training

If we look at the parrot from the previous step, its counting abilities are really limited...
Ask him to count to -10, he will answer 1...
Ask him to count to 0, he will answer you 1...

It really seems necessary to restart his education.

For that, we are going to teach him to count up and count down according to the number given to him, and therefore add a little more control flow.

Of course, there are many ways to approach the problem. Fortunately, there is not only one way...  otherwise coding would be deadly boring.

## First approach: if ... else function
Wasm gives us the convenience of our usual if...else, so let's go

For counting, rather than systematically adding 1, we will adapt the increment according to the input parameter. We will therefore keep the same function body (almost) but by making it more flexible.

If our parameter is negative, we will add -1.
If our parameter is positive, we will add 1.
Otherwise (parameter equal to 0), we will not add anything at all.

We therefore need to create a new local variable containing the value of this increment

```wasm
(func $count_to (param $limit i32)
    (local $counter i32)        ;; The short term memory of our parrot
    (local $inc i32)            ;; The increment value (init to 0)

    local.get 0                 ;; Push the param to the stack        
    i32.const 0                 ;; Push 0 to the stack   
    i32.lt_s                    ;; compare both number
                                ;; we compare with 0 to choose the correct
                                ;; increment
    (if                        
        (then                   ;; if less than 0
            i32.const -1        ;; Set our increment value to -1      
            local.set $inc
        )
        (else                   ;; in other case
            i32.const 1         ;; set our increment value to 1
            local.set $inc
        )
    )
                                ;; Huh ! What ??! But if param is 0
                                ;; We don't want to add 1 !!!

    local.get 0                 ;; Ok, let's correct this
    i32.eqz
    (if 
        (then
            i32.const 0
            local.set $inc

        )
    )

                                ;; And Now !! Count my little parrot
    (loop $count_loop           
    

        local.get $counter      ;; get the counter value
        local.get $inc            
        i32.add                 ;; add the two values

        local.tee $counter
        call $log               ;; And print it


        local.get $counter      ;; get the counter value
        local.get $limit        ;; get the limit
        i32.ne                  ;; And let's compare them both (not equal)
        br_if $count_loop       ;; if it's smaller, we go back to the start of the loop
    )
)

```

When we try it, our parrot just got a little smarter.

It can count up and down and can answer `0` when asked to count to 0.

Our parrot thus coded (with its two functions) occupies 125 bytes...

But the this solution is a bit barbaric. Let's try to find a funnier way to determine our increment

## Another way : if and bit shifting

We set a default `1` value to the increment value `$inc` and get a signed value of the sign bit of `i32` by right shifting with `i32.shr_s`

```wasm
(func $count_to (param $limit i32)
    (local $counter i32)        
    (local $inc i32)            ;; The increment value (init to 0)
    (local.set $inc (i32.const 1))

    local.get 0                 ;; Push the param to the stack        
    i32.const 0
    i32.le_s                    ;; Compare to 0
    (if 
        (then
            local.get 0         ;; -----------------------------
            i32.const 31        ;; get the sign bit ()
            i32.shr_s           ;; -----------------------------
            local.set $inc      ;; Set the increment to the signed 
                                ;; value of the sign bit
        )
    )

    (loop $count_loop           
    
        ;; Counting code (same as before)
        
    )
)

```

The whole `parrot.wasm`is now 117 bytes length...

Now, it's your turn... You can now find other ways to do it, this part was mainly there to make us discover the tests and the conditions
