//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
const system = @This();
// @deps External
const glfw = @import("../zglfw.zig");
// @deps z*std
const zstd = @import("../zstd.zig");
const cstr = zstd.cstr;
// @deps z*sys
const cb     = @import("./cb.zig");
const Window = @import("./window.zig").Window;
const Input  = @import("./input.zig").Input;
const Time   = @import("./time.zig").Clock;

pub const System = struct {
  win   :system.Window,
  inp   :system.Input,
  time  :system.Time,
  pub fn update (S :*System) void { S.win.update(); S.inp.update(); }
  pub fn close (S :*System) bool { return glfw.window.close(S.win.ct); }
  pub fn term (S :*System) void {
    // Terminate GLFW and Window
    glfw.window.destroy(S.win.ct);
    glfw.term();
    S.time.reset();
  } //:: zsys.System.term

  pub fn init (W :u32, H :u32, title :cstr) !System {
    var result = System{
      .time = try system.Time.start(),
      .win  = try system.Window.init(W,H,title),
      .inp  = undefined,
       }; //:: result
    result.inp = system.Input.init(&result.win);
    return result;
  } //:: zsys.System.init
}; //:: zsys.System

