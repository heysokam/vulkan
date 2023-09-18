//:___________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:___________________________________________________
const std  = @import("std");
const glfw = @import("./lib/glfw.zig");

fn keyCB (win :?*glfw.Window, key :c_int, code :c_int, action :c_int, mods :c_int) callconv(.C) void {
  if (key == glfw.KeyEscape and (action == glfw.Press or action == glfw.Release)) glfw.windowSetClose(win, glfw.True);
  _ = mods;
  _ = code;
}

pub fn main() !void {
  // stdout for the output of the app, not for debugging messages.
  const stdout_file = std.io.getStdOut().writer();
  var bw = std.io.bufferedWriter(stdout_file);
  const stdout = bw.writer();
  try stdout.print("Hello zig.GLFW\n", .{});
  try bw.flush();

  // Initialize GLFW and Window
  _ = glfw.init();
  glfw.windowHint(glfw.ClientApi, glfw.NoApi);
  glfw.windowHint(glfw.Resizable, glfw.False);
  var win = glfw.createWindow(960,540, "Hello zig.GLFW", null, null);
  _ = glfw.setResizeCallback(win, null);
  // Input
  _ = glfw.setKeyCallback(win, keyCB);
  _ = glfw.setMouseBtnCallback(win, null);
  _ = glfw.setMousePosCallback(win, null);
  _ = glfw.setMouseScrollCallback(win, null);
  // Update loop
  while (glfw.windowShouldClose(win) == 0){
    glfw.pollEvents();
  }
  // Terminate GLFW and Window
  glfw.destroyWindow(win);
  glfw.terminate();
}
