//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Command Tools
//______________________________|
// @deps vulkan
const c  = @import("../lib/vulkan.zig");
const vk = @This();

pub const sync = struct {
  pub const waitIdle = c.vkDeviceWaitIdle;

  pub const Fence = vk.sync.fence.T;
  pub const fence = struct {
   pub const T       = c.VkFence;
   pub const Cfg     = c.VkFenceCreateInfo;
   pub const create  = c.vkCreateFence;
   pub const destroy = c.vkDestroyFence;
   pub const wait    = c.vkWaitForFences;
   pub const reset   = c.vkResetFences;
  }; //:: vk.sync.fence

  pub const Semaphore = vk.sync.semaphore.T;
  pub const semaphore = struct {
   pub const T       = c.VkSemaphore;
   pub const Cfg     = c.VkSemaphoreCreateInfo;
   pub const create  = c.vkCreateSemaphore;
   pub const destroy = c.vkDestroySemaphore;
  }; //:: vk.sync.semaphore
}; //:: vk.sync

