//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @fileoverview Instance Tools
//_________________________________|
pub const instance = @This();
// @deps std
const std = @import("std");
// @deps vulkan
const c     = @import("../lib/vulkan.zig");
const check = @import("./result.zig");
const vk    = @import("./types.zig");


pub const Cfg      = c.VkInstanceCreateInfo;
pub const T        = vk.Instance;
pub const Instance = instance.T;
pub const getProc  = c.vkGetInstanceProcAddr;

pub fn create (
    info : *const c.VkInstanceCreateInfo,
    A    : ?*const c.VkAllocationCallbacks,
    I    : *c.VkInstance,
  ) !void {
  try check.ok(c.vkCreateInstance(info, A, I));
} //:: vkCreateInstance(pCreateInfo: [*c]const VkInstanceCreateInfo, pAllocator: [*c]const VkAllocationCallbacks, pInstance: [*c]VkInstance) VkResult;

pub const destroy = c.vkDestroyInstance; //:: vkDestroyInstance(instance: VkInstance, pAllocator: [*c]const VkAllocationCallbacks) void;

