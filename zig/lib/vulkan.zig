//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Zig wrapper for Vulkan C
//_________________________________________|
const vk = @This();
const c = @cImport({@cInclude("vulkan/vulkan.h");});


//______________________________________
// @section General Types
//____________________________
pub const String    = [:0]const u8;  // pub const String = [*:0]const u8;
pub const SpirV     = [*:0]const u8; // vk.String; // []const u8; // [*:0]const u8;
pub const Allocator = c.VkAllocationCallbacks;
pub const Size      = c.VkExtent2D;
pub const Vol       = c.VkExtent3D;


//______________________________________
// @section Result Management
//____________________________
pub const result = struct {
  const T = c.VkResult;
};
pub const Result = vk.result.T;


//______________________________________
// @section Version Tools
//____________________________
pub const version = struct {
  pub const T     = u32;
  pub const Major = u7;
  pub const Minor = u10;
  pub const Patch = u12;
  pub const api     = struct {
    pub const v1_0  = c.VK_VERSION_1_0;
    pub const v1_1  = c.VK_API_VERSION_1_1;
    pub const v1_2  = c.VK_API_VERSION_1_2;
    pub const v1_3  = c.VK_API_VERSION_1_3;
  }; //:: vk.version.api

  pub fn new (
      M : vk.version.Major,
      m : vk.version.Minor,
      p : vk.version.Patch,
    ) vk.Version {
    return c.VK_MAKE_API_VERSION(0, M,m,p);
  } //:: zvk.version.new
}; //:: vk.version
pub const Version = vk.version.T;


//______________________________________
// @section Instance
//____________________________
pub const App = struct {
  pub const Cfg = c.VkApplicationInfo;
};  //:: vk.App

//______________________________________
// @section Instance
//____________________________
pub const Instance = vk.instance.T;
pub const instance = struct {
  pub const T       = c.VkInstance;
  pub const Cfg     = c.VkInstanceCreateInfo;
  pub const create  = c.vkCreateInstance;
  pub const destroy = c.vkDestroyInstance;
}; //:: vk.instance


//______________________________________
// @section Surface
//____________________________
pub const Surface = vk.surface.T;
pub const surface = struct {
  pub const T = c.VkSurfaceKHR;
  // pub const create = c.vkCreateInstance;
  pub const destroy = c.vkDestroySurfaceKHR;
}; //:: vk.surface


//______________________________________
// @section Swapchain
//____________________________
pub const Swapchain = vk.swapchain.T;
pub const swapchain = struct {
  pub const T = c.VkSwapchainKHR;
}; //:: vk.instance

