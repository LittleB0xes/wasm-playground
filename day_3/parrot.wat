(module
    (import "console" "log" (func $log (param i32)))

    (func $say_number (param i32)
        local.get 0
        call $log
    )

   (func $count_to (param $limit i32)
    (local $counter i32)        ;; The short term memory of our parrot

    (loop $count_loop
        local.get $counter      ;; get the counter value
        i32.const -1             ;; push 1 onto the stack
        i32.add                 ;; add the two values

        local.tee $counter
        call $log               ;; And print it


        local.get $counter      ;; get the counter value
        local.get $limit        ;; get the limit
        i32.lt_s                ;; And let's compare them both (less than)
        br_if $count_loop       ;; if it's smaller, we go back to the start of the loop
    )
)

    (export "say_number"(func $say_number))
    (export "count_to" (func $count_to))
)