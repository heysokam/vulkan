//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
const vk = @import("../lib/vulkan.zig");

pub const Vulkan = struct {
  instance :vk.Instance,
  pub fn update(m :*Vulkan) void {_=m;}
  pub fn term  (m :*Vulkan) void {_=m;}
};

pub fn init() Vulkan {
  var result = Vulkan{.instance=null};
  _ = vk.instance.create(
    &vk.instance.defaults(&vk.app.defaults()),
    // vk.app.Cfg{
    //   .pApplicationName   = "Hello z*vk Triangle",
    //   .applicationVersion = vk.version.new(1, 0, 0),
    //   .pEngineName        = "Hello z*vk Triangle Engine",
    //   .engineVersion      = vk.version.new(1, 0, 0),
    //   },
    null,
    &result.instance,
  ); // << vk.instance_create(InstanceCfg{ ... })
  return result;
}
