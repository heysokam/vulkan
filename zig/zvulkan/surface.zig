//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @fileoverview Surface Tools
//_________________________________|
// @deps vulkan
const c = @import("../lib/vulkan.zig");

pub const surface = struct {
  pub const T            = c.VkSurfaceKHR;
  pub const Capabilities = c.VkSurfaceCapabilitiesKHR;
  pub const Format       = c.VkSurfaceFormatKHR;
  pub const destroy      = c.vkDestroySurfaceKHR;
}; //:: vk.surface
pub const Surface = surface.T;

