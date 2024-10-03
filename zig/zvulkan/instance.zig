//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @fileoverview Instance Tools
//_________________________________|
pub const instance = @This();
// @deps vulkan
const c = @import("../lib/vulkan.zig");
const check = @import("./result.zig");

pub const T        = c.VkInstance;
pub const Cfg      = c.VkInstanceCreateInfo;

pub const CreateError = error{
  OutOfHostMemory,
  OutOfDeviceMemory,
  InitializationFailed,
  LayerNotPresent,
  ExtensionNotPresent,
  IncompatibleDriver,
  Unknown,
};

pub fn create (
    info : *const c.VkInstanceCreateInfo,
    A    : ?*const c.VkAllocationCallbacks,
    I    : *c.VkInstance
  ) !void {
  try check.ok(c.vkCreateInstance(info, A, I));
}  //:: vkCreateInstance(pCreateInfo: [*c]const VkInstanceCreateInfo, pAllocator: [*c]const VkAllocationCallbacks, pInstance: [*c]VkInstance) VkResult;
pub const destroy  = c.vkDestroyInstance;
pub const Instance = instance.T;

