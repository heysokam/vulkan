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
// @section Aliased Types
//____________________________
typedef VkExtent2D cvk_Size;
typedef VkExtent3D cvk_Volume;


//______________________________________
// @section Forward Declares for cvk.Types
//____________________________
typedef struct cvk_Instance cvk_Instance;
typedef struct cvk_QueueFamilies cvk_QueueFamilies;
typedef struct cvk_device_SwapchainSupport cvk_device_SwapchainSupport;


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
  cvk_Error_device,
  cvk_Error_swapchain,
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
  cvk_Debug*    const dbg,
  cvk_Instance* const I
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
// @section Device: SwapchainSupport
//____________________________
struct cvk_device_SwapchainSupport {
  VkSurfaceCapabilitiesKHR  caps;
  u32                       formatCount;
  VkSurfaceFormatKHR*       formats;
  u32                       priv_pad1;
  u32                       modeCount;
  VkPresentModeKHR*         modes;
}; typedef struct cvk_device_SwapchainSupport cvk_device_SwapchainSupport;
/// @descr Returns the Swapchain support information for the given Device+Surface
/// @note Allocates memory for its formats and modes lists
cvk_device_SwapchainSupport cvk_device_swapchainSupport_create (
  VkPhysicalDevice const device,
  VkSurfaceKHR     const surface);
/// @descr
///  Releases all information contained in the given object.
///  Frees the allocated data, and sets every other value to empty.
void cvk_device_swapchainSupport_destroy (cvk_device_SwapchainSupport* const support);
/// @descr Returns true if the device has support for Swapchain creation
bool cvk_device_swapchainSupport_available (cvk_device_SwapchainSupport* const support);


//______________________________________
// @section Device: Extensions
//____________________________

/// @descr Gets a list with the names of all extensions supported by the device
cstr_List cvk_device_extensions_getList (
  VkPhysicalDevice const device,
  u32*             const count);
/// @descr Returns true if the {@arg device} supports all extensions contained in the {@arg exts} list
bool cvk_device_extensions_areSupported (
  VkPhysicalDevice const device,
  u32              const count,
  cstr_List        const exts);


//______________________________________
// @section Device: Physical
//____________________________
struct cvk_device_Physical {
  VkPhysicalDevice   ct;
  VkPhysicalDevice*  all;
}; typedef struct cvk_device_Physical cvk_device_Physical;
/// Returns true if the given device is considered suitable to run with the default mvk configuration
bool cvk_device_physical_isSuitable (
  VkPhysicalDevice             const device,
  cvk_QueueFamilies*           const fams,
  cvk_device_SwapchainSupport* const support);
/// @descr Returns a Physical Device suitable to run with the default mvk configuration
cvk_device_Physical cvk_device_physical_create (
  cvk_Instance const instance,
  cvk_Surface  const surface,
  bool         const forceFirst);
/// @descr Frees the resources stored in the given object.
void cvk_device_physical_destroy (cvk_device_Physical* D);


//______________________________________
// @section Device: Logical
//____________________________
struct cvk_device_Logical {
  cvk_Allocator       A;
  VkDevice            ct;
  VkDeviceCreateInfo  cfg;
}; typedef struct cvk_device_Logical cvk_device_Logical;
/// @descr Returns a Logical Device suitable to run with the default mvk configuration
cvk_device_Logical cvk_device_logical_create (
  cvk_device_Physical const device,
  cvk_Surface         const surface,
  cvk_Allocator       const allocator);
void cvk_device_logical_destroy (cvk_device_Logical* device);


//______________________________________
// @section Queue
//____________________________
struct cvk_QueueFamilies {
  u32                       propCount;
  u32                       priv_pad;
  VkQueueFamilyProperties*  props;
  Ou32                      graphics;
  Ou32                      present;
}; typedef struct cvk_QueueFamilies cvk_QueueFamilies;
/// @descr Returns the Queue Families of the given device.
cvk_QueueFamilies cvk_queue_families_create (
  VkPhysicalDevice const device,
  cvk_Surface      const surface
  );
/// @descr Frees the Family Properties list, and sets every other value to empty
void cvk_queue_families_destroy (cvk_QueueFamilies* const fams);
//__________________
struct cvk_QueueEntry {
  Ou32     id;
  VkQueue  ct;
}; typedef struct cvk_QueueEntry cvk_QueueEntry;
//__________________
struct cvk_Queue {
  cvk_QueueEntry  graphics;
  cvk_QueueEntry  present;
}; typedef struct cvk_Queue cvk_Queue;
/// @descr Returns the Queue data of the given Device
cvk_Queue cvk_queue_create (
  cvk_device_Physical const physicalDev,
  cvk_device_Logical  const logicalDev,
  cvk_Surface         const surface);


//______________________________________
// @section Device
//____________________________
struct cvk_Device {
  cvk_device_Physical  physical;
  cvk_device_Logical   logical;
  cvk_Queue            queue;
}; typedef struct cvk_Device cvk_Device;
/// @descr Returns a complete Device object based on the given configuration options
cvk_Device cvk_device_create (
  cvk_Instance const instance,
  cvk_Surface  const surface,
  bool         const forceFirst);
void cvk_device_destroy (cvk_Device* device);


//______________________________________
// @section Swapchain: Select
//____________________________
/// @descr Returns the preferred format for the Swapchain Surface
VkSurfaceFormatKHR cvk_swapchain_formatSelect (cvk_device_SwapchainSupport* const support);
/// @descr Returns the preferred present mode for the Swapchain Surface
/// @note Searches for Mailbox support first, and returns FIFO if not found
VkPresentModeKHR cvk_swapchain_select_mode (cvk_device_SwapchainSupport* const support);
/// @descr Returns the size of the Swapchain Surface
/// @note Measurements in pixels/units are compared, in case they don't match
cvk_Size cvk_swapchain_select_size (cvk_device_SwapchainSupport* const support, cvk_Size* const size);
/// @descr Returns the minimum number of images that the Swapchain will contain
u32 cvk_swapchain_select_imgMin (cvk_device_SwapchainSupport* const support);

//______________________________________
// @section Swapchain
//____________________________
struct cvk_Swapchain {
  cvk_Allocator             A;
  VkSwapchainKHR            ct;
  VkSwapchainCreateInfoKHR  cfg;
  VkSurfaceFormatKHR        format;
  VkPresentModeKHR          mode;
  VkExtent2D                size;
  u32                       priv_pad;
  u32                       imgMin;
  u32                       imgCount;
  VkImage*                  images;
  VkImageView*              views;
}; typedef struct cvk_Swapchain cvk_Swapchain;
/// @descr Creates a Swapchain object for the given device and surface
cvk_Swapchain cvk_swapchain_create (
  cvk_Device*   const device,
  cvk_Surface   const surface,
  cvk_Size*     const size,
  cvk_Allocator const allocator);
/// @descr Releases the Swapchain object and all its ImageViews
void cvk_swapchain_destroy (cvk_Swapchain* const swapchain, cvk_device_Logical* const device);

