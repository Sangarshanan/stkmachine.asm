#!/usr/bin/env bats

@test "invoking asm with an invalid operator" {
  run  ./stk bruh 1 1
  [ "$status" -eq 1 ]
  [ "$output" = "Invalid Operator, available operators are: +, -, &, |, =, >, <, n, ~ " ]
}

@test "invoking asm with an invalid operand" {
  run  ./stk n o o
  [ "$status" -eq 1 ]
  [ "$output" = "Invalid Operand, use a valid integer" ]
}

@test "invoking asm with too Few Arguments" {
  run  ./stk
  [ "$status" -eq 1 ]
  [ "$output" = "Too Few Arguments, follow ./stk <operator> <operand1> <operand2 (optional)>" ]
}

@test "invoking asm with too Many Arguments" {
  run  ./stk n 1 2 3 4 5
  [ "$status" -eq 1 ]
  [ "$output" = "Too Many Arguments, follow ./stk <operator> <operand1> <operand2 (optional)>" ]
}


@test "Addition" {
  run ./stk "+" 200 1
  [ "$output" = 201 ]
}


@test "Subtraction" {
  run ./stk "-" 200 1
  [ "$output" = 199 ]
}


@test "Negative" {
  run ./stk "n" 1
  [ "$output" = l18446744073709551615 ]
}


@test "Equality True" {
  run ./stk "=" 200 200
  [ "$output" = 1 ]
}

@test "Equality False" {
  run ./stk "=" 200 2
  [ "$output" = 0 ]
}

@test "Greater-than True" {
  run ./stk ">" 200 2
  [ "$output" = 1 ]
}

@test "Greater-than False" {
  run ./stk ">" 2 200
  [ "$output" = 0 ]
}


@test "Lesser-than True" {
  run ./stk "<" 200 2
  [ "$output" = 0 ]
}


@test "Lesser-than False" {
  run ./stk "<" 2 200
  [ "$output" = 1 ]
}


@test "AND False" {
  run ./stk "&" 1 0
  [ "$output" = 0 ]
}


@test "AND True" {
  run ./stk "&" 1 1
  [ "$output" = 1 ]
}


@test "OR False" {
  run ./stk "|" 0 0
  [ "$output" = 0 ]
}


@test "OR True 1" {
  run ./stk "|" 1 0
  [ "$output" = 1 ]
}

@test "OR True 2" {
  run ./stk "|" 1 1
  [ "$output" = 1 ]
}


@test "NOT True" {
  run ./stk "~" 1
  [ "$output" = 0 ]
}

@test "NOT False" {
  run ./stk "~" 0
  [ "$output" = 1 ]
}

