(module
    (func $square (param $a i32) (result i32)
        local.get $a
        local.get $a

        i32.mul
    )

    (func $pythagoras_summoning (param $a i32) (param $b i32) (result i32)
        local.get $a
        call $square

        local.get $b
        call $square

        i32.add

        ;; Another way to achive our goal
        ;; (i32.add (call $square (local.get $a)) (call $square (local.get $b)) 
    )


    (export "square" (func $square))
    (export "pythagoras" (func $pythagoras_summoning))
)