//:______________________________________________________________________
//  cvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
#pragma once
// @deps External
#include <vulkan/vulkan.hpp>
// @deps cdk
#include "./alias.hpp"



//_________________________________________________
// Cvk : Custom Aliases
//______________________________________

namespace cvulkan {
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

namespace instance {
aliasf(create, vkCreateInstance);
aliasf(destroy, vkDestroyInstance);
}  // namespace instance

namespace device {
aliasf(destroy, vkDestroyDevice);
}  // namespace device

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

