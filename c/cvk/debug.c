//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "../cvk.h"
#include <stdlib.h>
#include <time.h>


// Allow soft-type casting Vulkan function pointers for these functions
//   cvk_debug_getFn_create
//   cvk_debug_getFn_destroy
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcast-function-type-strict"

static struct vk_debug {
  PFN_vkCreateDebugUtilsMessengerEXT create;
  PFN_vkDestroyDebugUtilsMessengerEXT destroy;
} vk_debug = {0};

static void cvk_debug_getFn_create (VkInstance const instance) {
  /// @internal
  /// @descr Stores the Vulkan Debug Messenger create function into the {@link vk_debug} vtable
  if (vk_debug.create) return;
  if (!vk_debug.create) vk_debug.create = (PFN_vkCreateDebugUtilsMessengerEXT)vkGetInstanceProcAddr(instance, "vkCreateDebugUtilsMessengerEXT");
  if (!vk_debug.create) fail(cvk_Error_debug, "Failed to get the Vulkan Debug Messenger create function");
}

static void cvk_debug_getFn_destroy (VkInstance const instance) {
  /// @internal
  /// @descr Stores the Vulkan Debug Messenger destroy function into the {@link vk_debug} vtable
  if (vk_debug.destroy) return;
  if (!vk_debug.destroy) vk_debug.destroy = (PFN_vkDestroyDebugUtilsMessengerEXT)vkGetInstanceProcAddr(instance, "vkDestroyDebugUtilsMessengerEXT");
  if (!vk_debug.destroy) fail(cvk_Error_debug, "Failed to get the Vulkan Debug Messenger destroy function");
}
// Stop->  diagnostic ignored "-Wcast-function-type-strict"
#pragma clang diagnostic pop


/// @internal
/// @descr Configures the required data for Vulkan to send back debug information with the Messenger Extension.
cvk_debug_Cfg cvk_debug_setup (
    cvk_debug_Flags    const flags,
    cvk_debug_Severity const severity,
    cvk_debug_MsgType  const msgType,
    cvk_debug_Callback const callback,
    cvk_Userdata       const userdata
  ) {
  return (VkDebugUtilsMessengerCreateInfoEXT){
    .sType           = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
    .pNext           = NULL,
    .flags           = flags,
    .messageSeverity = severity,
    .messageType     = msgType,
    .pfnUserCallback = callback,
    .pUserData       = userdata,
    };
}

/// @descr Creates a Vulkan Debug Messenger using the given {@arg cfg} configuration
cvk_Debug cvk_debug_create (
    VkInstance    const I,
    cvk_debug_Cfg const cfg,
    bool          const active,
    cvk_Allocator const A
  ) {
  if (!active) return (cvk_Debug){0};
  cvk_debug_getFn_create(I);
  cvk_Debug result = (cvk_Debug){
    .A      = A,
    .ct     = NULL,
    .cfg    = cfg,
    .active = active,
  };
  result.ct = (VkDebugUtilsMessengerEXT*)calloc(1, sizeof(VkDebugUtilsMessengerEXT));
  VkResult const code = vk_debug.create(I, &result.cfg, result.A, result.ct);
  if (code != VK_SUCCESS) fail(code, "Failed to create the Vulkan Debug Messenger");
  return result;
}

/// @descr Destroys a Vulkan Debug Messenger object created with {@link cvk_debug_create}
void cvk_debug_destroy (
    cvk_Debug*   const dbg,
    cvk_Instance const I
  ) {
  if (!dbg->active) return;
  cvk_debug_getFn_destroy(I.ct);
  vk_debug.destroy(I.ct, *dbg->ct, dbg->A);
  free(dbg->ct);
}


VkBool32 cvk_debug_cb (
    VkDebugUtilsMessageSeverityFlagBitsEXT const        severity,
    VkDebugUtilsMessageTypeFlagsEXT        const        types,
    VkDebugUtilsMessengerCallbackDataEXT   const* const cbdata,
    void*                                  const        userdata
  ) {
  (void)userdata; /*discard*/
  printf("[Vulkan Validation] (%d %d) : %s\n", types, severity, cbdata->pMessage);
  return false;
}

