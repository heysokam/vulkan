//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#include "./validation.h"

#if debug
cstr validationLayers[Max_VulkanLayers] = {
  "VK_LAYER_KHRONOS_validation",
};
#else
cstr const* validationLayers = NULL;
#endif

bool cvk_validate_chkSupport(void) {
  #if debug
  // Get the layer names with glfw
  u32 count;
  vkEnumerateInstanceLayerProperties(&count, NULL);
  VkLayerProperties* layers = (VkLayerProperties*)alloc(sizeof(VkLayerProperties), count);
  vkEnumerateInstanceLayerProperties(&count, layers);
  // Check if your defined names exist in the list available layers returned by glfw
  for (u32 layerId = 0; layerId < count; layerId++) {
    bool found = false;
    str  name  = layers[layerId].layerName;
    for (u32 vlayerId = 0; vlayerId < Max_VulkanLayers; vlayerId++) {  // clang-format off
      if (str_equal(name, validationLayers[vlayerId])){ found = true; break; }
    }
    if (!found) { free(layers); return false; }
  }
  free(layers); return true;  // clang-format on
  #else
  return true;
  #endif
}

