(module
    (import "console" "log" (func $log (param i32)))

    (func $say_number (param i32)
        local.get 0
        call $log
    )

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

    (export "say_number"(func $say_number))
    (export "count_to" (func $count_to))
)
