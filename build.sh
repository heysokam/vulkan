#!/bin/sh
set -eu

# Folders: General
dir_bin=./bin

# Folders: Code
dir_c=./c
dir_cpp=./cpp
dir_zig=./zig
dir_rust=./rust

# Source Code
src_c="$dir_c/entry.c"
src_cpp="$dir_cpp/entry.cpp"
src_zig="$dir_zig/entry.zig"
src_rust="$dir_rust/entry.rs"

# Target Binaries
trg_c=$dir_bin/vk_c
trg_cpp=$dir_bin/vk_cpp
trg_zig=$dir_bin/vk_zig
trg_rust=$dir_bin/vk_rust

# Compilers
zig="$dir_bin/.zig/zig"
zig_cc="$zig cc"
zig_cpp="$zig c++"
rust="cargo build"

# Build
clear
echo "Building ..."
$zig_cc $src_c -o $trg_c

# Run
echo "Running ..."
$trg_c

