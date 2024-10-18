//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Vulkan Validation Aliases
//__________________________________________|
// @deps std
const std = @import("std");
// @deps vulkan
const c       = @import("../lib/vulkan.zig");
const check   = @import("./result.zig");
const String  = @import("./types.zig").String;
const Debug   = @import("./types.zig").Debug;
const vk      = @import("./base.zig");
const vkFlags = @import("./flags.zig").flags;

pub const validation = struct {
  pub const LayerName :String= "VK_LAYER_KHRONOS_validation";
  const Layer  = c.VkLayerProperties;
  const Layers = []Layer;

  pub const instance = struct {
    pub fn getLayers (A :std.mem.Allocator) !validation.Layers {
      var count :u32= 0;
      try check.ok(c.vkEnumerateInstanceLayerProperties(&count, null));

      const result :validation.Layers= try A.alloc(validation.Layer, count);
      errdefer A.free(result);
      try check.ok(c.vkEnumerateInstanceLayerProperties(&count, result.ptr));
      return result;
    } //:: validation.instance.getLayers
  }; //:: validation.instance

  pub const debug = struct {
    pub const LayerName    :String= c.VK_EXT_DEBUG_UTILS_EXTENSION_NAME;
    pub const T            = Debug;
    pub const Cfg          = c.VkDebugUtilsMessengerCreateInfoEXT;
    pub const Callback     = c.PFN_vkDebugUtilsMessengerCallbackEXT;
    pub const CallbackData = [*c]const c.VkDebugUtilsMessengerCallbackDataEXT;
    pub const Data         = ?*anyopaque;
    pub const flags        = struct {
      pub const Create     = vkFlags.debug.Create;
      pub const Severity   = vkFlags.debug.Severity;
      pub const MsgType    = vkFlags.debug.MsgType;
      pub const C          = struct {
        pub const Create   = c.VkDebugUtilsMessengerCreateFlagsEXT;
        pub const Severity = c.VkDebugUtilsMessageSeverityFlagsEXT;
        pub const MsgType  = c.VkDebugUtilsMessageTypeFlagsEXT;
      }; //:: validation.debug.flags.C
    }; //:: validation.debug.flags
    pub const Fn           = struct {
      pub const Create     = c.PFN_vkCreateDebugUtilsMessengerEXT;
      pub const Destroy    = c.PFN_vkDestroyDebugUtilsMessengerEXT;
    }; //:: zvk.validation.debug.Fn

    pub fn setup (in:struct {
        flags     : flags.Create   = .{},
        severity  : flags.Severity = .{},
        msgType   : flags.MsgType  = .{},
        callback  : Callback       = null,
        userdata  : Data           = null,
      }) validation.debug.Cfg {
      return validation.debug.Cfg{
        .sType           = vk.stype.debug.Cfg,
        .pNext           = null,
        .flags           = in.flags.toInt(),
        .messageSeverity = in.severity.toInt(),
        .messageType     = in.msgType.toInt(),
        .pfnUserCallback = in.callback,
        .pUserData       = in.userdata,
        };
    } //:: validation.debug.setup
  }; //:: validation.debug
}; //:: validation

