//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// @deps External
const glfw = @import("../lib/glfw.zig");
// @deps z*std dependencies
const zstd = @import("../zstd.zig");
const cstr = zstd.cstr;
// @deps z*sys dependencies
const cb   = @import("./cb.zig");
const w    = @import("./window.zig");
const i    = @import("./input.zig");

pub const System = struct {
  win :w.Window,
  inp :i.Input,
  pub fn update (S :*System) void { S.win.update(); S.inp.update(); }
  pub fn close (S :*System) bool { return glfw.window.close(S.win.ct) != 0; }
  pub fn term (S :*System) void {
    // Terminate GLFW and Window
    glfw.window.destroy(S.win.ct);
    glfw.term();
  }
};

pub fn init(W :u32, H :u32, title :cstr) System {
  var result = System{.win= w.init(W,H,title), .inp= i.Input{} };
  result.inp = i.init(&result.win);
  return result;
}
