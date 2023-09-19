//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
const vk = @import("../lib/vulkan.zig");

pub const Vulkan = struct {
  instance :vk.Instance,
  pub fn update(m :*Vulkan) void {_=m;}
  pub fn term  (m :*Vulkan) void {_=m;}
};
pub fn init() Vulkan { return Vulkan{.instance=null}; }
