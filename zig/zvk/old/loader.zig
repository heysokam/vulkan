//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
pub const Loader = @This();
// @deps External
const vk   = @import("../../lib/vulkan.zig");
const glfw = @import("../../lib/glfw.zig"); 
// @deps zvk
const cfg = @import("../cfg.zig");
const zvk = struct {
  const Allocator = @import("./allocator.zig").Allocator;
  const Instance  = @import("./instance.zig").Instance;
};

// Pass the features list to the API wrappers to create dispatch tables.
const Base     = vk.BaseWrapper(cfg.features.list);
const Instance = vk.InstanceWrapper(cfg.features.list);
const Device   = vk.DeviceWrapper(cfg.features.list);


A        :zvk.Allocator,
base     :Loader.Base,
instance :*Loader.Instance,
device   :*Loader.Device,









pub fn create (A :zvk.Allocator) !Loader {
  var result :Loader= undefined;
  result.A        = A;
  result.base     = try Loader.load.base(glfw.vk.instance.getProc);
  result.instance = try result.A.zig.create(Loader.Instance);
  result.device   = try result.A.zig.create(Loader.Device);
  return result;
}







// pub fn create (A :zvk.Allocator) !Loader {
//   var result :Loader= undefined;
//   result.A        = A;
//   result.base     = try Loader.load.base(glfw.vk.instance.getProc);
//   result.instance = try result.A.zig.create(Loader.Instance);
//   result.device   = try result.A.zig.create(Loader.Device);
//   return result;
// }
//
const load = struct {
  const base = Loader.Base.load;
//   fn instance (L :*Loader, I :*zvk.Instance) !void {
//     I.ct = try L.base.createInstance(&I.cfg, L.A.vk);
//     L.instance.* = try Loader.Instance.load(I.ct, L.base.dispatch.vkGetInstanceProcAddr);
//     errdefer L.A.zig.destroy(L.instance);
//   }
//   fn device (L :*Loader, D :vk.Device) !void {
//     L.device.* = try Loader.Device.load(D, L.instance.dispatch.vkGetDeviceProcAddr);
//     errdefer L.A.zig.destroy(L.device);
//   }
};
//
// pub const loadInstance = Loader.load.instance;
// pub const loadDevice   = Loader.load.device;
//
// // Create the proxying wrappers, which also have their respective handles
// const proxy = struct {
//   const Instance = vk.InstanceProxy(cfg.features.list);
//   const Device   = vk.DeviceProxy(cfg.features.list);
// };
//
