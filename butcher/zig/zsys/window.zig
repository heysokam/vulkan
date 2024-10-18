//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps External
const glfw = @import("../zglfw.zig");
// @deps z*sys
const cb   = @import("./cb.zig");

pub const Window = struct {
  ct    : ?*glfw.Window,
  W     : u32 = 960,
  H     : u32 = 540,
  title : []const u8 = "z*sys | Window",
  pub fn update(m :*Window) void {_=m;}
}; // << Window { }

pub fn init(W :u32, H :u32, title :[]const u8) !Window {
  var result = Window{
    .W     = W,
    .H     = H,
    .title = title,
    .ct    = null,
  };
  if (!glfw.init()) return error.glfw_InitFailed;
  if (!glfw.vk.supported()) {
    std.log.err("GLFW could not find libvulkan", .{});
    return error.NoVulkan;
  }
  glfw.window.hint(glfw.ClientApi, glfw.NoApi);
  glfw.window.hint(glfw.Resizable, glfw.False);
  result.ct = glfw.window.create(@intCast(result.W), @intCast(result.H), result.title.ptr, null, null);
  _ = glfw.cb.setResize(result.ct, null);
  return result;
}
