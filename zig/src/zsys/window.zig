//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// External dependencies
const glfw = @import("../lib/glfw.zig");
// z*sys dependencies
const cb   = @import("./cb.zig");

pub const Window = struct {
  ct    : ?*glfw.Window,
  W     : u32 = 960,
  H     : u32 = 540,
  title : []const u8 = "z*sys | Window",
  pub fn update(m :*Window) void {_=m;}
}; // << Window { }

pub fn init(W :u32, H :u32, title :[]const u8) Window {
  var result = Window{
    .W     = W,
    .H     = H,
    .title = title,
    .ct    = null,
  };
  _ = glfw.init();
  glfw.windowHint(glfw.ClientApi, glfw.NoApi);
  glfw.windowHint(glfw.Resizable, glfw.False);
  result.ct = glfw.createWindow(@intCast(result.W), @intCast(result.H), result.title.ptr, null, null);
  _ = glfw.setResizeCallback(result.ct, null);
  return result;
}
