//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// External dependencies
const glfw = @import("../lib/glfw.zig");
// z*sys dependencies
const cb   = @import("./cb.zig");
const w    = @import("./window.zig");

pub const Input = struct {
  pub fn update(m :*Input) void {_=m; glfw.pollEvents(); }
};

pub fn init(win :*w.Window) Input {
  // Input
  _ = glfw.setKeyCallback(win.ct, cb.key);
  _ = glfw.setMouseBtnCallback(win.ct, null);
  _ = glfw.setMousePosCallback(win.ct, null);
  _ = glfw.setMouseScrollCallback(win.ct, null);
  return Input{};
}
