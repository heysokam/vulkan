//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @fileoverview Instance Tools
//_________________________________|
pub const instance = @This();
// @deps vulkan
const c = @import("../lib/vulkan.zig");

pub const T        = c.VkInstance;
pub const Cfg      = c.VkInstanceCreateInfo;
pub const create   = c.vkCreateInstance;
pub const destroy  = c.vkDestroyInstance;
pub const Instance = instance.T;

