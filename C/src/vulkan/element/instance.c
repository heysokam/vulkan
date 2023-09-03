//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
// External dependencies
#include <GLFW/glfw3.h>
// cvk dependencies
#include "./instance.h"

// TODO: Error management
#define chk(a, b) discard(a)

// Mac Compatibility
#if defined(macosx)
#  define FlagsInstance VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR
#else
#  define FlagsInstance 0
#endif


VkInstance cvk_instance_create(cvk_instance_create_args in) {
  VkInstance result;
  // Get required extensions
  u32   extCount = 0;
  cstr* extNames = glfwGetRequiredInstanceExtensions(&extCount);
  if (!extNames) fail(1, "Couldn't find any Vulkan Extensions. Vk is not usable (probably not installed)");
  // Create the instance
  // clang-format off
  VkResult code = vkCreateInstance(&(VkInstanceCreateInfo){
    .sType                   = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    .pNext                   = NULL,
    .flags                   = FlagsInstance,
    .pApplicationInfo        = &(VkApplicationInfo){
      .sType                 = VK_STRUCTURE_TYPE_APPLICATION_INFO,
      .pNext                 = NULL,
      .pApplicationName      = in.appName,
      .applicationVersion    = in.appVers,
      .pEngineName           = in.engineName,
      .engineVersion         = in.engineVers,
      .apiVersion            = Cfg_ApiVersion,
       }, // << pApplicationInfo
    .enabledLayerCount       = Max_VulkanLayers,
    .ppEnabledLayerNames     = validationLayers,
    .enabledExtensionCount   = extCount,
    .ppEnabledExtensionNames = extNames,
     },
     NULL, &result);
  // clang-format on
  if (code != VK_SUCCESS) fail(code, "Failed to create Vulkan Instance");
  // chk(code, "Instance Creation"); /* ERROR HERE */
  return result;
}
