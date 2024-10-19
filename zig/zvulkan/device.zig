//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @deps std
const std = @import("std");
// @deps vulkan
const c     = @import("../lib/vulkan.zig");
const vk    = @import("./types.zig");
const check = @import("./result.zig");
const ext   = @import("./extensions.zig").extensions;

pub const device                       = struct {
  pub const Logical                    = vk.Device.Logical;
  pub const Physical                   = vk.Device.Physical;
  pub const Queue                      = vk.Device.Queue;

  pub const extensions                 = struct {
    pub const Properties               = ext.Properties;
    pub const getProperties            = c.vkEnumerateDeviceExtensionProperties;
  }; //:: vk.device.extensions

  pub const physical                   = struct {
    pub const Features                 = c.VkPhysicalDeviceFeatures;
    pub const Properties               = c.VkPhysicalDeviceProperties;
    pub const getList                  = c.vkEnumeratePhysicalDevices;
    pub const getFeatures              = c.vkGetPhysicalDeviceFeatures;
    pub const getProperties            = c.vkGetPhysicalDeviceProperties;
    pub const surface                  = struct {
      pub const getSupport             = c.vkGetPhysicalDeviceSurfaceSupportKHR;
      pub const getCapabilities        = c.vkGetPhysicalDeviceSurfaceCapabilitiesKHR;
      pub const getFormats             = c.vkGetPhysicalDeviceSurfaceFormatsKHR;
      pub const getPresentModes        = c.vkGetPhysicalDeviceSurfacePresentModesKHR;
    }; //:: vk.device.physical.surface

    pub const types                    = struct {
      pub const Other                  = c.VK_PHYSICAL_DEVICE_TYPE_OTHER;
      pub const Integrated             = c.VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU;
      pub const Discrete               = c.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU;
      pub const Virtual                = c.VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU;
      pub const CPU                    = c.VK_PHYSICAL_DEVICE_TYPE_CPU;
      pub const MAX                    = c.VK_PHYSICAL_DEVICE_TYPE_MAX_ENUM;
    }; //:: vk.device.physical.types
  }; //:: vk.device.physical

  pub const logical                    = struct {
    pub const Cfg                      = c.VkDeviceCreateInfo;
    pub const create                   = c.vkCreateDevice;
    pub const destroy                  = c.vkDestroyDevice;
  }; //:: vk.device.logical

  pub const present                    = struct {
    pub const Mode                     = c.VkPresentModeKHR;
    pub const Immediate                = c.VK_PRESENT_MODE_IMMEDIATE_KHR;
    pub const Mailbox                  = c.VK_PRESENT_MODE_MAILBOX_KHR;
    pub const Fifo                     = c.VK_PRESENT_MODE_FIFO_KHR;
    pub const Fifo_relaxed             = c.VK_PRESENT_MODE_FIFO_RELAXED_KHR;
    pub const SharedRefresh_demand     = c.VK_PRESENT_MODE_SHARED_DEMAND_REFRESH_KHR;
    pub const SharedRefresh_continuous = c.VK_PRESENT_MODE_SHARED_CONTINUOUS_REFRESH_KHR;
  };//:: vk.device.present

  pub const queue                      = struct {
    pub const Cfg                      = c.VkDeviceQueueCreateInfo;
    pub const get                      = c.vkGetDeviceQueue;
    pub const family                   = struct {
      pub const Properties             = c.VkQueueFamilyProperties;
      pub const getProperties          = c.vkGetPhysicalDeviceQueueFamilyProperties;
    }; //:: vk.device.queue.family
  }; //:: vk.device.queue
}; //:: vk.device

