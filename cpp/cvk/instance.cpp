//:___________________________________________________________________
//  cvk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
#include "../cvk.hpp"

cvk::Instance::Instance(
    str                   const appName,
    cvk::Version          const appVers,
    str                   const engineName,
    cvk::Version          const engineVers,
    cvk::Version          const apiVers,
    VkInstanceCreateFlags const flags,
    seq<cstr>             const exts,
    bool                  const validate,
    seq<cstr>             const layers,
    cvk::debug::Cfg       const dbg,
    cvk::Allocator        const A
  ) {
  m->A = A;
  VkApplicationInfo const appCfg = (VkApplicationInfo){
    .sType                 = VK_STRUCTURE_TYPE_APPLICATION_INFO,
    .pNext                 = NULL,
    .pApplicationName      = appName.data(),
    .applicationVersion    = appVers,
    .pEngineName           = engineName.data(),
    .engineVersion         = engineVers,
    .apiVersion            = apiVers,
    }; //:: result.cfg.pApplicationInfo
  m->cfg = (VkInstanceCreateInfo){
    .sType                   = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    .pNext                   = (void*)(&dbg),
    .flags                   = flags,
    .pApplicationInfo        = &appCfg,
    .enabledLayerCount       = static_cast<u32>(layers.size()),
    .ppEnabledLayerNames     = layers.data(),
    .enabledExtensionCount   = static_cast<u32>(exts.size()),
    .ppEnabledExtensionNames = exts.data(),
    }; //:: result.cfg
  cvk::validation::checkSupport(validate, layers);
  VkResult const code = vkCreateInstance(&m->cfg, m->A, &m->ct);
  if (code != VK_SUCCESS) cvk::fail(code, "Failed to create the Vulkan Instance");
  m->dbg = cvk::Debug(m->ct, dbg, validate, A);
}

/* cvk::Instance::~Instance() { */
/*   m->dbg.destroy(*m); */
/*   vkDestroyInstance(m->ct, m->A); */
/* } */

void cvk::Instance::destroy (void) {
  m->dbg.destroy(*m);
  vkDestroyInstance(m->ct, m->A);
} //:: cvk::Instance::destroy

