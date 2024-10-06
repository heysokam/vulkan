//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./validation.h"

#if debug
cstr validationLayers[Max_VulkanLayers] = {
  "VK_LAYER_KHRONOS_validation",
};
#else
cstr const* validationLayers = NULL;
#endif


void cvk_validate_chkSupport(void) {
  if (!cdk_debug) return;
  // Get the layer names
  u32 count;
  vkEnumerateInstanceLayerProperties(&count, NULL);
  VkLayerProperties* layers = (VkLayerProperties*)alloc(sizeof(VkLayerProperties), count);
  vkEnumerateInstanceLayerProperties(&count, layers);
  // Check if your defined names exist in the list available layers returned by glfw
  bool found = false;
  for (u32 layerId = 0; layerId < count; layerId++) {
    str name = layers[layerId].layerName;
    for (u32 vlayerId = 0; vlayerId < Max_VulkanLayers; vlayerId++) {  // clang-format off
      if (str_equal(name, validationLayers[vlayerId])){ found = true; goto end; }
    }
  }  // clang-format on
end:
  free(layers);
  if (!found) fail(Validation, "One or more of the validation layers requested is not available in this system.");
}


static VkBool32 cvk_cb_debug(  // clang-format off
    VkDebugUtilsMessageSeverityFlagBitsEXT      severity,
    VkDebugUtilsMessageTypeFlagsEXT             types,
    const VkDebugUtilsMessengerCallbackDataEXT* cbdata,
    void*                                       userdata
  ) {  // clang-format on
  discard(userdata);
  printf("[Vulkan Validation] (%d %d) :  %s\n", types, severity, cbdata->pMessage);
  return false;
}


VkDebugUtilsMessengerCreateInfoEXT cvk_validate_setupDebugCfg(  // clang-format off
    VkDebugUtilsMessengerCreateFlagsEXT  flags,
    VkDebugUtilsMessageSeverityFlagsEXT  severity,
    VkDebugUtilsMessageTypeFlagsEXT      msgType,
    void*                                userdata
  ) {
  return (VkDebugUtilsMessengerCreateInfoEXT){
    .sType           = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
    .pNext           = NULL,
    .flags           = flags, // VkDebugUtilsMessengerCreateFlagsEXT
    .messageSeverity = severity,
    .messageType     = msgType,
    .pfnUserCallback = cvk_cb_debug,
    .pUserData       = userdata,
    };  // clang-format on
}


VkDebugMessenger* cvk_validate_createDebug(  // clang-format off
    VkInstance                          instance,
    VkDebugUtilsMessengerCreateInfoEXT* cfg,
    const VkAllocationCallbacks*        allocator
  ) {  // clang-format on
  // Exit early if we are not on debug mode
  if (!cdk_debug) return NULL;
  // Find the function to create the Messenger (its an extension, so must be requested)
  PFN_vkCreateDebugUtilsMessengerEXT createMessenger = (PFN_vkCreateDebugUtilsMessengerEXT)vkGetInstanceProcAddr(instance, "vkCreateDebugUtilsMessengerEXT");
  // Setup the result
  VkDebugMessenger* result = (VkDebugMessenger*)alloc(1, sizeof(VkDebugMessenger));
  VkResult          code   = createMessenger(instance, cfg, allocator, result);
  // Check for errors and return
  if (code != VK_SUCCESS) fail(Validation, "Failed to create Debug Messenger");
  return result;
}

void cvk_validate_destroyDebug(VkInstance instance, VkDebugMessenger* dbg, VkAllocator* allocator){
  // Find the function to destroy the Messenger (its an extension, so must be requested)
  PFN_vkDestroyDebugUtilsMessengerEXT destroyMessenger = (PFN_vkDestroyDebugUtilsMessengerEXT)vkGetInstanceProcAddr(instance, "vkDestroyDebugUtilsMessengerEXT");
  // Destroy it and free the memory we allocated in `cvk_validate_createDebug`
  destroyMessenger(instance, *dbg, allocator);
  free(dbg);
}
