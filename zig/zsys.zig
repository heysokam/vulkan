//:____________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Cable connector to the z*sys modules
//_____________________________________________________|
pub const zsys = @This();
pub usingnamespace @import("./zsys/core.zig");
pub const gl = struct {
  pub const getProc = @import("./zglfw.zig").opengl.getProc;
};

pub const vk = struct {
  pub const getProc = @import("./zglfw.zig").vk.getProc;
};

