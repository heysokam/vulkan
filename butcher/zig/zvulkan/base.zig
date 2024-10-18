//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @deps vulkan
const c = @import("../lib/vulkan.zig");

pub const stype              = struct {
  pub const app              = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_APPLICATION_INFO;
  }; //:: vk.stype.app
  pub const instance         = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
  }; //:: vk.stype.instance
  pub const debug            = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
  }; //:: vk.stype.debug
  pub const queue            = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
  }; //:: vk.stype.queue
  pub const swapchain        = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
  }; //:: vk.stype.swapchain
  pub const image            = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
    pub const view           = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
    }; //:: vk.stype.image.view
  }; //:: vk.stype.image
  pub const device           = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    pub const Features10     = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2;
    pub const Features11     = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_1_FEATURES;
    pub const Features12     = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_2_FEATURES;
    pub const Features13     = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_3_FEATURES;
  }; //:: vk.stype.device
  pub const command          = struct {
    pub const pool           = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
    }; //:: vk.stype.pool
    pub const buffer         = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    }; //:: vk.stype.buffer
  }; //:: vk.stype.command
  pub const sync             = struct {
    pub const fence          = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
    }; //:: vk.stype.fence
    pub const semaphore      = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
    }; //:: vk.stype.fence
  }; //:: vk.stype.sync
}; //:: vk.stype

