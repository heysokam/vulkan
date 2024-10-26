//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview General Vulkan Type Aliases
//____________________________________________|
const vk = @This();
// @deps std
const std = @import("std");
// @deps vulkan
const c = @import("../lib/vulkan.zig");

pub const String         = [:0]const u8;
pub const StringList     = std.ArrayList(String);
pub const CString        = [*:0]const u8;            // pub const String = [*:0]const u8;
pub const CStringList    = std.ArrayList(CString);   // pub const String = [*c][*c]const u8;
pub const SpirV          = [:0]const u32;
pub const Size           = c.VkExtent2D;
pub const Vol            = c.VkExtent3D;
pub const Null           = c.VK_NULL_HANDLE;
pub const Bool           = c.VkBool32;
pub const True           = c.VK_TRUE;
pub const False          = c.VK_FALSE;
pub fn    toBool         (b :bool) vk.Bool { return if (b) vk.True else vk.False; }
pub const Flags          = c.VkFlags;
pub const Flags64        = c.VkFlags64;
pub const Allocator      = c.VkAllocationCallbacks;
pub const Debug          = c.VkDebugUtilsMessengerEXT;
pub const Instance       = c.VkInstance;
pub const Device         = struct {
  pub const Logical      = c.VkDevice;
  pub const Physical     = c.VkPhysicalDevice;
  pub const Queue        = c.VkQueue;
}; //:: Device
pub const Image          = c.VkImage;
pub const ImageView      = c.VkImageView;
pub const share          = struct {
  pub const Mode         = c.VkSharingMode;
  pub const exclusive    = c.VK_SHARING_MODE_EXCLUSIVE; // VK_SHARING_MODE_EXCLUSIVE: c_int = 0;
  pub const concurrent   = c.VK_SHARING_MODE_CONCURRENT; // VK_SHARING_MODE_CONCURRENT: c_int = 1;
}; //:: vk.share

