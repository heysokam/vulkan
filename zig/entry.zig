//:_____________________________________________________________________________________
//  Vulkan: All-the-Things  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:_____________________________________________________________________________________
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("./zstd.zig");
const zsys = @import("./zsys.zig");
const zvk  = @import("./zvk.zig").zvk;


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
const shd = struct {
  const vert align(@alignOf(u32)) = @embedFile("shd_vert").*;
  const frag align(@alignOf(u32)) = @embedFile("shd_frag").*;
};
const appName = "Zig | Vulkan-All-the-Things | Triangle";
var size      = zvk.Size{.width= 960, .height= 540};

//______________________________________
// @section Entry Point
//____________________________
pub fn main () !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  // const A = zgpu.Allocator.create(arena.allocator());

  try zstd.echo("Hello zvk Entry");
  try zstd.echo(appName);
  var sys = try zsys.init(size.width, size.height, appName);
  // var gpu = try zgpu.init(.{
  //   .appName    = appName,
  //   .appVers    = zgpu.version.new(0, 0, 1),
  //   .engineName = "z*gpu | Triangle Engine",
  //   .engineVers = zgpu.version.new(0, 0, 1),
  //   }, A);
  while (!sys.close()) {
    sys.update();
    // gpu.update();
    }
  // gpu.term();
  sys.term();
} //:: main

