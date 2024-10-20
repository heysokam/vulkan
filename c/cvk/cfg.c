//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "../cvk.h"


//______________________________________
// @section Configuration: General
//____________________________
const static u32 cvk_cfg_Version = VK_MAKE_API_VERSION(0, 1,3,0);
#define cvk_cfg_debug cdk_debug


//______________________________________
// @section Configuration: Validation
//____________________________
const static bool cvk_cfg_validation_Active = cvk_cfg_debug;
#if cvk_cfg_debug
#define cvk_cfg_validation_LayerCount 1
extern const cstr cvk_cfg_validation_Layers[cvk_cfg_validation_LayerCount]; const cstr cvk_cfg_validation_Layers[cvk_cfg_validation_LayerCount] = {
  [0]= "VK_LAYER_KHRONOS_validation",
};
#else
#define cvk_cfg_validation_LayerCount 0
extern const cstr cvk_cfg_validation_Layers[]; const cstr cvk_cfg_validation_Layers[] = {0};
#endif
const static cvk_debug_Flags cvk_cfg_validation_DebugFlags = 0;
const static cvk_debug_Severity cvk_cfg_validation_DebugSeverity =
  VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT |
  VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
  VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
const static cvk_debug_MsgType cvk_cfg_validation_DebugMsgType =
  VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
  VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
  VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;


//______________________________________
// @section Configuration: Instance
//____________________________
#if defined(macosx)
#define cvk_cfg_instance_Flags VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR
#define cvk_cfg_instance_ExtensionsCount 2
const static cstr cvk_cfg_instance_Extensions[cvk_cfg_instance_ExtensionsCount] = {
  [0]= VK_EXT_DEBUG_UTILS_EXTENSION_NAME,
  [1]= VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME,
};
#else
#define cvk_cfg_instance_Flags 0
#define cvk_cfg_instance_ExtensionsCount 1
const static cstr cvk_cfg_instance_Extensions[cvk_cfg_instance_ExtensionsCount] = {
  [0]= VK_EXT_DEBUG_UTILS_EXTENSION_NAME,
};
#endif


//______________________________________
// @section Configuration: Device
//____________________________
const static bool cvk_cfg_device_ForceFirst = true;

