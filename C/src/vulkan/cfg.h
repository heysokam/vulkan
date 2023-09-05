//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
#include "./base.h"

// Vulkan API version
#if !defined Cfg_ApiVersion
#define Cfg_ApiVersion VK_MAKE_API_VERSION(0,1,0,0)
#endif

/// Vulkan Validation & Debug
#if !defined Cfg_validate && debug
#define Cfg_validate true
#elif !defined Cfg_validate
#define Cfg_validate false
#endif
// clang-format off
#define Cfg_DebugFlags    0
#define Cfg_DebugSeverity VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT
#define Cfg_DebugMsgType  VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT     | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT  | VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT
// clang-format on
