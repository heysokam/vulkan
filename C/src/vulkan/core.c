//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#if !defined cvk_vulkan
#  include "./core.h"
#endif

Vulkan cvk_init(cvk_init_args in) {
  Vulkan result = {
    .instance = cvk_instance_create((cvk_instance_create_args) {
      .appName    = in.appName,
      .appVers    = in.appVers,
      .engineName = in.engineName,
      .engineVers = in.engineVers,
    })  // << instance
  };    // << result
  return result;
}
void cvk_update(Vulkan* vk) { discard(vk); }
void cvk_term(Vulkan* vk) {
  vkDestroyInstance(vk->instance, NULL);
}
