//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// External dependencies
const glfw = @import("../lib/glfw.zig");
// z*sys dependencies
const cb   = @import("./cb.zig");
const w    = @import("./window.zig");
const i    = @import("./input.zig");

pub const System = struct {
  win :w.Window,
  inp :i.Input,
  pub fn update(m :*System) void { m.win.update(); m.inp.update(); }
  pub fn close(m :*System) bool { return glfw.windowShouldClose(m.win.ct) != 0; }
  pub fn term(m :*System) void {
    // Terminate GLFW and Window
    glfw.destroyWindow(m.win.ct);
    glfw.terminate();
  }
};

pub fn init(W :u32, H :u32, title :[]const u8) System {
  var result = System { .win = w.init(W,H,title), .inp=i.Input{} };
  result.inp = i.init(&result.win);
  return result;
}
