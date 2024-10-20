//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
/// @fileoverview
///  Raw api for managing the cvk_Instance object.
///  @note Validation is not exposed. It is managed from this file.
//__________________________________________________________________|
// @deps
#include "../cvk.h"

cvk_Instance cvk_instance_create(
    cstr                  const appName,
    cdk_Version           const appVers,
    cstr                  const engineName,
    cdk_Version           const engineVers,
    cdk_Version           const apiVers,
    VkInstanceCreateFlags const flags,
    u32                   const extCount,
    cstr                  const exts[],
    bool                  const validate,
    u32                   const layerCount,
    cstr                  const layers[],
    cvk_debug_Cfg         const dbg,
    cvk_Allocator         const A
  ) {
  cvk_Instance result = (cvk_Instance){
    .A                         = A,
    .cfg                       = (VkInstanceCreateInfo){
      .sType                   = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
      .pNext                   = (void*)(&dbg),
      .flags                   = flags,
      .pApplicationInfo        = &(VkApplicationInfo){
        .sType                 = VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pNext                 = NULL,
        .pApplicationName      = appName,
        .applicationVersion    = appVers,
        .pEngineName           = engineName,
        .engineVersion         = engineVers,
        .apiVersion            = apiVers,
        }, //:: result.cfg.pApplicationInfo
      .enabledLayerCount       = layerCount,
      .ppEnabledLayerNames     = layers,
      .enabledExtensionCount   = extCount,
      .ppEnabledExtensionNames = exts,
      }, //:: result.cfg
    }; //:: result
  cvk_validation_checkSupport(validate, layerCount, layers);
  VkResult const code = vkCreateInstance(&result.cfg, result.A, &result.ct);
  if (code != VK_SUCCESS) fail(code, "Failed to create the Vulkan Instance");
  result.dbg = cvk_debug_create(result.ct, dbg, validate, result.A);
  return result;
}

void cvk_instance_destroy (cvk_Instance* const I) { vkDestroyInstance(I->ct, I->A); }

