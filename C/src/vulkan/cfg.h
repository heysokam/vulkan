//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#pragma once
#include "./base.h"

// Vulkan API version
#if !defined Cfg_ApiVersion
#define Cfg_ApiVersion VK_MAKE_API_VERSION(0,1,0,0)
#endif

// Vulkan Validation
#if !defined Cfg_validate && debug
#define Cfg_validate true
#elif !defined Cfg_validate
#define Cfg_validate false
#endif

#if debug
extern cstr validationLayers[Max_VulkanLayers];
#else
extern cstr const* validationLayers;
#endif

