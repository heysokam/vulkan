//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
pub const Instance = @This();
// @deps std
const std = @import("std");
// @deps External
const vk   = @import("../../lib/vulkan.zig");
const glfw = @import("../../lib/glfw.zig");
// @deps zvk
const zvk = struct {
  const Allocator = @import("./allocator.zig").Allocator;
  const Loader    = @import("./loader.zig").Loader;
  const app       = @import("./application.zig").app;
};

//______________________________________
// @section Instance
//____________________________
A    :zvk.Allocator,
ct   :vk.Instance,
cfg  :Instance.Cfg,
pub const Cfg = vk.InstanceCreateInfo;

pub fn create (
    loader  : *zvk.Loader,
    appCfg  : zvk.app.Cfg,
    A       : zvk.Allocator,
  ) !Instance {
  errdefer A.zig.destroy(loader.instance);
  // Get Extensions
  var extCount :u32= 0;
  const exts = glfw.vk.instance.getExts(&extCount);
  // Get Layers
  // Create the result
  var result = Instance{
    .A   = A,
    .ct  = undefined,
    .cfg = Instance.Cfg{
      .flags                      = .{},
      .p_application_info         = &appCfg,
      .enabled_layer_count        = 0,
      .pp_enabled_layer_names     = null,
      .enabled_extension_count    = extCount,
      .pp_enabled_extension_names = @ptrCast(exts),
      }, //:: .cfg
    }; //:: result
  try loader.loadInstance(&result);
  return result;
}
pub fn destroy (I :*Instance, A :std.mem.Allocator) void { A.destroy(I.ct); }

