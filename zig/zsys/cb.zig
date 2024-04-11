//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
const glfw = @import("../lib/glfw.zig");

pub fn key (win :?*glfw.Window, K :c_int, code :c_int, action :c_int, mods :c_int) callconv(.C) void {_=mods;_=code;
  if (K == glfw.KeyEscape and (action == glfw.Press or action == glfw.Release)) glfw.windowSetClose(win, glfw.True);
}

