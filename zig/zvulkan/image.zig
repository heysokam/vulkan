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

  pub const View          = image.view.T;
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

  pub const Layout                               = enum(c_int) {
    undefined                                    =          0,  // VK_IMAGE_LAYOUT_UNDEFINED                                      :c_int=           0;
    general                                      =          1,  // VK_IMAGE_LAYOUT_GENERAL                                        :c_int=           1;
    color_attachment_optimal                     =          2,  // VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL                       :c_int=           2;
    depthStencil_attachment_optimal              =          3,  // VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL               :c_int=           3;
    depthStencil_read_only_optimal               =          4,  // VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL                :c_int=           4;
    shader_readOnly_optimal                      =          5,  // VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL                       :c_int=           5;
    transfer_src_optimal                         =          6,  // VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL                           :c_int=           6;
    transfer_dst_optimal                         =          7,  // VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL                           :c_int=           7;
    preinitialized                               =          8,  // VK_IMAGE_LAYOUT_PREINITIALIZED                                 :c_int=           8;
    present_src                                  = 1000001002,  // VK_IMAGE_LAYOUT_PRESENT_SRC_KHR                                :c_int=  1000001002;
    video_decode_dst                             = 1000024000,  // VK_IMAGE_LAYOUT_VIDEO_DECODE_DST_KHR                           :c_int=  1000024000;
    video_decode_src                             = 1000024001,  // VK_IMAGE_LAYOUT_VIDEO_DECODE_SRC_KHR                           :c_int=  1000024001;
    video_decode_dpb                             = 1000024002,  // VK_IMAGE_LAYOUT_VIDEO_DECODE_DPB_KHR                           :c_int=  1000024002;
    present_shared                               = 1000111000,  // VK_IMAGE_LAYOUT_SHARED_PRESENT_KHR                             :c_int=  1000111000;
    depth_readOnly_stencil_attachment_optimal    = 1000117000,  // VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL     :c_int=  1000117000;
    depth_attachment_stencil_readOnly_optimal    = 1000117001,  // VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL     :c_int=  1000117001;
    fragment_shadingRate_attachment_optimal      = 1000164003,  // VK_IMAGE_LAYOUT_FRAGMENT_SHADING_RATE_ATTACHMENT_OPTIMAL_KHR   :c_int=  1000164003;
    fragment_densityMap_optimal                  = 1000218000,  // VK_IMAGE_LAYOUT_FRAGMENT_DENSITY_MAP_OPTIMAL_EXT               :c_int=  1000218000;
    rendering_local_read                         = 1000232000,  // VK_IMAGE_LAYOUT_RENDERING_LOCAL_READ_KHR                       :c_int=  1000232000;
    depth_attachment_optimal                     = 1000241000,  // VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL                       :c_int=  1000241000;
    depth_readOnly_optimal                       = 1000241001,  // VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_OPTIMAL                        :c_int=  1000241001;
    stencil_attachment_optimal                   = 1000241002,  // VK_IMAGE_LAYOUT_STENCIL_ATTACHMENT_OPTIMAL                     :c_int=  1000241002;
    stencil_readOnly_optimal                     = 1000241003,  // VK_IMAGE_LAYOUT_STENCIL_READ_ONLY_OPTIMAL                      :c_int=  1000241003;
    video_encode_dst                             = 1000299000,  // VK_IMAGE_LAYOUT_VIDEO_ENCODE_DST_KHR                           :c_int=  1000299000;
    video_encode_src                             = 1000299001,  // VK_IMAGE_LAYOUT_VIDEO_ENCODE_SRC_KHR                           :c_int=  1000299001;
    video_encode_dpb                             = 1000299002,  // VK_IMAGE_LAYOUT_VIDEO_ENCODE_DPB_KHR                           :c_int=  1000299002;
    readOnly_optimal                             = 1000314000,  // VK_IMAGE_LAYOUT_READ_ONLY_OPTIMAL                              :c_int=  1000314000;
    attachment_optimal                           = 1000314001,  // VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL                             :c_int=  1000314001;
    attachment_feedbackLoop_optimal              = 1000339000,  // VK_IMAGE_LAYOUT_ATTACHMENT_FEEDBACK_LOOP_OPTIMAL_EXT           :c_int=  1000339000;
  }; //:: vk.image.Layout
}; //:: vk.image

