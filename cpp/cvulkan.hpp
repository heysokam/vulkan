//:____________________________________________________________________
//  Cendk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:____________________________________________________________________
#pragma once
// External dependencies
#include <vulkan/vulkan.hpp>
// cendk dependencies
#include "./alias.hpp"


//_________________________________________________
// Cvk : Custom Aliases
//______________________________________

namespace cvk {
using Result         = VkResult;
using Instance       = VkInstance;
using AllocatorT     = VkAllocationCallbacks;
using Allocator      = AllocatorT*;
using DebugMessenger = VkDebugUtilsMessengerEXT;
using Surface        = VkSurfaceKHR;
using DeviceGPU      = VkPhysicalDevice;
using Device         = VkDevice;
using SwapchainCT    = VkSwapchainKHR;
using Format         = VkFormat;
using Image          = VkImage;
using View           = VkImageView;
// using DeviceL        = VkLogicalDevice;
namespace version {
template <typename T> constexpr uint32_t make_api (T const v, T const M, T const m, T const p) {
  return ( ( ( (uint32_t)( v ) ) << 29U ) | ( ( (uint32_t)( M ) ) << 22U ) | ( ( (uint32_t)( m ) ) << 12U ) | ( (uint32_t)( p ) ) );
} // cvk.version.make_api
template <typename T> constexpr uint32_t make (T const M, T const m, T const p) {
  return cvk::version::make_api(0, M,m,p);
} // cvk.version.make
}  // namespace version
namespace device {
aliasf(destroy, vkDestroyDevice);
}  // namespace device
namespace instance {
aliasf(create, vkCreateInstance);
aliasf(destroy, vkDestroyInstance);
}  // namespace instance
namespace surface {
aliasf(destroy, vkDestroySurfaceKHR);
}  // namespace surface
namespace swapchain {
aliasf(destroy, vkDestroySwapchainKHR);
}  // namespace swapchain
namespace image {
aliasf(destroy, vkDestroyImage);
}  // namespace image
namespace view {
aliasf(destroy, vkDestroyImageView);
}  // namespace  view
}  // namespace cvk

