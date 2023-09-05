//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined cvk_vulkan
#  include "./core.h"
#endif

Vulkan cvk_init(cvk_init_args in) {
  Vulkan result;
  VkDebugMessengerCfg debugCfg = cvk_validate_setupDebugCfg(Cfg_DebugFlags, Cfg_DebugSeverity, Cfg_DebugMsgType, in.allocator);
  result.allocator = in.allocator;
  result.instance  = cvk_instance_create((cvk_instance_create_args) {
    .appName    = in.appName,
    .appVers    = in.appVers,
    .engineName = in.engineName,
    .engineVers = in.engineVers,
    .debugCfg   = &debugCfg,
    });  // << instance
  result.dbg = cvk_validate_createDebug(result.instance, &debugCfg, result.allocator);
  return result;
}
void cvk_update(Vulkan* vk) { discard(vk); }
void cvk_term(Vulkan* vk) {
  cvk_validate_destroyDebug(vk->instance, vk->dbg, vk->allocator);
  vkDestroyInstance(vk->instance, vk->allocator);
}
