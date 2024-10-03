//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @fileoverview Surface Tools
//_________________________________|
pub const surface = @This();
// @deps vulkan
const c = @import("../lib/vulkan.zig");

pub const Surface = surface.T;
pub const T = c.VkSurfaceKHR;
// pub const create = c.vkCreateInstance;
pub const destroy = c.vkDestroySurfaceKHR;

