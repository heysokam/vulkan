//:___________________________________________________________________
//  cvk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
#include "../cvk.hpp"
#include <cstdint>

namespace cvk {
  namespace device {
    namespace queue {
    } //:: cvk.device.queue
  } //:: cvk.device
}

cvk::device::SwapchainSupport::SwapchainSupport(
    VkPhysicalDevice const D,
    cvk::Surface     const S
  ) {
  // Get the Capabilities
  VkResult code;
  code = vkGetPhysicalDeviceSurfaceCapabilitiesKHR(D, S, &m->caps);
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve the Swapchain Surface capabilities for the selected device."); }
  // Get the Formats
  u32 formatCount = 0;
  code = vkGetPhysicalDeviceSurfaceFormatsKHR(D, S, &formatCount, NULL);
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve the number of Swapchain Formats for the selected device."); }
  if (formatCount > 0) {
    m->formats = seq<VkSurfaceFormatKHR>(formatCount);
    code = vkGetPhysicalDeviceSurfaceFormatsKHR(D, S, &formatCount, m->formats.data());
    if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve the list of Swapchain Formats for the selected device."); }
  }
  // Get the Present Modes
  u32 modeCount = 0;
  code = vkGetPhysicalDeviceSurfacePresentModesKHR(D, S, &modeCount, NULL);
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve the number of Swapchain Present Modes for the selected device."); }
  if (modeCount > 0) {
    m->modes = seq<VkPresentModeKHR>(modeCount);
    code = vkGetPhysicalDeviceSurfacePresentModesKHR(D, S, &modeCount, m->modes.data());
    if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve the list of Swapchain Present Modes for the selected device."); }
  }
} //:: cvk.device.SwapchainSupport.Constructor

cvk::device::queue::Families::Families(
    VkPhysicalDevice const D,
    cvk::Surface     const S
  ) {
  u32 count = 0;
  vkGetPhysicalDeviceQueueFamilyProperties(D, &count, NULL);
  m->props = seq<VkQueueFamilyProperties>(count);
  vkGetPhysicalDeviceQueueFamilyProperties(D, &count, m->props.data());
  for(size_t propID = 0; propID < m->props.size(); ++propID) {
    VkQueueFamilyProperties const prop = m->props[propID];
    if (prop.queueFlags & VK_QUEUE_GRAPHICS_BIT) { m->graphics = propID; }
    VkBool32 canPresent = 0;
    vkGetPhysicalDeviceSurfaceSupportKHR(D, (u32)propID, S, &canPresent);
    if (canPresent) { m->present = propID; }
    if (m->graphics.has_value() && m->present.has_value()) { break; }
  }
} //:: cvk.device.queue.Families.Constructor

seq<cstr> cvk::device::extensions::getList (
    VkPhysicalDevice const D
  ) {
  u32 propCount;
  vkEnumerateDeviceExtensionProperties(D, NULL, &propCount, NULL);
  seq<VkExtensionProperties> props = seq<VkExtensionProperties>(propCount);
  vkEnumerateDeviceExtensionProperties(D, NULL, &propCount, props.data());
  seq<cstr> result = seq<cstr>();
  for (auto const prop : props) result.push_back(prop.extensionName);
  return result;
} //:: cvk_device_extensions_getList


bool cvk::device::extensions::supported (
    VkPhysicalDevice const device,
    seq<cstr>        const exts
  ) {
  seq<cstr> extNames = cvk::device::extensions::getList(device);
  for (auto const ext : exts) if (!cstr_seq_contains(extNames, ext)) return false;
  return true;
} //:: cvk_device_extensions_areSupported


namespace cvk { namespace device { namespace extensions {
  const seq<cstr> List = {VK_KHR_SWAPCHAIN_EXTENSION_NAME};
}}} //:: cvk.device.extensions

bool cvk::device::physical::isSuitable (
    VkPhysicalDevice              const D,
    cvk::device::queue::Families  const fams,
    cvk::device::SwapchainSupport const support
  ) {
  VkPhysicalDeviceProperties props = {0};
  vkGetPhysicalDeviceProperties(D, &props);
  return props.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU
      && fams.graphics.has_value()
      && fams.present.has_value()
      && cvk::device::extensions::supported(D, cvk::device::extensions::List)
      && support.available();
} //:: cvk_device_physical_isSuitable

cvk::device::Physical::Physical (
    cvk::Instance* const I,
    cvk::Surface   const S,
    bool           const forceFirst,
    cvk::Allocator const A
  ) {
  // Find the list of all Physical Devices
  u32 count;
  VkResult code = vkEnumeratePhysicalDevices(I->handle(), &count, NULL);
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed when searching for GPUs with Vulkan support."); }
  if (!count) { cvk::fail(cvk::Error::device, "Failed to find any GPUs with Vulkan support."); }
  m->all = seq<VkPhysicalDevice>(count);
  code = vkEnumeratePhysicalDevices(I->handle(), &count, m->all.data());
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve the list of GPUs."); }
  // Find the Physical Device that we want
  for (auto const device : m->all) {
    if (forceFirst) { m->ct = device; break; }
    if (cvk::device::physical::isSuitable(device, cvk::device::queue::Families(device, S), cvk::device::SwapchainSupport(device, S))) {
      m->ct = device; break;
    }
  }
  if (m->ct == NULL) { cvk::fail(cvk::Error::device, "Failed to find any suitable GPU."); }
} //:: cvk.device.Physical.Constructor

void cvk::device::Physical::destroy (void) {
  m->all.clear();
} //:: cvk.device.Physical.destroy

/// @descr Returns a Queue configuration object
namespace cvk { namespace device { namespace queue {
  static VkDeviceQueueCreateInfo setup (
      u32 const famID,
      f32 const priority
    ) {
    assert(f32_zeroToOne(priority) && "Queue priority must be in the f32[0..1] range");
    f32 const prio[1] = { priority };
    return (VkDeviceQueueCreateInfo){
      .sType            = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
      .pNext            = NULL,
      .flags            = (VkDeviceQueueCreateFlags)0,
      .queueFamilyIndex = famID,
      .queueCount       = 1,
      .pQueuePriorities = prio,
      };
  } //:: cvk.device.queue.setup
}}} //:: cvk.device.queue

cvk::device::Logical::Logical (
    cvk::device::Physical const D,
    cvk::Surface          const S,
    cvk::Allocator        const A
  ) {
  cvk::device::queue::Families fam = cvk::device::queue::Families(D.handle(), S);
  seq<VkDeviceQueueCreateInfo> queueCfg = seq<VkDeviceQueueCreateInfo>();
  queueCfg.push_back(cvk::device::queue::setup(fam.graphics.value(), 1.0));
  if (fam.graphics.value() != fam.present.value()) queueCfg.push_back(cvk::device::queue::setup(fam.present.value(), 1.0));
  VkPhysicalDeviceFeatures const features = {0};

  m->A                       = A;
  m->ct                      = NULL;
  m->cfg                     = (VkDeviceCreateInfo){
    .sType                   = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
    .pNext                   = NULL,
    .flags                   = (VkDeviceCreateFlags)0,
    .queueCreateInfoCount    = static_cast<uint32_t>(queueCfg.size()),
    .pQueueCreateInfos       = queueCfg.data(),
    .enabledLayerCount       = 0,
    .ppEnabledLayerNames     = NULL,
    .enabledExtensionCount   = static_cast<uint32_t>(cvk::device::extensions::List.size()),
    .ppEnabledExtensionNames = cvk::device::extensions::List.data(),
    .pEnabledFeatures        = &features,
    }; //:: result.cfg
  VkResult const code = vkCreateDevice(D.handle(), &m->cfg, m->A, &m->ct);
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to create the Vulkan Logical device"); }
} //:: cvk.device.Logical.Constructor

void cvk::device::Logical::destroy (void) {
  vkDestroyDevice(m->ct, m->A);
} //:: cvk.device.Logical.destroy

cvk::device::queue::entry::Entry::Entry (
    cvk::device::Logical  const D,
    u32                   const id
  ) {
  m->id = id;
  vkGetDeviceQueue(D.handle(), m->id, 0, &m->ct);
}

cvk::device::Queue::Queue (
    cvk::device::Physical const P,
    cvk::device::Logical  const L,
    cvk::Surface          const S,
    cvk::Allocator        const A
  ) {
  cvk::device::queue::Families fam = cvk::device::queue::Families(P.handle(), S);
  m->graphics = cvk::device::queue::entry::Entry(L, fam.graphics.value());
  m->present  = cvk::device::queue::entry::Entry(L, fam.present.value());
} //:: cvk.device.Queue.Constructor

cvk::Device::Device(
    cvk::Instance* const I,
    cvk::Surface   const S,
    bool           const forceFirst,
    cvk::Allocator const A
  ) {
  m->physical = cvk::device::Physical(I, S, forceFirst, A);
  m->logical  = cvk::device::Logical(m->physical, S, A);
  m->queue    = cvk::device::Queue(m->physical, m->logical, S, A);
}; //:: cvk.Device.Constructor

void cvk::Device::destroy (void) {
  m->logical.destroy();
  m->physical.destroy();
} //:: cvk.Device.destroy

