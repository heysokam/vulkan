//:_____________________________________________________________________________________
//  Vulkan: All-the-Things  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:_____________________________________________________________________________________
// @deps confy
const confy = @import("./build/confy.zig");
const Name  = confy.Name;
const Git   = confy.Git;


//______________________________________
// @section Package Information
//____________________________
const version     = "0.0.0";
const name        = "vulkan";
const description = "Vulkan: All-the-Things";
const license     = "GPLv3-or-later";
const author      = Name{ .short= "heysokam", .human= ".sOkam!" };
//________________________
const P = confy.Package.Info{
  .version = version,
  .name    = confy.Name{ .short= name, .human= description },
  .author  = author,
  .license = license,
  .git     = Git.Info{ .owner= author.short, .repo= name },
  }; //:: P


const dir = struct {
  const bin = "./bin";
  const C   = "./c";
  const Cpp = "./cpp";
  const Zig = "./zig";
}; //:: dir

const run = struct {
  const C    = true;
  const Cpp  = true;
  const Zig  = true;
}; //:: run


pub fn main () !u8 {
  // Initialize the confy builder
  var builder = try confy.init(); defer builder.term();
  //______________________________________
  // @section Build Targets
  //____________________________
  var C = try confy.Program(.{
    .trg     = "vk_c",
    .entry   = dir.C++"/entry.c",
    .version = P.version,
    }, &builder);
  //__________________
  var Cpp = try confy.Program(.{
    .trg     = "vk_cpp",
    .entry   = dir.Cpp++"/entry.cpp",
    .version = P.version,
    }, &builder);
  //__________________
  var Zig = try confy.Program(.{
    .trg     = "vk_zig",
    .entry   = dir.Zig++"/entry.zig",
    .version = P.version,
    }, &builder);

  P.report();
  if (run.C  ) { try C.build();   try C.run();   }
  if (run.Cpp) { try Cpp.build(); try Cpp.run(); }
  if (run.Zig) { try Zig.build(); try Zig.run(); }
  return 0;
}


// #!/bin/sh
// set -eu
//
// # Folders: General
// dir_bin=./bin
//
// # Folders: Code
// dir_c=./c
// dir_cpp=./cpp
// dir_zig=./zig
// dir_rust=./rust
//
// # Source Code
// src_c="$dir_c/entry.c"
// src_cpp="$dir_cpp/entry.cpp"
// src_zig="$dir_zig/entry.zig"
// src_rust="$dir_rust/entry.rs"
//
// # Target Binaries
// trg_c=$dir_bin/vk_c
// trg_cpp=$dir_bin/vk_cpp
// trg_zig=$dir_bin/vk_zig
// trg_rust=$dir_bin/vk_rust
//
// # Compilers
// zig="$dir_bin/.zig/zig"
// zig_cc="$zig cc"
// zig_cpp="$zig c++"
// rust="cargo build"
//
// # Build
// clear
// echo "Building C ..."
// $zig_cc $src_c -o $trg_c
// echo "Building C++ ..."
// $zig_cpp $src_cpp -o $trg_cpp
//
// # Run
// echo "Running C ..."
// $trg_c
// echo "Running C++ ..."
// $trg_cpp
//
