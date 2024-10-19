//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @deps std
const std = @import("std");
// @deps vulkan
const c     = @import("../lib/vulkan.zig");
const vk    = @import("./types.zig");
const check = @import("./result.zig");

const Extensions = vk.CStringList;

pub const extensions = struct {
  pub const Properties  = c.VkExtensionProperties;
  pub const Portability = c.VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME;
  pub const DebugUtils  = c.VK_EXT_DEBUG_UTILS_EXTENSION_NAME;
  pub const Swapchain   = c.VK_KHR_SWAPCHAIN_EXTENSION_NAME;

  pub const instance = struct {
    pub fn all (A :std.mem.Allocator) !Extensions {
      var count :u32= 0;
      try check.ok(c.vkEnumerateInstanceExtensionProperties(null, &count, null));
      var exts :[*c]c.VkExtensionProperties= null;
      try check.ok(c.vkEnumerateInstanceExtensionProperties(null, &count, exts));

      // Create the result and return it
      var result = try Extensions.initCapacity(A, count);
      for (exts[0..count]) |ext| { try result.append(ext.extensionName[0..]); }
      return result;
    } // vkEnumerateInstanceExtensionProperties(pLayerName: [*c]const u8, pPropertyCount: [*c]u32, pProperties: [*c]VkExtensionProperties)

    // TODO: vk.extensions.instance.supported
    // pub fn supported (exts :vk.CStringList) !void {
    //   var count :u32= 0;
    //   try check.ok(c.vkEnumerateInstanceExtensionProperties(null, &count, null));
    //   var list :[*c]c.VkExtensionProperties= null;
    //   try check.ok(c.vkEnumerateInstanceExtensionProperties(null, &count, list));
    //
    //
    //   // const list = try extensions.instance.all(exts.allocator);
    //   for (exts.items) |ext| {
    //     if (list == null) break;
    //     std.debug.print("Searching: {s}\n", .{ext});
    //     for (list[0..count]) |it| {
    //       std.debug.print(".. comparing with: {s}\n", .{it.extensionName});
    //       if (std.mem.eql(u8, ext[0..255], &it.extensionName)) break;
    //     }
    //   }
    // } //:: instance.supported
  }; //:: instance
};


// TODO: vk.extensions.instance.EnumerateProperties
// const todo = struct {
//   pub const EnumeratePropertiesResult = struct {
//     result     :c.VkResult,
//     properties :[]c.VkExtensionProperties,
//   };
//
//   const EnumeratePropertiesError = error { VK_OUT_OF_HOST_MEMORY, VK_OUT_OF_DEVICE_MEMORY, VK_LAYER_NOT_PRESENT, VK_UNDOCUMENTED_ERROR };
//   inline fn EnumerateProperties (
//       pLayerName : ?vk.CString,
//       properties : []c.VkExtensionProperties,
//     ) EnumeratePropertiesError!EnumeratePropertiesResult {
//     var result :EnumeratePropertiesResult= undefined;
//     var count :u32= @intCast(properties.len);
//     const code = c.vkEnumerateInstanceExtensionProperties(pLayerName, &count, properties.ptr);
//     if (@as(c_int, code) < 0) {
//       return switch (code) {
//         .ERROR_OUT_OF_HOST_MEMORY   => error.VK_OUT_OF_HOST_MEMORY,
//         .ERROR_OUT_OF_DEVICE_MEMORY => error.VK_OUT_OF_DEVICE_MEMORY,
//         .ERROR_LAYER_NOT_PRESENT    => error.VK_LAYER_NOT_PRESENT,
//         else => error.VK_UNDOCUMENTED_ERROR,
//         };
//     }
//     result.properties = properties[0..count];
//     result.result = code;
//     return result;
//   }
//
//   inline fn EnumeratePropertiesCount (
//       pLayerName : ?vk.CString,
//     ) EnumeratePropertiesError!u32 {
//     var result :u32= undefined;
//     const code = c.vkEnumerateInstanceExtensionProperties(pLayerName, &result, null);
//     if (@as(c_int, code) < 0) {
//       return switch (code) {
//         .ERROR_OUT_OF_HOST_MEMORY   => error.VK_OUT_OF_HOST_MEMORY,
//         .ERROR_OUT_OF_DEVICE_MEMORY => error.VK_OUT_OF_DEVICE_MEMORY,
//         .ERROR_LAYER_NOT_PRESENT    => error.VK_LAYER_NOT_PRESENT,
//         else => error.VK_UNDOCUMENTED_ERROR,
//         };
//     }
//     return result;
//   }
// };

