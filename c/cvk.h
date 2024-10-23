//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
// @deps External
#include <vulkan/vulkan.h>
#include <vulkan/vulkan_core.h>
// @deps cdk
#include "./cstd.h"
#include "./cstr.h"


//______________________________________
// @section Forward Declares for cvk.Types
//____________________________
typedef struct cvk_Instance cvk_Instance;


//______________________________________
// @section Errors
//____________________________
typedef enum cvk_Error {
  cvk_Error_none = 0,
  cvk_Error_extensions,
  cvk_Error_surface,
  cvk_Error_debug,
  cvk_Error_validation,
  cvk_Error_instance,
  cvk_Error_max,
} cvk_Error;


//______________________________________
// @section Allocator
//____________________________
typedef VkAllocationCallbacks* cvk_Allocator;
typedef void* cvk_Userdata;


//______________________________________
// @section Debug
//____________________________
typedef VkDebugUtilsMessengerCreateFlagsEXT  cvk_debug_Flags;
typedef VkDebugUtilsMessageSeverityFlagsEXT  cvk_debug_Severity;
typedef VkDebugUtilsMessageTypeFlagsEXT      cvk_debug_MsgType;
typedef VkDebugUtilsMessengerCreateInfoEXT   cvk_debug_Cfg;
typedef VkDebugUtilsMessengerEXT*            cvk_debug_T;
typedef PFN_vkDebugUtilsMessengerCallbackEXT cvk_debug_Callback;
struct cvk_Debug {
  cvk_Allocator A;
  cvk_debug_T   ct;
  cvk_debug_Cfg cfg;
  bool          active;
}; typedef struct cvk_Debug cvk_Debug;
cvk_debug_Cfg cvk_debug_setup (
  cvk_debug_Flags    const flags,
  cvk_debug_Severity const severity,
  cvk_debug_MsgType  const msgType,
  cvk_debug_Callback const callback,
  cvk_Userdata       const userdata
  );
cvk_Debug cvk_debug_create (
  VkInstance    const I,
  cvk_debug_Cfg const cfg,
  bool          const active,
  cvk_Allocator const A
  );
void cvk_debug_destroy (
  cvk_Debug*   const dbg,
  cvk_Instance const I
  );
/// @descr Callback used by the cvk validation layers
VkBool32 cvk_debug_cb (
  VkDebugUtilsMessageSeverityFlagBitsEXT const        severity,
  VkDebugUtilsMessageTypeFlagsEXT        const        types,
  VkDebugUtilsMessengerCallbackDataEXT   const* const cbdata,
  void*                                  const        userdata
  );


//______________________________________
// @section Validation
//____________________________

/// @internal
/// @descr Checks that all validation layers in the given {@arg list} are supported by the system
void cvk_validation_checkSupport (
  bool const validate,
  u32  const listCount,
  cstr const list[listCount]
  );


//______________________________________
// @section Instance
//____________________________
struct cvk_Instance {
  cvk_Allocator        A;
  VkInstance           ct;
  VkInstanceCreateInfo cfg;
  cvk_Debug            dbg;
}; typedef struct cvk_Instance cvk_Instance;

/// @descr Creates a Vulkan Instance, and all of its required properties, using the given flags+extensions+layers+validation options
cvk_Instance cvk_instance_create(
  cstr                  const appName,
  cdk_Version           const appVers,
  cstr                  const engineName,
  cdk_Version           const engineVers,
  cdk_Version           const apiVers,
  VkInstanceCreateFlags const flags,
  u32                   const extCount,
  cstr                  const exts[],
  bool                  const validate,
  u32                   const layerCount,
  cstr                  const layers[],
  cvk_debug_Cfg         const dbg,
  cvk_Allocator         const A
);
void cvk_instance_destroy (cvk_Instance* const I);


//______________________________________
// @section Surface
//____________________________
typedef VkSurfaceKHR cvk_Surface;
#define cvk_surface_destroy vkDestroySurfaceKHR

//______________________________________
// @section Device
//____________________________

