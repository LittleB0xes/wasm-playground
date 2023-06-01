(module
    (func $square (param $a i32) (result i32)
        local.get $a
        local.get $a

        i32.mul
    )
    (export "square" (func $square))
)