//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Vulkan Features Types and Tools
//________________________________________________|
// @deps std
const std = @import("std");
// @deps vulkan
const c  = @import("../lib/vulkan.zig");
const vk = @import("./types.zig");

pub const features = struct {
  pub const V13  = c.VkPhysicalDeviceVulkan13Features;
  pub const V12  = c.VkPhysicalDeviceVulkan12Features;
  pub const V11  = c.VkPhysicalDeviceVulkan11Features;
  pub const V10  = c.VkPhysicalDeviceFeatures;
  pub const Root = c.VkPhysicalDeviceFeatures2;
}; //:: vk.features

