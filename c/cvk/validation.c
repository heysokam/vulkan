//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
/// @internal
/// @fileoverview
///  Internal api for managing Vulkan Validation and Debugging
//_____________________________________________________________|
#include "../cvk.h"


void cvk_validation_checkSupport (
    bool const validate,
    u32  const listCount,
    cstr const list[listCount]
  ) {
  if (!validate) return;
  u32 count;
  vkEnumerateInstanceLayerProperties(&count, NULL);
  VkLayerProperties* layers = calloc(count, sizeof(VkLayerProperties));
  vkEnumerateInstanceLayerProperties(&count, layers);
  bool found = false;
  for(size_t layerId = 0; layerId < count; ++layerId) {
    VkLayerProperties const layer = layers[layerId];
    for(size_t vlayerID = 0; vlayerID < listCount; ++vlayerID) {
      if (cstr_eq(layer.layerName, list[vlayerID])) { found = true; goto end; }
    }
  } end:
  free(layers);
  if (!found) fail(cvk_Error_validation, "One or more of the validation layers requested is not available in this system.");
}

