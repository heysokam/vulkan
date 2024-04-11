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
  _ = glfw.setKeyCB(win.ct, cb.key);
  _ = glfw.setMouseBtnCB(win.ct, null);
  _ = glfw.setMousePosCB(win.ct, null);
  _ = glfw.setMouseScrollCB(win.ct, null);
  return Input{};
}
