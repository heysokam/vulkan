//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Command Tools
//______________________________|
// @deps vulkan
const c  = @import("../lib/vulkan.zig");
const vk = @This();

pub const command         = struct {

pub const Pool          = vk.command.pool.T;
pub const pool          = struct {
  pub const T           = c.VkCommandPool;
  pub const Cfg         = c.VkCommandPoolCreateInfo;
  pub const create      = c.vkCreateCommandPool;
  pub const destroy     = c.vkDestroyCommandPool;
}; //:: vk.command.pool

pub const Buffer        = vk.command.buffer.T;
pub const buffer        = struct {
  pub const T           = c.VkCommandBuffer;
  pub const Cfg         = c.VkCommandBufferAllocateInfo;
  pub const create      = c.vkAllocateCommandBuffers;
  pub const destroy     = c.vkFreeCommandBuffers;
  pub const level       = struct {
    pub const Primary   = c.VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    pub const Secondary = c.VK_COMMAND_BUFFER_LEVEL_SECONDARY;
  }; //:: vk.command.buffer.level
}; //:: vk.command.buffer

}; //:: vk.command

