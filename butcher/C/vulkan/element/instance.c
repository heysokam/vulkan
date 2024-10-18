//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// External dependencies
#include <GLFW/glfw3.h>
// c*vk dependencies
#include "./instance.h"


// Mac Compatibility
#if defined(macosx)
#  define FlagsInstance VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR
#else
#  define FlagsInstance 0
#endif


/// List of our desired extensions
static cstr extensions[Max_VulkanExtensions] = { VK_EXT_DEBUG_UTILS_EXTENSION_NAME };


cstr* cvk_instance_getExtensions(u32* count) {
  // Get system Extensions with GLFW
  cstr* required = glfwGetRequiredInstanceExtensions(count);
  if (!required) fail(Instance, "Couldn't find any Vulkan Extensions. Vk is not usable (probably not installed)");
  // Get our desired extensions, by merging our list with the required ones
  cstr* result = arr_cstr_merge(required, (size_t)*count, extensions, arr_len(extensions));
  // Apply results and return
  *count += arr_len(extensions);
  return result;
}


VkInstance cvk_instance_create(cvk_instance_create_args in) {
  // Check if validation layers are supported (does nothing on release mode).
  cvk_validate_chkSupport();
  // Get required extensions
  u32   extCount = 0;
  cstr* extNames = cvk_instance_getExtensions(&extCount);
  // Create the instance
  VkInstance result;  // clang-format off
  VkResult code = vkCreateInstance(&(VkInstanceCreateInfo){
    .sType                   = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    .pNext                   = in.debugCfg,  // Add the Debug Messenger Extension config to the chain
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
     in.allocator, &result);
  // clang-format on
  if (code != VK_SUCCESS) fail(Instance, "Failed to create Vulkan Instance");
  return result;
}
