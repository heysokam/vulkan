//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @fileoverview Swapchain Tools
//_________________________________|
// @deps vulkan
const c = @import("../lib/vulkan.zig");


//______________________________________
// @section Swapchain
//____________________________
pub const swapchain   = struct {
  pub const T         = c.VkSwapchainKHR;
  pub const Cfg       = c.VkSwapchainCreateInfoKHR;
  pub const create    = c.vkCreateSwapchainKHR;
  pub const destroy   = c.vkDestroySwapchainKHR;
  pub const images    = struct {
    pub const getList = c.vkGetSwapchainImagesKHR;
    pub const getNext = c.vkAcquireNextImageKHR;
  }; //:: vk.swapchain.images
}; //:: vk.swapchain
pub const Swapchain   = swapchain.T;

