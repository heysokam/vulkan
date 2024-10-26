//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Vulkan Color Types and Tools
//_____________________________________________|
// @deps std
const std = @import("std");
// @deps vulkan
const c = @import("../lib/vulkan.zig");
const vk     = @import("./types.zig");
const FlagsT = @import("./flags.zig").flags.T;


pub const Color           = color.T;
pub const color           = struct {
  pub const T             = c.VkComponentMapping;

  pub const space         = struct {
    pub const T           = c.VkColorSpaceKHR;
    pub const srgb        = struct {
      pub const nonLinear = c.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR;
    }; //:: vk.color.space.srgb
  }; //:: vk.color.space
  pub const Space         = color.space.T;

  pub const format        = struct {
    pub const T           = c.VkFormat;
    pub const srgb        = struct {
      pub const BGRA8     = c.VK_FORMAT_B8G8R8A8_SRGB;
    }; //:: vk.color.format.srgb
    pub const unorm       = struct {
      pub const BGRA8     = c.VK_FORMAT_B8G8R8A8_UNORM;
    }; //:: vk.color.format.srgb
  }; //:: vk.color.format
  pub const Format        = color.format.T;

  pub const component     = struct {
    pub const Mapping     = c.VkComponentMapping;
    pub const Identity    = c.VK_COMPONENT_SWIZZLE_IDENTITY;
    pub const Zero        = c.VK_COMPONENT_SWIZZLE_ZERO;
    pub const One         = c.VK_COMPONENT_SWIZZLE_ONE;
    pub const R           = c.VK_COMPONENT_SWIZZLE_R;
    pub const G           = c.VK_COMPONENT_SWIZZLE_G;
    pub const B           = c.VK_COMPONENT_SWIZZLE_B;
    pub const A           = c.VK_COMPONENT_SWIZZLE_A;
    pub const Flags       = packed struct {
      r  :bool = false,  // 00 :: VK_COLOR_COMPONENT_R_BIT: c_int = 1;
      g  :bool = false,  // 01 :: VK_COLOR_COMPONENT_G_BIT: c_int = 2;
      b  :bool = false,  // 02 :: VK_COLOR_COMPONENT_B_BIT: c_int = 4;
      a  :bool = false,  // 03 :: VK_COLOR_COMPONENT_A_BIT: c_int = 8;
      __reserved_bits_04_31 :u28=0,
      pub usingnamespace FlagsT(@This(), vk.Flags);
      pub const rgba = color.component.Flags{.r=true, .g=true, .b=true, .a=true};
    }; //:: vk.color.component.Flags
  }; //:: vk.color.component
}; //:: vk.color

