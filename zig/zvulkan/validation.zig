//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Vulkan Validation Aliases
//__________________________________________|
// @deps std
const std = @import("std");
// @deps vulkan
const c     = @import("../lib/vulkan.zig");
const check = @import("./result.zig");

pub const validation = struct {
  pub const LayerName = "VK_LAYER_KHRONOS_validation";

  // pub const instance = struct {
  //   const Layers = []c.VkLayerProperties;
  //
  //   inline fn EnumerateProperties (
  //       properties : []c.VkLayerProperties,
  //     ) !validation.instance.Layers {
  //     var count :u32= @intCast(properties.len);
  //     try check.ok(c.vkEnumerateInstanceLayerProperties(&count, properties.ptr));
  //     return properties[0..count];
  //   }
  //
  //   inline fn EnumeratePropertiesCount () !u32 {
  //     var result :u32= undefined;
  //     try check.ok(c.vkEnumerateInstanceLayerProperties(&result, null));
  //     return result;
  //   }
  //
  //   pub fn getLayers () !void {
  //     var result :validation.instance.Layers= undefined;
  //     const count = try validation.instance.EnumeratePropertiesCount();
  //     result = try validation.instance.EnumerateProperties(result);
  //   }
  // }; //:: validation.instance
}; //:: validation

