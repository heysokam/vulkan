//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps Vulkan
const C = @cImport(@cInclude("vulkan/vulkan.h"));

//______________________________________
// @section General Tools
//____________________________
pub const version   = struct {
  pub const api     = struct {
    pub const v1_0  = C.VK_API_VERSION_1_0;
  };
  pub const Default = api.v1_0;
  pub const new     = C.VK_MAKE_VERSION;
};

//______________________________________
// @section Application
//____________________________
pub const app = struct {
  pub const Cfg = C.VkApplicationInfo;
  pub fn defaults() app.Cfg {
    return app.Cfg{
      .sType              = C.VK_STRUCTURE_TYPE_APPLICATION_INFO,
      .pNext              = null,
      .pApplicationName   = "zvk.Application",
      .applicationVersion = version.new(1, 0, 0),
      .pEngineName        = "zvk.Engine",
      .engineVersion      = version.new(1, 0, 0),
      .apiVersion         = version.api.v1_0,
      }; // << C.VkApplicationInfo{ ... }
  }
};

//______________________________________
// @section Instance
//____________________________
pub const Instance = struct {
  ct  : C.VkInstance,
  cfg : C.VkInstanceCreateInfo,
  pub fn create  () void {}
  pub fn destroy (m :*Instance) void {_=m;}
};

// pub const Instance = ;
// pub const instance = struct {
//   pub fn defaults(appCfg :*const app.Cfg) instance.Cfg {
//     return instance.Cfg{
//       .sType                   = C.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
//       .pNext                   = null,
//       .flags                   = 0,
//       .pApplicationInfo        = appCfg, // const VkApplicationInfo*
//       .enabledLayerCount       = 0, // uint32_t
//       .ppEnabledLayerNames     = null, // const char* const*
//       .enabledExtensionCount   = 0, // uint32_t
//       .ppEnabledExtensionNames = null, // const char* const*
//       };
//   }
//   pub const create  = C.vkCreateInstance;
//   pub const destroy = C.vkDestroyInstance;
// };
