//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Raw api for managing the cvk_Swapchain object
//______________________________________________________________|
#include "../cvk.h"


VkSurfaceFormatKHR cvk_swapchain_select_format (cvk_device_SwapchainSupport* const support) {
  u32 const count = support->formatCount;
  for(size_t id = 0; id < count; ++id) {
    VkSurfaceFormatKHR const format = support->formats[id];
    if (format.format == VK_FORMAT_B8G8R8A8_SRGB && format.colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
      return format;
    }
  }
  return support->formats[0];
} //:: cvk_swapchain_formatSelect

VkPresentModeKHR cvk_swapchain_select_mode (cvk_device_SwapchainSupport* const support) {
  u32 const count = support->modeCount;
  for(size_t id = 0; id < count; ++id) {
    VkPresentModeKHR const mode = support->modes[id];
    if (mode == VK_PRESENT_MODE_MAILBOX_KHR) {
      return VK_PRESENT_MODE_MAILBOX_KHR;
    }
  }
  return VK_PRESENT_MODE_FIFO_KHR;
} //:: cvk_swapchain_select_mode

cvk_Size cvk_swapchain_select_size (cvk_device_SwapchainSupport* const support, cvk_Size* const size) {
  if (support->caps.currentExtent.width != u32_high) { return support->caps.currentExtent; }
  return (VkExtent2D){
    .width  = u32_clamp(size->width,  support->caps.minImageExtent.width,  support->caps.maxImageExtent.width),
    .height = u32_clamp(size->height, support->caps.minImageExtent.height, support->caps.maxImageExtent.height),
    };
} //:: cvk_swapchain_select_size

u32 cvk_swapchain_select_imgMin (cvk_device_SwapchainSupport* const support) {
  u32 result = support->caps.minImageCount + 1;
  if (support->caps.maxImageCount > 0) { result = u32_max(result, support->caps.maxImageCount); }
  return result;
} //:: cvk_swapchain_select_imgMin


cvk_Swapchain cvk_swapchain_create (
    cvk_Device*   const device,
    cvk_Surface   const surface,
    cvk_Size*     const size,
    cvk_Allocator const allocator
  ) {
  cvk_device_SwapchainSupport support = cvk_device_swapchainSupport_create(device->physical.ct, surface);
  cvk_Swapchain result = (cvk_Swapchain){
    .A      = allocator,
    .ct     = NULL,
    .format = cvk_swapchain_select_format(&support),
    .mode   = cvk_swapchain_select_mode(&support),
    .size   = cvk_swapchain_select_size(&support, size),
    .imgMin = cvk_swapchain_select_imgMin(&support),
    .cfg    = (VkSwapchainCreateInfoKHR){0},
    }; //:: result

  // Create the Swapchain Configuration
  cvk_QueueFamilies fam = cvk_queue_families_create(device->physical.ct, surface);
  VkSharingMode sharingMode;
  u32 famCount;
  u32* famIDs;
  if (Ou32_eq(fam.graphics, fam.present)) {
    sharingMode = VK_SHARING_MODE_EXCLUSIVE;
    famCount    = 0;
    famIDs      = NULL;
  } else if (fam.graphics.hasValue && fam.present.hasValue) {
    sharingMode = VK_SHARING_MODE_CONCURRENT;
    famCount    = 2;
    famIDs      = (u32*)calloc(famCount, sizeof(u32));
    famIDs[0]   = fam.graphics.value;
    famIDs[1]   = fam.present.value;
  } else {
    fail(cvk_Error_swapchain, "Something went wrong during Swapchain config setup when defining the Sharing mode.");
  }
  result.cfg               = (VkSwapchainCreateInfoKHR){
    .sType                 = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
    .pNext                 = NULL,
    .flags                 = (VkSwapchainCreateFlagsKHR)0,
    .surface               = surface,
    .minImageCount         = result.imgMin,
    .imageFormat           = result.format.format,
    .imageColorSpace       = result.format.colorSpace,
    .imageExtent           = *size,
    .imageArrayLayers      = 1,
    .imageUsage            = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,
    .imageSharingMode      = sharingMode,
    .queueFamilyIndexCount = famCount,
    .pQueueFamilyIndices   = famIDs,
    .preTransform          = support.caps.currentTransform,
    .compositeAlpha        = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,
    .presentMode           = result.mode,
    .clipped               = VK_TRUE,
    .oldSwapchain          = NULL,
    }; //:: result.cfg
  // Create the Swapchain and its Images
  VkResult code = vkCreateSwapchainKHR(device->logical.ct, &result.cfg, allocator, &result.ct);
  if (code != VK_SUCCESS) { fail(code, "Failed to create the Swapchain"); }
  code = vkGetSwapchainImagesKHR(device->logical.ct, result.ct, &result.imgCount, NULL);
  if (code != VK_SUCCESS) { fail(code, "Failed to retrieve the number of Images used by the Swapchain."); }
  result.images = (VkImage*)calloc(result.imgCount, sizeof(VkImage));
  code = vkGetSwapchainImagesKHR(device->logical.ct, result.ct, &result.imgCount, result.images);
  if (code != VK_SUCCESS) { fail(code, "Failed to retrieve the list of Images used by the Swapchain."); }
  result.views = (VkImageView*)calloc(result.imgCount, sizeof(VkImageView));
  for(size_t id = 0; id < result.imgCount; ++id) {
    code = vkCreateImageView(device->logical.ct, &(VkImageViewCreateInfo){
      .sType            = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
      .pNext            = NULL,
      .flags            = (VkImageViewCreateFlags)0,
      .image            = result.images[id],
      .viewType         = VK_IMAGE_VIEW_TYPE_2D,
      .format           = result.format.format,
      .components       = (VkComponentMapping){
        .r              = 0,
        .g              = 0,
        .b              = 0,
        .a              = 0,
        },
      .subresourceRange = (VkImageSubresourceRange){
        .aspectMask     = VK_IMAGE_ASPECT_COLOR_BIT,
        .baseMipLevel   = 0,
        .levelCount     = 1,
        .baseArrayLayer = 0,
        .layerCount     = 1,
        },
      }, allocator, &result.views[id]);
    if (code != VK_SUCCESS) { fail(code, "Failed to retrieve one of the ImageViews used by the Swapchain."); }
  }
  cvk_device_swapchainSupport_destroy(&support);
  return result;
} //:: cvk_swapchain_create

void cvk_swapchain_destroy (
    cvk_Swapchain*      const swapchain,
    cvk_device_Logical* const device
  ) {
  u32 const count = swapchain->imgCount;
  for(size_t id = 0; id < count; ++id) { vkDestroyImageView(device->ct, swapchain->views[id], swapchain->A); }
  vkDestroySwapchainKHR(device->ct, swapchain->ct, swapchain->A);
} //:: cvk_swapchain_destroy

