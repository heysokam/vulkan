//:____________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
pub const System = @This();
// @deps External
const glfw = @import("../zglfw.zig");
// @deps z*std
const zstd = @import("../zstd.zig");
const cstr = zstd.cstr;
// @deps z*sys
const cb      = @import("./cb.zig");
const Window  = @import("./window.zig");
const Input   = @import("./input.zig");
const Time    = @import("./time.zig").Clock;
const Options = @import("./options.zig");

win   :System.Window,
inp   :System.Input,
time  :System.Time,
api   :System.Options.Api,

pub fn present (S :*const System) void { if (S.api == .gl) S.win.present(); }
pub fn update (S :*System) void { S.win.update(); S.inp.update(); }
pub fn close (S :*const System) bool { return glfw.window.close(S.win.ct); }
pub fn term (S :*System) void {
  // Terminate GLFW, Window and Time
  glfw.window.destroy(S.win.ct);
  glfw.term();
  S.time.reset();
} //:: zsys.System.term

pub fn init2 (in :Options) !System {
  var result = System{
    .time  = try System.Time.start(),
    .api   = in.api,
    .win   = try System.Window.init(in.win, in.api, in.gl),
    .inp   = undefined,
     }; //:: result
  result.inp = try System.Input.init(&result.win);
  return result;
} //:: zsys.System.init2

pub fn init (W :u32, H :u32, title :cstr) !System { return System.init2(.{
  .win     = .{
    .title = title,
    .size  = .{.W= W, .H= H}} });
} //:: zsys.System.init

