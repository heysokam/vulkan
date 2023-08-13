//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#if !defined cvk_vulkan
#include "./core.h"
#endif
#include "../cdk/input.h"

Vulkan cvk_init(cvk_init_args in) {
  // clang-format off
  Vulkan result = {
    .win           = w_init((w_init_args){
      .title       = in.title,
      .width       = in.width,
      .height      = in.height,
      .resize      = in.resize,
      .resizeCB    = in.resizeCB,
      .error       = in.error,
      .key         = in.key,
      .mousePos    = in.mousePos,
      .mouseBtn    = in.mouseBtn,
      .mouseScroll = in.mouseScroll,
      }), // << win
    .instance      = cvk_instance_create((cvk_instance_create_args){
      .appName     = in.appName,
      .appVers     = in.appVers,
      .engineName  = in.engineName,
      .engineVers  = in.engineVers,
      }) // << instance
    }; // << result
  // clang-format on
  return result;
}
void cvk_update(Vulkan *vk) { w_update(vk->win); }
bool cvk_close(Vulkan *vk) { return w_close(vk->win); }
void cvk_term(Vulkan *vk) {
  vkDestroyInstance(vk->instance, NULL);
  w_term(vk->win);
}
