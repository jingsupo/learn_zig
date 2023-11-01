const std = @import("std");
const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;
const expect = std.testing.expect;

// Function are declared like this
fn add(a: i8, b: i8) i8 {
    if (a == 0) {
        return b;
    }
    return a + b;
}

export fn sun(a: i8, b: i8) i8 {
    return a - b;
}

const WINAPI: std.builtin.CallingConvention = if (native_arch == .x86) .Stdcall else .C;
extern "kernel32" fn ExitProcess(exit_code: u32) callconv(WINAPI) noreturn;
extern "c" fn atan2(a: f64, b: f64) f64;

// The @setCold builtin tells the optimizer that a function is rarely called.
fn abort() noreturn {
    @setCold(true);
    while (true) {}
}

fn _start() callconv(.Naked) noreturn {
    abort();
}

// The inline calling convention forces to be inlined at all call sites.
// If the function cannot be inlined, it is a compile-time error.
inline fn shiftLeftOne(a: u32) u32 {
    return a << 1;
}

pub fn sub2(a: i8, b: i8) i8 {
    return a - b;
}

// Function pointers are prefixed with `*const`
const call2_op = *const fn (a: i8, b: i8) i8;
fn do_op(fn_call: call2_op, op1: i8, op2: i8) i8 {
    return fn_call(op1, op2);
}

test "function" {
    try expect(do_op(add, 5, 6) == 11);
    try expect(do_op(sub2, 5, 6) == -1);
}
