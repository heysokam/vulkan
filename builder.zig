//:_____________________________________________________________________________________
//  Vulkan: All-the-Things  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:_____________________________________________________________________________________
// @deps zstd
const zstd = @import("./build/confy/src/lib/zstd.zig");
const sh   = zstd.shell;
const echo = zstd.echo;
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


//______________________________________
// @section Build: Configuration
//____________________________
const alwaysClean = false;
const verbose     = false;
const dir         = struct {
  const bin       = "bin";
  const C         = "./c";
  const Cpp       = "./cpp";
  const Zig       = "./zig";
  const glfw      = "./lib/glfw";
}; //:: dir
const run         = struct {
  const C         = false;
  const Cpp       = false;
  const Zig       = true;
  const Rust      = false;
}; //:: run


//______________________________________
// @section Build: Entry Point
//____________________________
pub fn main () !u8 {
  // Initialize the confy builder
  var builder = try confy.init(); defer builder.term();
  P.report();
  //______________________________________
  // @section Define Targets
  //____________________________
  var C = try confy.Program(.{
    .trg     = "vk_c",
    .entry   = dir.C++"/entry.c",
    .version = P.version,
    .flags   = glfw.flags,
    }, &builder);
  //__________________
  var Cpp = try confy.Program(.{
    .trg     = "vk_cpp",
    .entry   = dir.Cpp++"/entry.cpp",
    .version = P.version,
    .flags   = glfw.flags,
    }, &builder);
  //__________________
  var Zig = try confy.Program(.{
    .trg     = "vk_zig",
    .entry   = dir.Zig++"/entry.zig",
    .version = P.version,
    .flags   = glfw.flags,
    }, &builder);
  //__________________
  const rust = struct {
    const bin = "vk_rust";
    const trg = dir.bin++"/debug/"++bin;
    fn build (B :*confy.Confy) !void { echo("ᛝ confy: Building "++trg); try sh.run(&.{"cargo", "build", "--target-dir", dir.bin, "--bin", bin}, B.A.allocator()); }
    fn run   (B :*confy.Confy) !void { echo("ᛝ confy: Running "++trg); try sh.run(&.{trg}, B.A.allocator()); }
  }; //:: rust

  //______________________________________
  // @section Build Dependencies
  //____________________________
  try glfw.build(&builder);
  //______________________________________
  // @section Build Targets
  //____________________________
  if (run.C   ) { try C.build();   try C.run();   }
  if (run.Cpp ) { try Cpp.build(); try Cpp.run(); }
  if (run.Zig ) { try Zig.build(); try Zig.run(); }
  if (run.Rust) { try rust.build(&builder); try rust.run(&builder); }
  return 0;
}

//______________________________________
// @section Dependencies: GLFW
//____________________________
const glfw = struct {
  const flags = .{ .cc=&.{"-I./lib/glfw/include"}, .ld= &.{"-L./lib/glfw/build/src", "-lm", "-lglfw3", "-lvulkan"}, };

  fn build (b :*confy.Confy) !void {
    const srcDir = dir.glfw;
    const binDir = srcDir++"/build";

    // Clean before running
    var clean = zstd.shell.Cmd.create(b.A.allocator());
    defer clean.destroy();
    try clean.addList(&.{"rm", "-rf", binDir});
    if (alwaysClean) try clean.run();

    // Run cmake to generate the builder
    var cmake = zstd.shell.Cmd.create(b.A.allocator());
    defer cmake.destroy();
    try cmake.addList(&.{"cmake", "-S", srcDir, "-B", binDir});
    try cmake.run();

    // Run make to build
    var make = zstd.shell.Cmd.create(b.A.allocator());
    defer make.destroy();
    try make.addList(&.{"make", "-j8", "-C", binDir, "glfw"});
    try make.run();
  }
};

