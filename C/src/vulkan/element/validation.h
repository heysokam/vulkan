//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
#include "./base.h"

#if debug
extern cstr validationLayers[Max_VulkanLayers];
#else
extern cstr const* validationLayers;
#endif

/// Checks that all validation layers are supported.
void cvk_validate_chkSupport(void);
/// Configures the required information for Vulkan to send back debug information with the Messenger Extension.
VkDebugMessengerCfg cvk_validate_setupDebugCfg(  // clang-format off
    VkDebugUtilsMessengerCreateFlagsEXT  flags,
    VkDebugUtilsMessageSeverityFlagsEXT  severity,
    VkDebugUtilsMessageTypeFlagsEXT      msgType,
    void*                                userdata );  // clang-format on
/// Creates the messenger object that Vulkan uses to send back debug information.
VkDebugMessenger* cvk_validate_createDebug(VkInstance instance, VkDebugMessengerCfg* cfg, const VkAllocationCallbacks* allocator);
/// Destroys the messenger object that Vulkan uses to send back debug information.
void cvk_validate_destroyDebug(VkInstance instance, VkDebugMessenger* dbg, VkAllocator* allocator);
