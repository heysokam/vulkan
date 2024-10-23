//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview
//!  Raw api for managing the cvk_Device object.
//!  Device support and searching, and Queue management, are not exposed.
//!  They are managed from this file.
//________________________________________________________________________|
#include "../cvk.h"



//______________________________________
// @section Device: Queue Families
//____________________________

/// @descr Returns the Queue Families of the given device.
static cvk_QueueFamilies cvk_queue_families_create (
    VkPhysicalDevice const device,
    cvk_Surface      const surface
  ) {
  cvk_QueueFamilies result =(cvk_QueueFamilies){
    .propCount = 0,
    .props     = NULL,
    .graphics  = Ou32_none(),
    .present   = Ou32_none(),
    };
  vkGetPhysicalDeviceQueueFamilyProperties(device, &result.propCount, NULL);
  result.props = (VkQueueFamilyProperties*)calloc(result.propCount, sizeof(VkQueueFamilyProperties));
  vkGetPhysicalDeviceQueueFamilyProperties(device, &result.propCount, result.props);
  for(size_t propID = 0; propID < result.propCount; ++propID) {
    VkQueueFamilyProperties const prop = result.props[propID];
    if (prop.queueFlags & VK_QUEUE_GRAPHICS_BIT) { result.graphics = Ou32_some((u32)propID); }
    VkBool32 canPresent = 0;
    vkGetPhysicalDeviceSurfaceSupportKHR(device, (u32)propID, surface, &canPresent);
    if (canPresent) { result.present = Ou32_some((u32)propID); }
    if (result.graphics.hasValue && result.present.hasValue) { break; }
  }
  return result;
} //:: cvk_queue_families_create

/// @descr Frees the Family Properties list, and sets every other value to empty
static void cvk_queue_families_destroy (
    cvk_QueueFamilies* const fams
  ) {
  free(fams->props);
  fams->propCount = 0;
  fams->graphics  = Ou32_none();
  fams->present   = Ou32_none();
} //:: cvk_queue_families_destroy



//______________________________________
// @section Device: Queue
//____________________________

/// @descr Returns a Queue configuration object
static VkDeviceQueueCreateInfo cvk_queue_setupCfg (
    u32 const famID,
    f32 const priority
  ) {
  assert(f32_zeroToOne(priority) && "Queue priority must be in the f32[0..1] range");
  f32 const prio[1] = { [0]= priority, };
  return (VkDeviceQueueCreateInfo){
    .sType            = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
    .pNext            = NULL,
    .flags            = (VkDeviceQueueCreateFlags)0,
    .queueFamilyIndex = famID,
    .queueCount       = 1,
    .pQueuePriorities = prio,
    };
} //:: cvk_queue_setupCfg

static cvk_QueueEntry cvk_queue_graphicsCreate (
    cvk_device_Logical       const device,
    cvk_QueueFamilies const* const fams
  ) {
  /// @descr Returns the Graphics Queue data of the given Device
  cvk_QueueEntry result =(cvk_QueueEntry){
    .id= Ou32_none(),
    .ct= NULL,
    };
  result.id = fams->graphics;
  vkGetDeviceQueue(device.ct, result.id.value, 0, &result.ct);
  return result;
} //:: cvk_queue_graphicsCreate

static cvk_QueueEntry cvk_queue_presentCreate (
    cvk_device_Logical       const device,
    cvk_QueueFamilies const* const fams
  ) {
  /// @descr Returns the Graphics Queue data of the given Device
  cvk_QueueEntry result =(cvk_QueueEntry){.id= Ou32_none(), .ct= NULL};
  result.id = fams->present;
  vkGetDeviceQueue(device.ct, result.id.value, 0, &result.ct);
  return result;
} //:: cvk_queue_presentCreate

cvk_Queue cvk_queue_create (
    cvk_device_Physical const physicalDev,
    cvk_device_Logical  const logicalDev,
    cvk_Surface         const surface
  ) {
  cvk_QueueFamilies fam = cvk_queue_families_create(physicalDev.ct, surface);
  cvk_Queue result =(cvk_Queue){
    .graphics = cvk_queue_graphicsCreate(logicalDev, &fam),
    .present  = cvk_queue_presentCreate(logicalDev, &fam),
    };
  cvk_queue_families_destroy(&fam);
  return result;
} //:: cvk_queue_create



//______________________________________
// @section Device: SwapchainSupport
//____________________________
cvk_device_SwapchainSupport cvk_device_swapchainSupport_create (
    VkPhysicalDevice const device,
    cvk_Surface      const surface
  ) {
  cvk_device_SwapchainSupport result = {0};
  VkResult code;
  code = vkGetPhysicalDeviceSurfaceCapabilitiesKHR(device, surface, &result.caps);
  if (code != VK_SUCCESS) { fail(code, "Failed to retrieve the Swapchain Surface capabilities for the selected device."); }
  code = vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &result.formatCount, NULL);
  if (code != VK_SUCCESS) { fail(code, "Failed to retrieve the number of Swapchain Formats for the selected device."); }
  if (result.formatCount > 0) {
    result.formats = (VkSurfaceFormatKHR*)calloc(result.formatCount, sizeof(VkSurfaceFormatKHR));
    code = vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &result.formatCount, result.formats);
    if (code != VK_SUCCESS) { fail(code, "Failed to retrieve the list of Swapchain Formats for the selected device."); }
  }
  code = vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface, &result.modeCount, NULL);
  if (code != VK_SUCCESS) { fail(code, "Failed to retrieve the number of Swapchain Present Modes for the selected device."); }
  if (result.modeCount > 0) {
    result.modes = (VkPresentModeKHR*)calloc(result.modeCount, sizeof(VkPresentModeKHR));
    code = vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface, &result.modeCount, result.modes);
    if (code != VK_SUCCESS) { fail(code, "Failed to retrieve the list of Swapchain Present Modes for the selected device."); }
  }
  return result;
} //:: cvk_device_swapchainSupport_create

void cvk_device_swapchainSupport_destroy (
    cvk_device_SwapchainSupport* const support
  ) {
  support->caps = (VkSurfaceCapabilitiesKHR){0};
  support->formatCount = 0;
  free(support->formats);
  support->modeCount = 0;
  free(support->modes);
} //:: cvk_device_swapchainSupport_destroy

bool cvk_device_swapchainSupport_available (cvk_device_SwapchainSupport* const support) {
  return support->formatCount > 0 && support->modeCount > 0;
} //:: cvk_device_swapchainSupport_available



//______________________________________
// @section Device: Extensions
//____________________________

#define cvk_device_extensions_Max 1
const/*comptime*/ static cstr cvk_device_extensions_List[cvk_device_extensions_Max] = {
  [0]= VK_KHR_SWAPCHAIN_EXTENSION_NAME,
};

cstr_List cvk_device_extensions_getList (
    VkPhysicalDevice const device,
    u32*             const count
  ) {
  u32 propCount;
  vkEnumerateDeviceExtensionProperties(device, NULL, &propCount, NULL);
  VkExtensionProperties* props = (VkExtensionProperties*)calloc(propCount, sizeof(VkExtensionProperties));
  vkEnumerateDeviceExtensionProperties(device, NULL, &propCount, props);
  cstr* result = (cstr*)calloc(propCount, sizeof(cstr));
  for(size_t propID = 0; propID < propCount; ++propID) {
    VkExtensionProperties const prop = props[propID];
    result[propID] = cstr_dup(prop.extensionName);
  }
  *count = propCount;
  free(props);
  return result;
} //:: cvk_device_extensions_getList

bool cvk_device_extensions_areSupported (
    VkPhysicalDevice const device,
    u32              const count,
    cstr_List        const exts
  ) {
  u32 extCount;
  cstr* extNames = cvk_device_extensions_getList(device, &extCount);
  for(size_t id = 0; id < count; ++id) {
    cstr const req = exts[id];
    if (!cstr_List_contains(extNames, extCount, req)) { free(extNames); return false; }
  }
  free(extNames);
  return true;
} //:: cvk_device_extensions_areSupported



//______________________________________
// @section Device: Physical
//____________________________

bool cvk_device_physical_isSuitable (
    VkPhysicalDevice             const device,
    cvk_QueueFamilies*           const fams,
    cvk_device_SwapchainSupport* const support
  ) {
  VkPhysicalDeviceProperties props = {0};
  vkGetPhysicalDeviceProperties(device, &props);
  return props.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU
      && fams->graphics.hasValue
      && fams->present.hasValue
      && cvk_device_extensions_areSupported(device, cvk_device_extensions_Max, (cstr_List)cvk_device_extensions_List)
      && cvk_device_swapchainSupport_available(support);
} //:: cvk_device_physical_isSuitable

cvk_device_Physical cvk_device_physical_create (
    cvk_Instance const instance,
    cvk_Surface  const surface,
    bool         const forceFirst
  ) {
  cvk_device_Physical result = {0};
  // Find the list of all Physical Devices
  u32 count;
  VkResult code = vkEnumeratePhysicalDevices(instance.ct, &count, NULL);
  if (code != VK_SUCCESS) { fail(code, "Failed when searching for GPUs with Vulkan support."); }
  if (!count) { fail(cvk_Error_device, "Failed to find any GPUs with Vulkan support."); }
  result.all = (VkPhysicalDevice*)calloc(count, sizeof(VkPhysicalDevice));
  code = vkEnumeratePhysicalDevices(instance.ct, &count, result.all);
  if (code != VK_SUCCESS) { fail(code, "Failed to retrieve the list of GPUs."); }
  // Find the Physical Device that we want
  for(size_t id = 0; id < count; ++id) {
    if (forceFirst) { result.ct = result.all[0]; break; }
    cvk_QueueFamilies fam = cvk_queue_families_create(result.all[id], surface);
    cvk_device_SwapchainSupport support = cvk_device_swapchainSupport_create(result.all[id], surface);
    if (cvk_device_physical_isSuitable(result.all[id], &fam, &support)) {
      result.ct = result.all[id];
      cvk_device_swapchainSupport_destroy(&support);
      cvk_queue_families_destroy(&fam);
      break;
    }
    cvk_device_swapchainSupport_destroy(&support);
    cvk_queue_families_destroy(&fam);
  }
  if (result.ct == NULL) { fail(cvk_Error_device, "Failed to find any suitable GPU."); }
  return result;
} //:: cvk_device_physical_create

void cvk_device_physical_destroy (
    cvk_device_Physical* D
  ) {
  free(D->all);
} //:: cvk_device_physical_destroy



//______________________________________
// @section Device: Logical
//____________________________

cvk_device_Logical cvk_device_logical_create (
    cvk_device_Physical const device,
    cvk_Surface         const surface,
    cvk_Allocator       const allocator
  ) {
  cvk_QueueFamilies fam = cvk_queue_families_create(device.ct, surface);
  u32 queueCfgCount;
  VkDeviceQueueCreateInfo* queueCfg;
  if (fam.graphics.value == fam.present.value) {
    queueCfgCount = 1;
    queueCfg = (VkDeviceQueueCreateInfo*)calloc(queueCfgCount, sizeof(VkDeviceQueueCreateInfo));
    queueCfg[0] = cvk_queue_setupCfg(fam.graphics.value, 1.0);
  } else {
    queueCfgCount = 2;
    queueCfg = (VkDeviceQueueCreateInfo*)calloc(queueCfgCount, sizeof(VkDeviceQueueCreateInfo));
    queueCfg[0] = cvk_queue_setupCfg(fam.graphics.value, 1.0);
    queueCfg[1] = cvk_queue_setupCfg(fam.present.value, 1.0);
  }
  VkPhysicalDeviceFeatures const features = {0};
  cvk_device_Logical result = {
    .A                         = allocator,
    .ct                        = NULL,
    .cfg                       = (VkDeviceCreateInfo){
      .sType                   = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
      .pNext                   = NULL,
      .flags                   = (VkDeviceCreateFlags)0,
      .queueCreateInfoCount    = queueCfgCount,
      .pQueueCreateInfos       = queueCfg,
      .enabledLayerCount       = 0,
      .ppEnabledLayerNames     = NULL,
      .enabledExtensionCount   = cvk_device_extensions_Max,
      .ppEnabledExtensionNames = cvk_device_extensions_List,
      .pEnabledFeatures        = &features,
      } //:: result.cfg
    }; //:: result
  VkResult const code = vkCreateDevice(device.ct, &result.cfg, result.A, &result.ct);
  if (code != VK_SUCCESS) { fail(code, "Failed to create the Vulkan Logical device"); }
  free(queueCfg);
  cvk_queue_families_destroy(&fam);
  return result;
} //:: cvk_device_logical_create

void cvk_device_logical_destroy (
    cvk_device_Logical* device
  ) {
  vkDestroyDevice(device->ct, device->A);
} //:: cvk_device_logical_destroy



//______________________________________
// @section Device
//____________________________

cvk_Device cvk_device_create (
    cvk_Instance const instance,
    cvk_Surface  const surface,
    bool         const forceFirst
  ) {
  cvk_Device result;
  result.physical = cvk_device_physical_create(instance, surface, forceFirst);
  result.logical  = cvk_device_logical_create(result.physical, surface, instance.A);
  result.queue    = cvk_queue_create(result.physical, result.logical, surface);
  return result;
} //:: cvk_device_create

void cvk_device_destroy (
    cvk_Device* device
  ) {
  cvk_device_physical_destroy(&device->physical);
  cvk_device_logical_destroy(&device->logical);
} //:: cvk_device_destroy

