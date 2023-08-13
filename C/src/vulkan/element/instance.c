//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
// External dependencies
#include <GLFW/glfw3.h>
// cvk dependencies
#include "./instance.h"

// TODO: Error management
#define chk(a, b) discard(a)

VkInstance cvk_instance_create(cvk_instance_create_args in) {
  VkInstance result;
  u32 extensionCount = 0;
  str *extensions = glfwGetRequiredInstanceExtensions(&extensionCount);
  // clang-format off
  VkResult code = vkCreateInstance(&(VkInstanceCreateInfo){
    .sType                   = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    .pNext                   = NULL,
    .flags                   = 0,
    .pApplicationInfo        = &(VkApplicationInfo){
      .sType                 = VK_STRUCTURE_TYPE_APPLICATION_INFO,
      .pNext                 = NULL,
      .pApplicationName      = in.appName,
      .applicationVersion    = in.appVers,
      .pEngineName           = in.engineName,
      .engineVersion         = in.engineVers,
      .apiVersion            = Cfg_ApiVersion,
       }, // << pApplicationInfo
    .enabledLayerCount       = 0,
    .ppEnabledLayerNames     = NULL,
    .enabledExtensionCount   = extensionCount,
    .ppEnabledExtensionNames = extensions,
     },
     NULL, &result);             // clang-format on
  chk(code, "Instance Creation"); /* ERROR HERE */
  return result;
}
