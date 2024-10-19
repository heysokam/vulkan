//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Vulkan Image and ImageView Tools
//__________________________________________________|
// @deps std
const std = @import("std");
// @deps vulkan
const c = @import("../lib/vulkan.zig");
const vk = @import("./types.zig");


pub const image           = struct {
  pub const T             = vk.Image;
  pub const Cfg           = c.VkImageCreateInfo;
  pub const create        = c.vkCreateImage;
  pub const destroy       = c.vkDestroyImage;
  pub const Subresource   = c.VkImageSubresourceRange;

  pub const view          = struct {
    pub const T           = vk.ImageView;
    pub const Cfg         = c.VkImageViewCreateInfo;
    pub const create      = c.vkCreateImageView;
    pub const destroy     = c.vkDestroyImageView;

    pub const types       = struct {
      pub const dim1D     = c.VK_IMAGE_VIEW_TYPE_1D;
      pub const dim2D     = c.VK_IMAGE_VIEW_TYPE_2D;
      pub const dim3D     = c.VK_IMAGE_VIEW_TYPE_3D;
      pub const cube      = c.VK_IMAGE_VIEW_TYPE_CUBE;
      pub const array1D   = c.VK_IMAGE_VIEW_TYPE_1D_ARRAY;
      pub const array2D   = c.VK_IMAGE_VIEW_TYPE_2D_ARRAY;
      pub const arrayCube = c.VK_IMAGE_VIEW_TYPE_CUBE_ARRAY;
    }; //:: vk.image.view.types
  }; //:: vk.image.view
}; //:: vk.image

