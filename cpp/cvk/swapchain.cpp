#include "../cvk.hpp"
#include <vulkan/vulkan_core.h>


VkSurfaceFormatKHR cvk::swapchain::select::format (
    cvk::device::SwapchainSupport* const S
  ) {
  for (auto const format : S->formats) {
    if (format.format == VK_FORMAT_B8G8R8A8_SRGB && format.colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
      return format;
    }
  }
  return S->formats[0];
} //:: cvk.swapchain.select.format


VkPresentModeKHR cvk::swapchain::select::mode (
    cvk::device::SwapchainSupport* const S
  ) {
  for (auto const mode : S->modes) if (mode == VK_PRESENT_MODE_MAILBOX_KHR) return  mode;
  return VK_PRESENT_MODE_FIFO_KHR;
} //:: cvk.swapchain.select.mode


cvk::Size cvk::swapchain::select::size (
    cvk::device::SwapchainSupport* const S,
    cvk::Size*                     const prev
  ) {
  if (S->caps.currentExtent.width != u32_high) { return S->caps.currentExtent; }
  return (cvk::Size){
    .width  = u32_clamp(prev->width,  S->caps.minImageExtent.width,  S->caps.maxImageExtent.width),
    .height = u32_clamp(prev->height, S->caps.minImageExtent.height, S->caps.maxImageExtent.height),
    };
} //:: cvk.swapchain.select.size


u32 cvk::swapchain::select::imgMin (
    cvk::device::SwapchainSupport* const S
  ) {
  u32 result = S->caps.minImageCount + 1;
  if (S->caps.maxImageCount > 0) result = u32_max(result, S->caps.maxImageCount);
  return result;
} //:: cvk.swapchain.select.imgMin


cvk::swapchain::Image::Image (
    VkImage            const img,
    VkDevice           const D,
    VkSurfaceFormatKHR const format,
    cvk::Allocator     const A
  ) {
  m->A   = A;
  m->ct  = img;
  m->cfg = (VkImageViewCreateInfo){
    .sType            = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
    .pNext            = NULL,
    .flags            = (VkImageViewCreateFlags)0,
    .image            = m->ct,
    .viewType         = VK_IMAGE_VIEW_TYPE_2D,
    .format           = format.format,
    .components       = (VkComponentMapping){
      .r              = VK_COMPONENT_SWIZZLE_IDENTITY,
      .g              = VK_COMPONENT_SWIZZLE_IDENTITY,
      .b              = VK_COMPONENT_SWIZZLE_IDENTITY,
      .a              = VK_COMPONENT_SWIZZLE_IDENTITY,
      }, //:: result.cfg.components
    .subresourceRange = (VkImageSubresourceRange){
      .aspectMask     = VK_IMAGE_ASPECT_COLOR_BIT,
      .baseMipLevel   = 0,
      .levelCount     = 1,
      .baseArrayLayer = 0,
      .layerCount     = 1,
      }, //:: result.cfg.subresourceRange
    }; //:: result.cfg
  VkResult code = vkCreateImageView(D, &m->cfg, m->A, &m->view);
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve one of the ImageViews used by the Swapchain."); }
} //:: cvk.swapchain.Image.Constructor


cvk::swapchain::images::List cvk::swapchain::images::create (
    VkDevice           const D,
    VkSwapchainKHR     const S,
    VkSurfaceFormatKHR const format,
    cvk::Allocator     const A
  ) {
  u32 count = 0;
  cvk::swapchain::images::List result;
  // Get the images
  VkResult code;
  code = vkGetSwapchainImagesKHR(D, S, &count, NULL);
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve the number of Images used by the Swapchain."); }
  seq<VkImage> images = seq<VkImage>(count);
  code = vkGetSwapchainImagesKHR(D, S, &count, images.data());
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to retrieve the list of Images used by the Swapchain."); }
  // Get the views and return
  for(auto const img : images) result.push_back(cvk::swapchain::Image(img, D, format, A));
  return result;
} //:: cvk.swapchain.images.create


void cvk::swapchain::images::destroy (
    cvk::swapchain::images::List L,
    cvk::Device*                 D
  ) {
  for (auto const img : L) vkDestroyImageView(D->logical.handle(), img.view, img.A);
  L.clear();
} //:: cvk.swapchain.images.destroy

cvk::Swapchain::Swapchain (
    cvk::Device*   const D,
    cvk::Surface   const S,
    cvk::Size*     const size,
    cvk::Allocator const A
  ) {
  cvk::device::SwapchainSupport support = cvk::device::SwapchainSupport(D->physical.handle(), S);
  m->A      = A;
  m->ct     = NULL;
  m->format = cvk::swapchain::select::format(&support);
  m->mode   = cvk::swapchain::select::mode(&support);
  m->size   = cvk::swapchain::select::size(&support, size);
  m->imgMin = cvk::swapchain::select::imgMin(&support);
  m->cfg    = (VkSwapchainCreateInfoKHR){};
  // Create the Swapchain Configuration
  cvk::device::queue::Families fam = cvk::device::queue::Families(D->physical.handle(), S);
  VkSharingMode sharingMode;
  seq<u32> famIDs;
  if (fam.graphics.value() == fam.present.value()) {
    sharingMode = VK_SHARING_MODE_EXCLUSIVE;
  } else if (fam.graphics.has_value() && fam.present.has_value()) {
    sharingMode = VK_SHARING_MODE_CONCURRENT;
    famIDs.push_back(fam.graphics.value());
    famIDs.push_back(fam.present.value());
  } else {
    cvk::fail(cvk::Error::swapchain, "Something went wrong during Swapchain config setup when defining the Sharing mode.");
  }
  m->cfg                   = (VkSwapchainCreateInfoKHR){
    .sType                 = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
    .pNext                 = NULL,
    .flags                 = (VkSwapchainCreateFlagsKHR)0,
    .surface               = S,
    .minImageCount         = m->imgMin,
    .imageFormat           = m->format.format,
    .imageColorSpace       = m->format.colorSpace,
    .imageExtent           = *size,
    .imageArrayLayers      = 1,
    .imageUsage            = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,
    .imageSharingMode      = sharingMode,
    .queueFamilyIndexCount = static_cast<uint32_t>(famIDs.size()),
    .pQueueFamilyIndices   = (famIDs.size() == 0) ? nullptr : famIDs.data(),
    .preTransform          = support.caps.currentTransform,
    .compositeAlpha        = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,
    .presentMode           = m->mode,
    .clipped               = VK_TRUE,
    .oldSwapchain          = NULL,
    }; //:: result.cfg
  // Create the Swapchain and its Images
  VkResult code = vkCreateSwapchainKHR(D->logical.handle(), &m->cfg, m->A, &m->ct);
  if (code != VK_SUCCESS) { cvk::fail(code, "Failed to create the Swapchain"); }
  m->images = cvk::swapchain::images::create(D->logical.handle(), m->ct, m->format, m->A);
} //:: cvk.Swapchain.Constructor

void cvk::Swapchain::destroy (cvk::Device* D) {
  cvk::swapchain::images::destroy(m->images, D);
  vkDestroySwapchainKHR(D->logical.handle(), m->ct, m->A);
} //:: cvk.Swapchain.destroy

