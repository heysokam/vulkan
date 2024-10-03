//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// External dependencies
const glfw = @import("../zglfw.zig");
// z*sys dependencies
const cb   = @import("./cb.zig");
const w    = @import("./window.zig");

pub const Input = struct {
  _:void=undefined,
  pub fn update(I :*Input) void {_=I; glfw.sync(); }
};

pub fn init (win :*w.Window) Input {
  // Input
  _ = glfw.cb.setKey(win.ct, cb.key);
  _ = glfw.cb.setMouseBtn(win.ct, null);
  _ = glfw.cb.setMousePos(win.ct, null);
  _ = glfw.cb.setMouseScroll(win.ct, null);
  return Input{};
}
