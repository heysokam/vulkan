//:____________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
const std = @import("std");
const glfw = @import("../zglfw.zig");

pub fn err (_:c_int, descr :[*c]const u8) callconv(.C) void {
  std.debug.panic("[glfw.Error] {s}\n", .{descr});
}

pub fn key (win :?*glfw.Window, K :c_int, code :c_int, action :c_int, mods :c_int) callconv(.C) void {_=mods;_=code;
  if (K == glfw.key.Escape and (action == glfw.Press or action == glfw.Release)) glfw.window.setClose(win, glfw.True);
}

