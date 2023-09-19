//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
const C = @cImport(@cInclude("vulkan/vulkan.h"));
pub const Instance        = C.VkInstance;
pub const instanceCreate  = C.vkCreateInstance;
pub const instanceDestroy = C.vkDestroyInstance;
