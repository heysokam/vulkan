//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
#include <stdio.h>
#define DEBUG
// @deps cdk
#define GLFW_INCLUDE_VULKAN
#include "./csys.h"
#include "./cvk.h"
// @deps Buildsystem SCU
#include "./cstd.c"
#include "./cmem.c"
#include "./csys.c"
#define cvk_SCU
#include "./cvk.c"

typedef struct Gpu {
  cvk_Allocator A;
  cvk_Instance  instance;
  cvk_Surface   surface;
  cvk_Device    device;
  cvk_Swapchain swapchain;
} Gpu;

/// @internal
/// @descr Gets the full list of instance extensions, by merging our desired {@arg list} with the ones required by the system.
/// @note Makes the library dependent on GLFW
cstr_List gpu_instance_extensions_get (u32 const listCount, cstr const list[], u32* const total);
cstr_List gpu_instance_extensions_get (u32 const listCount, cstr const list[], u32* const total) {
  cstr_List const required = glfwGetRequiredInstanceExtensions(total);
  if (!required) fail(cvk_Error_extensions, "Couldn't find any Vulkan Extensions. Vk is not usable (probably not installed)");
  cstr exts[listCount];
  for(size_t id = 0; id < listCount; ++id) exts[id] = list[id];
  cstr_List const result = cstr_List_merge(required, (Sz)(*total), exts, listCount);
  *total = *total + listCount;
  return result;
}

typedef cvk_Surface gpu_Surface;
gpu_Surface gpu_surface_create (cvk_Instance const instance, GLFWwindow* const window);
gpu_Surface gpu_surface_create (cvk_Instance const instance, GLFWwindow* const window) {
  /// @descr Returns a valid Vulkan Surface for the {@arg window}
  /// @todo Forces the library to depend on GLFW
  cvk_Surface result = NULL;
  VkResult const code = glfwCreateWindowSurface(instance.ct, window, instance.A, &result);
  if (code != VK_SUCCESS) { fail(code, "Failed to get the Vulkan Surface from the given GLFW window."); }
  return result;
}

/// @descr Returns a Swapchain object with the size of the {@arg window}
/// @note Makes the library to dependent on GLFW
cvk_Swapchain gpu_swapchain_create (cvk_Device* const device, GLFWwindow* const window, cvk_Surface const surface, cvk_Size* const size, cvk_Allocator const allocator);
cvk_Swapchain gpu_swapchain_create (
    cvk_Device*   const device,
    GLFWwindow*   const window,
    cvk_Surface   const surface,
    cvk_Size*     const size,
    cvk_Allocator const allocator
  ) {
  i32 W = 0; i32 H = 0;
  glfwGetFramebufferSize(window, &W, &H);
  size->width  = (u32)W;
  size->height = (u32)H;
  return cvk_swapchain_create(device, surface, size, allocator);
}

typedef struct gpu_init_args_s {
  cstr          appName;
  cdk_Version   appVers;
  cstr          engineName;
  cdk_Version   engineVers;
  cvk_Allocator allocator;
  GLFWwindow*   window;
  cvk_Size*     size;
} gpu_init_args;
gpu_init_args gpu_init_args_defaults (GLFWwindow* const window, cvk_Size* const size) {
  return (gpu_init_args){
    .appName    = "HelloVulkan | C | Application",
    .appVers    = cdk_version_new(0, 0, 0),
    .engineName = "HelloVulkan | C | Engine",
    .engineVers = cdk_version_new(0, 0, 0),
    .allocator  = NULL,
    .window     = window,
    .size       = size,
  };
}
Gpu gpu_init (gpu_init_args in) {
  Gpu result = (Gpu){.A= in.allocator};
  u32 extCount = 0;
  cstr_List const exts = gpu_instance_extensions_get(cvk_cfg_instance_ExtensionsCount, cvk_cfg_instance_Extensions, &extCount);
  cvk_debug_Cfg debugCfg = cvk_debug_setup(
    /* flags    */  cvk_cfg_validation_DebugFlags,
    /* severity */  cvk_cfg_validation_DebugSeverity,
    /* msgType  */  cvk_cfg_validation_DebugMsgType,
    /* callback */  cvk_debug_cb,
    /* userdata */  NULL
    ); //:: debugCfg
  result.instance = cvk_instance_create(
    /* appName    */  in.appName,
    /* appVers    */  in.appVers,
    /* engineName */  in.engineName,
    /* engineVers */  in.engineVers,
    /* apiVers    */  cvk_cfg_Version,
    /* flags      */  cvk_cfg_instance_Flags,
    /* extCount   */  extCount,
    /* exts       */  exts,
    /* validate   */  cvk_cfg_validation_Active,
    /* layerCount */  cvk_cfg_validation_LayerCount,
    /* layers     */  cvk_cfg_validation_Layers,
    /* dbg        */  debugCfg,
    /* A          */  result.A
    ); //:: result.instance
  result.surface   = gpu_surface_create(result.instance, in.window);
  result.device    = cvk_device_create(result.instance, result.surface, cvk_cfg_device_ForceFirst);
  result.swapchain = gpu_swapchain_create(&result.device, in.window, result.surface, in.size, result.A);
  return result;
}

void gpu_term (Gpu* gpu) {
  cvk_swapchain_destroy(&gpu->swapchain, &gpu->device.logical);
  cvk_device_destroy(&gpu->device);
  cvk_surface_destroy(gpu->instance.ct, gpu->surface, gpu->instance.A);
  cvk_debug_destroy(&gpu->instance.dbg, &gpu->instance);
  cvk_instance_destroy(&gpu->instance);
}

void gpu_update (Gpu* gpu) { discard(gpu); return; }

//______________________________________
// @section Entry Point
//____________________________
void cli_report (void);
//__________________
int main (int const argc, char const* argv[argc]) {
  // Config
  str      gpu_cfg_title = "c*vk | Hello Vulkan";
  cvk_Size gpu_cfg_size  = {.width= 960, .height= 540};
  // Process
  cli_report();
  csys_System sys = csys_init((csys_init_args) {
    // clang-format off
    .win           = (w_init_args){
      .title       = gpu_cfg_title,
      .width       = gpu_cfg_size.width,
      .height      = gpu_cfg_size.height,
      .resize      = false,
      .resizeCB    = w_resize,
      .error       = w_error,
      }, // << window
    .inp           = (i_init_args){
      .key         = i_key,
      .mousePos    = NULL,
      .mouseBtn    = NULL,
      .mouseScroll = NULL,
      }, // << input
  });  // clang-format on
  Gpu gpu = gpu_init(gpu_init_args_defaults(sys.win.ct, &gpu_cfg_size));
  while (!csys_close(&sys)) {
    csys_update(&sys);
    gpu_update(&gpu);
  }
  gpu_term(&gpu);
  csys_term(&sys);
  return 0;
} //:: main

//__________________
inline void cli_report (void) {
  #if cdk_debug
  printf("Hello cvk Entry with -DDEBUG. Validation Layers are active.\n");
  #else
  printf("Hello cvk Entry. Validation Layers are inactive.\n");
  #endif
}

