//:____________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
pub const Input = @This();
// @deps zdk
const glfw = @import("../zglfw.zig");
// z*sys dependencies
const cb   = @import("./cb.zig");
const w    = @import("./window.zig");

_:void=undefined,

pub fn update (I :*const Input) void {_=I; glfw.sync(); }

pub fn init (win :*const w.Window) !Input {
  // Input
  try glfw.cb.setKey(win.ct, cb.key);
  try glfw.cb.setMouseBtn(win.ct, null);
  try glfw.cb.setMousePos(win.ct, null);
  try glfw.cb.setMouseScroll(win.ct, null);
  return Input{};
} //:: zsys.Input.init

