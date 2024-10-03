//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @fileoverview Application Tools
//_________________________________|
pub const swapchain = @This();
// @deps vulkan
const c = @import("../lib/vulkan.zig");


//______________________________________
// @section Swapchain
//____________________________
pub const Swapchain = swapchain.T;
pub const T = c.VkSwapchainKHR;

