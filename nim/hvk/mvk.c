/// m*std  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
/// m*std  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#include <stdint.h>
typedef uint8_t byte;
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
typedef uintptr_t uP;
typedef size_t Sz;
typedef int8_t i8;
typedef int16_t i16;
typedef int32_t i32;
typedef int64_t i64;
typedef intptr_t iP;
typedef float f32;
typedef double f64;
typedef char* str;
typedef char const* cstr;
typedef struct Handle Handle;
struct Handle {
  u32 id;
  };
typedef struct Garr Garr;
struct Garr {
  Sz len;
  Sz cap;
  void* data;
  };
typedef struct ByteBuffer ByteBuffer;
struct ByteBuffer {
  Sz len;
  Sz cap;
  byte* data;
  };
/// Type Tools
bool f32_inRange (f32 const val, f32 const minv, f32 const maxv);
bool f32_inRange (f32 const val, f32 const minv, f32 const maxv) {
  return val >= minv && val <= maxv;
}
bool f32_zeroToOne (f32 const val);
bool f32_zeroToOne (f32 const val) {
  return f32_inRange(val, 0.0, 1.0);
}
extern const/*comptime*/ u8 u8_high; const/*comptime*/ u8 u8_high = (u8)(~0);
extern const/*comptime*/ u16 u16_high; const/*comptime*/ u16 u16_high = (u16)(~0);
extern const/*comptime*/ u32 u32_high; const/*comptime*/ u32 u32_high = (u32)(~0);
extern const/*comptime*/ u64 u64_high; const/*comptime*/ u64 u64_high = (u64)(~0);
u32 u32_min (u32 const val, u32 const m);
u32 u32_min (u32 const val, u32 const m) {
  return (val < m) ? m : val;
}
u32 u32_max (u32 const val, u32 const M);
u32 u32_max (u32 const val, u32 const M) {
  return (val > M) ? M : val;
}
u32 u32_clamp (u32 const val, u32 const m, u32 const M);
u32 u32_clamp (u32 const val, u32 const m, u32 const M) {
  return u32_max(u32_min(val, m), M);
}
extern const/*comptime*/ i8 i8_high; const/*comptime*/ i8 i8_high = (i8)(~0);
extern const/*comptime*/ i16 i16_high; const/*comptime*/ i16 i16_high = (i16)(~0);
extern const/*comptime*/ i32 i32_high; const/*comptime*/ i32 i32_high = (i32)(~0);
extern const/*comptime*/ i64 i64_high; const/*comptime*/ i64 i64_high = (i64)(~0);
i32 i32_min (i32 const val, i32 const m);
i32 i32_min (i32 const val, i32 const m) {
  return (val < m) ? m : val;
}
i32 i32_max (i32 const val, i32 const M);
i32 i32_max (i32 const val, i32 const M) {
  return (val > M) ? M : val;
}
i32 i32_clamp (i32 const val, i32 const m, i32 const M);
i32 i32_clamp (i32 const val, i32 const m, i32 const M) {
  return i32_max(i32_min(val, m), M);
}
/// m*std  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#include <stdio.h>
/// General Tools
void echo (cstr const msg);
void echo (cstr const msg) {
  printf("%s\n", msg);
}
/// Systems aliasing
#if defined(__WIN32)
#define windows
#endif
#if defined(__linux__)
#if !defined(linux)
#define linux
#endif
#define unix
#endif
#if defined(__APPLE__)
#define macosx
#define unix
#endif
// namespace mstd
/// Build Mode aliasing
#if defined(DEBUG)
#define mstd_debug true
#define mstd_release false
#else
#define mstd_debug false
#define mstd_release true
#endif
u32 mstd_vers_new (u32 const M, u32 const m, u32 const p);
u32 mstd_vers_new (u32 const M, u32 const m, u32 const p) {
  return (u32)(M << 22) | (u32)(m << 12) | p;
}
// namespace _
/// String Tools
#include <string.h>
bool cstr_eq (cstr const A, cstr const B);
bool cstr_eq (cstr const A, cstr const B) {
  return strcmp(A, B) == 0;
}
cstr cstr_dup (cstr const src);
cstr cstr_dup (cstr const src) {
  /// Duplicates the `src` string by allocating a new copy of its data and returning it.
  /// Port of musl/strdup | musl.libc.org | MIT License
  Sz const len = strlen(src) + 1;
  str result = (str)malloc(len * sizeof(char));
  if (!result) {
    return NULL;
  }
  return memcpy((void*)result, src, len);
}
cstr* cstr_arr_merge (cstr* const A, Sz const lenA, cstr* const B, Sz const lenB);
cstr* cstr_arr_merge (cstr* const A, Sz const lenA, cstr* const B, Sz const lenB) {
  /// Combines the two given cstr arrays into a single one, and returns it.
  /// Allocates the memory that stores the information.
  cstr* result = calloc(lenA + lenB, sizeof(cstr));
  memcpy(result, A, lenA * sizeof(*A));
  memcpy(result + lenA, B, lenB * sizeof(*B));
  return result;
}
bool cstr_arr_contains (cstr* const arr, Sz const len, cstr const val);
bool cstr_arr_contains (cstr* const arr, Sz const len, cstr const val) {
  /// Returns true if the array of strings `arr` contains the given `val` string
  for(size_t id = 0; id < len; ++id) {
    if (cstr_eq(arr[id], val)) {
      return true;
    }
  }
  return false;
}
/// Optional types
typedef struct Ou32 Ou32;
struct Ou32 {
  u32 value;
  bool hasValue;
  u8 priv_pad1;
  u16 priv_pad2;
  };
void Ou32_set (Ou32* const it, u32 const val);
void Ou32_set (Ou32* const it, u32 const val) {
  it->hasValue = true;
  it->value = val;
}
Ou32 Ou32_some (u32 const val);
Ou32 Ou32_some (u32 const val) {
  return (Ou32){
      .hasValue= true,
      .value= val,
      };
}
Ou32 Ou32_none (void);
Ou32 Ou32_none (void) {
  return (Ou32){
      .hasValue= false,
      .value= (u32)-1,
      };
}
bool Ou32_eq (Ou32 const A, Ou32 const B);
bool Ou32_eq (Ou32 const A, Ou32 const B) {
  return A.hasValue && B.hasValue && A.value == B.value;
}
/// m*std  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#include <stdlib.h>
/// Error Management
void err (cstr const msg);
[[noreturn]] void err (cstr const msg) {
  echo(msg);
  exit(-1);
}
#define GLFW_INCLUDE_VULKAN
/// m*sys  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
/// m*glfw  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
// Disable documentation errors for GLFW functions
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#pragma clang diagnostic ignored "-Wdocumentation-unknown-command"

#include <GLFW/glfw3.h>
// Stop->  diagnostic ignored "-Wdocumentation" "-Wdocumentation-unknown-command"
#pragma clang diagnostic pop

/// GLFW: Aliases
// namespace glfw
extern const/*comptime*/ i32 ClientApi; const/*comptime*/ i32 ClientApi = GLFW_CLIENT_API;
extern const/*comptime*/ i32 NoApi; const/*comptime*/ i32 NoApi = GLFW_NO_API;
extern const/*comptime*/ i32 Resizable; const/*comptime*/ i32 Resizable = GLFW_RESIZABLE;
extern const/*comptime*/ i32 GLVers_M; const/*comptime*/ i32 GLVers_M = GLFW_CONTEXT_VERSION_MAJOR;
extern const/*comptime*/ i32 GLVers_m; const/*comptime*/ i32 GLVers_m = GLFW_CONTEXT_VERSION_MINOR;
extern const/*comptime*/ i32 OpenGLProf; const/*comptime*/ i32 OpenGLProf = GLFW_OPENGL_PROFILE;
extern const/*comptime*/ i32 OpenGLCore; const/*comptime*/ i32 OpenGLCore = GLFW_OPENGL_CORE_PROFILE;
extern const/*comptime*/ i32 ColorBit; const/*comptime*/ i32 ColorBit = GL_COLOR_BUFFER_BIT;
extern const/*comptime*/ i32 glfw_KeyEscape; const/*comptime*/ i32 glfw_KeyEscape = GLFW_KEY_ESCAPE;
extern const/*comptime*/ i32 glfw_Press; const/*comptime*/ i32 glfw_Press = GLFW_PRESS;
// namespace _
/// Types
// namespace msys
typedef struct msys_Window msys_Window;
struct msys_Window {
  GLFWwindow* ct;
  Sz W;
  Sz H;
  cstr title;
  };
typedef Handle msys_Input;
typedef struct msys_System msys_System;
struct msys_System {
  msys_Window win;
  msys_Input inp;
  char priv_pad[4];
  };
// namespace _
/// Input Manager
// namespace i
void i_key (GLFWwindow* win, i32 key, i32 code, i32 action, i32 mods);
void i_key (GLFWwindow* win, i32 key, i32 code, i32 action, i32 mods) {
  (void)code;/*discard*/
  (void)mods;/*discard*/
  if (key == glfw_KeyEscape && action == glfw_Press) {
    glfwSetWindowShouldClose(win, true);
  }
}
// namespace _
/// Callbacks
// namespace msys.cb
void msys_cb_resize (GLFWwindow* win, i32 W, i32 H);
void msys_cb_resize (GLFWwindow* win, i32 W, i32 H) {
  /// GLFW resize Callback
  (void)win;/*discard*/
  (void)W;/*discard*/
  (void)H;/*discard*/
}
void msys_cb_error (i32 code, cstr descr);
void msys_cb_error (i32 code, cstr descr) {
  /// GLFW error callback
  printf("GLFW.Error:%d %s\n", code, descr);
}
// namespace _
// namespace msys.window
msys_Window msys_window_init (Sz const W, Sz const H, cstr const title, GLFWframebuffersizefun const resizeCB, void* const userdata);
msys_Window msys_window_init (Sz const W, Sz const H, cstr const title, GLFWframebuffersizefun const resizeCB, void* const userdata) {
  glfwWindowHint(ClientApi, NoApi);
  glfwWindowHint(Resizable, false);
  msys_Window result =(msys_Window){
    .ct= glfwCreateWindow((i32)W, (i32)H, title, NULL, NULL),
    .W= W,
    .H= H,
    .title= title,
    };
  if (!result.ct) {
    err("Failed to create the GLFW window");
  }
  glfwSetWindowUserPointer(result.ct, userdata);
  glfwSetFramebufferSizeCallback(result.ct, resizeCB);
  return result;
}
// namespace _
// namespace msys.input
msys_Input msys_input_init (GLFWwindow* const win, GLFWkeyfun const keyCB, GLFWcursorposfun const mousePos, GLFWmousebuttonfun const mouseBtn, GLFWscrollfun const mouseScroll);
msys_Input msys_input_init (GLFWwindow* const win, GLFWkeyfun const keyCB, GLFWcursorposfun const mousePos, GLFWmousebuttonfun const mouseBtn, GLFWscrollfun const mouseScroll) {
  glfwSetKeyCallback(win, keyCB);
  glfwSetCursorPosCallback(win, mousePos);
  glfwSetMouseButtonCallback(win, mouseBtn);
  glfwSetScrollCallback(win, mouseScroll);
  return (msys_Input){
      .id= 666,
      };
}
// namespace _
/// msys.Core
// namespace msys
bool msys_close (msys_System* const sys);
bool msys_close (msys_System* const sys) {
  return glfwWindowShouldClose(sys->win.ct);
}
void msys_update (msys_System* const sys);
void msys_update (msys_System* const sys) {
  (void)sys;/*discard*/
  glfwPollEvents();
}
void msys_term (msys_System* const sys);
void msys_term (msys_System* const sys) {
  glfwDestroyWindow(sys->win.ct);
  glfwTerminate();
}
msys_System msys_init (Sz const W, Sz const H, cstr const title, GLFWerrorfun const errorCB, GLFWframebuffersizefun const resizeCB, GLFWkeyfun const keyCB, GLFWcursorposfun const mousePos, GLFWmousebuttonfun const mouseBtn, GLFWscrollfun const mouseScroll, void* const userdata);
msys_System msys_init (Sz const W, Sz const H, cstr const title, GLFWerrorfun const errorCB, GLFWframebuffersizefun const resizeCB, GLFWkeyfun const keyCB, GLFWcursorposfun const mousePos, GLFWmousebuttonfun const mouseBtn, GLFWscrollfun const mouseScroll, void* const userdata) {
  glfwSetErrorCallback(errorCB);
  if (!glfwInit()) {
    err("Failed to Initialize GLFW");
  }
  msys_System result;
  result.win = msys_window_init(W, H, title, resizeCB, userdata);
  result.inp = msys_input_init(result.win.ct, keyCB, mousePos, mouseBtn, mouseScroll);
  return result;
}
// namespace _
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview
///  Cable connector to all modules of m*vk
///  m*vk is the code that interacts directly with Vulkan
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview Contains all type definitions for m*vk
/// m*gpu  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview
///  Cable connector to the Vulkan API for m*vk
#include <vulkan/vulkan.h>
typedef struct mvk_Debug mvk_Debug;
struct mvk_Debug {
  VkDebugUtilsMessengerEXT* ct;
  VkDebugUtilsMessengerCreateInfoEXT cfg;
  };
typedef struct mvk_Instance mvk_Instance;
struct mvk_Instance {
  VkInstance ct;
  VkApplicationInfo info;
  mvk_Debug dbg;
  VkAllocationCallbacks* allocator;
  };
typedef struct mvk_QueueFamilies mvk_QueueFamilies;
struct mvk_QueueFamilies {
  u32 propCount;
  u32 priv_pad;
  VkQueueFamilyProperties* props;
  Ou32 graphics;
  Ou32 present;
  };
typedef struct mvk_QueueEntry mvk_QueueEntry;
struct mvk_QueueEntry {
  Ou32 id;
  VkQueue ct;
  };
typedef struct mvk_Queue mvk_Queue;
struct mvk_Queue {
  mvk_QueueEntry graphics;
  mvk_QueueEntry present;
  };
typedef struct mvk_Device mvk_Device;
struct mvk_Device {
  VkPhysicalDevice physical;
  mvk_Queue queue;
  VkDevice logical;
  };
#define mvk_Surface VkSurfaceKHR
typedef struct mvk_device_SwapchainSupport mvk_device_SwapchainSupport;
struct mvk_device_SwapchainSupport {
  VkSurfaceCapabilitiesKHR caps;
  u32 formatCount;
  VkSurfaceFormatKHR* formats;
  u32 priv_pad1;
  u32 modeCount;
  VkPresentModeKHR* modes;
  };
typedef struct mvk_Swapchain mvk_Swapchain;
struct mvk_Swapchain {
  VkSwapchainKHR ct;
  VkSurfaceFormatKHR format;
  VkPresentModeKHR mode;
  VkExtent2D size;
  u32 priv_pad;
  u32 imgMin;
  u32 imgCount;
  VkImage* images;
  VkImageView* views;
  };
typedef struct mvk_Shader mvk_Shader;
struct mvk_Shader {
  VkPipelineShaderStageCreateInfo vert;
  VkPipelineShaderStageCreateInfo frag;
  };
typedef struct mvk_RenderTarget mvk_RenderTarget;
struct mvk_RenderTarget {
  VkRenderPass ct;
  u32 priv_pad;
  u32 fbCount;
  VkFramebuffer* fbuffers;
  };
typedef struct mvk_Pipeline mvk_Pipeline;
struct mvk_Pipeline {
  VkPipeline ct;
  mvk_Shader shader;
  VkViewport viewport;
  VkRect2D scissor;
  VkPipelineLayout shape;
  mvk_RenderTarget target;
  };
typedef struct mvk_CommandBatch mvk_CommandBatch;
struct mvk_CommandBatch {
  VkCommandPool pool;
  VkCommandBuffer buffer;
  };
typedef struct mvk_Sync mvk_Sync;
struct mvk_Sync {
  VkSemaphore imageAvailable;
  VkSemaphore renderFinished;
  VkFence framesPending;
  };
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview
///  Configuration defaults used by the raw `mvk` API.
// namespace mvk.cfg
const/*comptime*/ static u32 mvk_cfg_Version = VK_MAKE_API_VERSION(0, 1, 0, 0);
#define mvk_cfg_debug mstd_debug
// namespace _
// namespace mvk.cfg.validation
const/*comptime*/ static bool mvk_cfg_validation_Active = mvk_cfg_debug;
#if mvk_cfg_debug
#define mvk_cfg_validation_LayerCount 1
extern const/*comptime*/ cstr mvk_cfg_validation_Layers[mvk_cfg_validation_LayerCount]; const/*comptime*/ cstr mvk_cfg_validation_Layers[mvk_cfg_validation_LayerCount] = {
  [0]= "VK_LAYER_KHRONOS_validation",
};
#else
#define mvk_cfg_validation_LayerCount 0
extern const/*comptime*/ cstr mvk_cfg_validation_Layers[]; const/*comptime*/ cstr mvk_cfg_validation_Layers[] = {0};
#endif
const/*comptime*/ static VkDebugUtilsMessengerCreateFlagsEXT mvk_cfg_validation_DebugFlags = 0;
const/*comptime*/ static VkDebugUtilsMessageSeverityFlagsEXT mvk_cfg_validation_DebugSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
const/*comptime*/ static VkDebugUtilsMessageTypeFlagsEXT mvk_cfg_validation_DebugMsgType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
// namespace _
// namespace mvk.cfg.instance
#if defined(macosx)
#define mvk_cfg_instance_Flags VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR
#define mvk_cfg_instance_ExtensionsCount 2
const/*comptime*/ static cstr mvk_cfg_instance_Extensions[mvk_cfg_instance_ExtensionsCount] = {
  [0]= VK_EXT_DEBUG_UTILS_EXTENSION_NAME,
  [1]= VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME,
};
#else
#define mvk_cfg_instance_Flags 0
#define mvk_cfg_instance_ExtensionsCount 1
const/*comptime*/ static cstr mvk_cfg_instance_Extensions[mvk_cfg_instance_ExtensionsCount] = {
  [0]= VK_EXT_DEBUG_UTILS_EXTENSION_NAME,
};
#endif
// namespace _
// namespace mvk.cfg.device
const/*comptime*/ static bool mvk_cfg_device_ForceFirst = true;
// namespace _
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview
///  Callbacks used by default by the raw vk API
#include <stdio.h>
// namespace mvk.cb
VkBool32 mvk_cb_debug (VkDebugUtilsMessageSeverityFlagBitsEXT const severity, VkDebugUtilsMessageTypeFlagsEXT const types, const VkDebugUtilsMessengerCallbackDataEXT* const cbdata, void* const userdata);
VkBool32 mvk_cb_debug (VkDebugUtilsMessageSeverityFlagBitsEXT const severity, VkDebugUtilsMessageTypeFlagsEXT const types, const VkDebugUtilsMessengerCallbackDataEXT* const cbdata, void* const userdata) {
  (void)userdata;/*discard*/
  printf("[Vulkan Validation] (%d %d) : %s\n", types, severity, cbdata->pMessage);
  return false;
}
// namespace _
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview
///  Cable connector to all m*vk elements
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview
///  Raw api for managing the mvk_Instance object.
///  Validation is not exposed directly. It is managed from this file.
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @internal
/// @fileoverview Internal api for managing Vulkan Validation and Debugging
// namespace mvk.validate
void mvk_validate_chkSupport (bool const validate, u32 const listCount, cstr const list[]);
void mvk_validate_chkSupport (bool const validate, u32 const listCount, cstr const list[]) {
  /// @internal
  /// @descr Checks that all validation layers in the given {@arg list} are supported by the system
  if (!validate) {
    return ;
  }
  u32 count;
  vkEnumerateInstanceLayerProperties(&count, NULL);
  VkLayerProperties* layers = calloc(count, sizeof(VkLayerProperties));
  vkEnumerateInstanceLayerProperties(&count, layers);
  bool found = false;
  for(size_t layerId = 0; layerId < count; ++layerId) {
    VkLayerProperties const layer = layers[layerId];
    for(size_t vlayerID = 0; vlayerID < listCount; ++vlayerID) {
      if (cstr_eq(layer.layerName, list[vlayerID])) {
        found = true;
        goto end;

      }
    }
  }
  end:

  free(layers);
  if (!found) {
    err("One or more of the validation layers requested is not available in this system.");
  }
}
// namespace _
// namespace mvk.validate.debug
VkDebugUtilsMessengerCreateInfoEXT mvk_validate_debug_getCfg (VkDebugUtilsMessengerCreateFlagsEXT const flags, VkDebugUtilsMessageSeverityFlagsEXT const severity, VkDebugUtilsMessageTypeFlagsEXT const msgType, PFN_vkDebugUtilsMessengerCallbackEXT const callback, void* const userdata);
VkDebugUtilsMessengerCreateInfoEXT mvk_validate_debug_getCfg (VkDebugUtilsMessengerCreateFlagsEXT const flags, VkDebugUtilsMessageSeverityFlagsEXT const severity, VkDebugUtilsMessageTypeFlagsEXT const msgType, PFN_vkDebugUtilsMessengerCallbackEXT const callback, void* const userdata) {
  /// @internal
  /// @descr Configures the required information for Vulkan to send back debug information with the Messenger Extension.
  return (VkDebugUtilsMessengerCreateInfoEXT){
      .sType= VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
      .pNext= NULL,
      .flags= flags,
      .messageSeverity= severity,
      .messageType= msgType,
      .pfnUserCallback= callback,
      .pUserData= userdata,
      };
}
// Allow soft-type casting Vulkan function pointers for these functions
//   mvk_validate_debug_getFn_create
//   mvk_validate_debug_getFn_destroy
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcast-function-type-strict"

static PFN_vkCreateDebugUtilsMessengerEXT mvk_validate_debug_getFn_create (VkInstance const instance) {
  /// @internal
  /// @descr Returns the Vulkan Debug Messenger create function
  PFN_vkCreateDebugUtilsMessengerEXT const result = (PFN_vkCreateDebugUtilsMessengerEXT)vkGetInstanceProcAddr(instance, "vkCreateDebugUtilsMessengerEXT");
  if (result == NULL) {
    err("Failed to get the Vulkan Debug Messenger create function");
  }
  return result;
}
static PFN_vkDestroyDebugUtilsMessengerEXT mvk_validate_debugGetFn_destroy (VkInstance const instance) {
  /// Returns the Vulkan Debug Messenger destroy function
  PFN_vkDestroyDebugUtilsMessengerEXT const result = (PFN_vkDestroyDebugUtilsMessengerEXT)vkGetInstanceProcAddr(instance, "vkDestroyDebugUtilsMessengerEXT");
  if (result == NULL) {
    err("Failed to get the Vulkan Debug Messenger destroy function");
  }
  return result;
}
// Stop->  diagnostic ignored "-Wcast-function-type-strict"
#pragma clang diagnostic pop

VkDebugUtilsMessengerEXT* mvk_validate_debug_create (VkInstance const instance, VkDebugUtilsMessengerCreateInfoEXT* const cfg, VkAllocationCallbacks* const allocator, bool const active);
VkDebugUtilsMessengerEXT* mvk_validate_debug_create (VkInstance const instance, VkDebugUtilsMessengerCreateInfoEXT* const cfg, VkAllocationCallbacks* const allocator, bool const active) {
  /// @internal
  /// @descr Creates a Vulkan Debug Messenger object, using the default mvk configuration.
  /// @note This object is used by Vulkan to send back debug information.
  if (!active) {
    return NULL;
  }
  PFN_vkCreateDebugUtilsMessengerEXT const create = mvk_validate_debug_getFn_create(instance);
  VkDebugUtilsMessengerEXT* const result = (VkDebugUtilsMessengerEXT*)calloc(1, sizeof(VkDebugUtilsMessengerEXT));
  VkResult const code = create(instance, cfg, allocator, result);
  if (code != VK_SUCCESS) {
    err("Failed to create the Vulkan Debug Messenger");
  }
  return result;
}
void mvk_validate_debug_destroy (VkInstance const instance, mvk_Debug* const dbg, VkAllocationCallbacks* const allocator, bool const active);
void mvk_validate_debug_destroy (VkInstance const instance, mvk_Debug* const dbg, VkAllocationCallbacks* const allocator, bool const active) {
  /// @internal
  /// @descr Destroys a Vulkan Debug Messenger object created with {@link mvk_validate_debug_create}
  if (!active) {
    return ;
  }
  PFN_vkDestroyDebugUtilsMessengerEXT const destroy = mvk_validate_debugGetFn_destroy(instance);
  VkDebugUtilsMessengerEXT* const ct = dbg->ct;
  destroy(instance, *ct, allocator);
  free(ct);
  free(dbg);
}
// namespace _
// namespace mvk.appinfo
VkApplicationInfo mvk_appinfo_new (cstr const appName, u32 const appVers, cstr const engineName, u32 const engineVers, u32 const apiVersion);
VkApplicationInfo mvk_appinfo_new (cstr const appName, u32 const appVers, cstr const engineName, u32 const engineVers, u32 const apiVersion) {
  return (VkApplicationInfo){
      .sType= VK_STRUCTURE_TYPE_APPLICATION_INFO,
      .pNext= NULL,
      .pApplicationName= appName,
      .applicationVersion= appVers,
      .pEngineName= engineName,
      .engineVersion= engineVers,
      .apiVersion= apiVersion,
      };
}
// namespace _
// namespace mvk.instance
mvk_Instance mvk_instance_create (cstr const appName, u32 const appVers, cstr const engineName, u32 const engineVers, u32 const apiVersion, VkInstanceCreateFlags const flags, u32 const extCount, cstr const exts[], bool const validate, u32 const layerCount, cstr const layers[], VkDebugUtilsMessengerCreateFlagsEXT const dbgFlags, VkDebugUtilsMessageSeverityFlagsEXT const dbgSeverity, VkDebugUtilsMessageTypeFlagsEXT const dbgMsgType, PFN_vkDebugUtilsMessengerCallbackEXT const dbgCallback, void* const dbgUserdata, VkAllocationCallbacks* const allocator);
mvk_Instance mvk_instance_create (cstr const appName, u32 const appVers, cstr const engineName, u32 const engineVers, u32 const apiVersion, VkInstanceCreateFlags const flags, u32 const extCount, cstr const exts[], bool const validate, u32 const layerCount, cstr const layers[], VkDebugUtilsMessengerCreateFlagsEXT const dbgFlags, VkDebugUtilsMessageSeverityFlagsEXT const dbgSeverity, VkDebugUtilsMessageTypeFlagsEXT const dbgMsgType, PFN_vkDebugUtilsMessengerCallbackEXT const dbgCallback, void* const dbgUserdata, VkAllocationCallbacks* const allocator) {
  /// @descr Creates a Vulkan Instance, and all of its required properties, using the given flags+extensions+layers+validation
  mvk_Instance result = {0};
  result.allocator = allocator;
  result.info = mvk_appinfo_new(appName, appVers, engineName, engineVers, apiVersion);
  result.dbg.cfg = mvk_validate_debug_getCfg(dbgFlags, dbgSeverity, dbgMsgType, dbgCallback, dbgUserdata);
  mvk_validate_chkSupport(validate, layerCount, layers);
  VkResult const code = vkCreateInstance(&(VkInstanceCreateInfo){
    .sType= VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    .pNext= (void*)(&result.dbg.cfg),
    .flags= flags,
    .pApplicationInfo= &result.info,
    .enabledLayerCount= layerCount,
    .ppEnabledLayerNames= layers,
    .enabledExtensionCount= extCount,
    .ppEnabledExtensionNames= exts,
    }, result.allocator, &result.ct);
  if (code != VK_SUCCESS) {
    err("Failed to create the Vulkan Instance");
  }
  result.dbg.ct = mvk_validate_debug_create(result.ct, &result.dbg.cfg, result.allocator, validate);
  return result;
}
// namespace _
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview
///  Raw api for managing the mvk_Device object.
///  Device support and searching, and Queue management, are not exposed.
///  They are managed from this file.
// namespace mvk.queue.families
static void mvk_queue_families_destroy (mvk_QueueFamilies* const fams) {
  /// @descr Frees the Family Properties list, and sets every other value to empty
  free(fams->props);
  fams->propCount = 0;
  fams->graphics = Ou32_none();
  fams->present = Ou32_none();
}
static mvk_QueueFamilies mvk_queue_families_create (VkPhysicalDevice const device, VkSurfaceKHR const surface) {
  /// @descr Returns the Queue Families of the given device.
  mvk_QueueFamilies result =(mvk_QueueFamilies){
    .propCount= 0,
    .props= NULL,
    .graphics= Ou32_none(),
    .present= Ou32_none(),
    };
  vkGetPhysicalDeviceQueueFamilyProperties(device, &result.propCount, NULL);
  result.props = (VkQueueFamilyProperties*)calloc(result.propCount, sizeof(VkQueueFamilyProperties));
  vkGetPhysicalDeviceQueueFamilyProperties(device, &result.propCount, result.props);
  for(size_t propID = 0; propID < result.propCount; ++propID) {
    VkQueueFamilyProperties const prop = result.props[propID];
    if (prop.queueFlags & VK_QUEUE_GRAPHICS_BIT) {
      result.graphics = Ou32_some((u32)propID);
    }
    VkBool32 canPresent = 0;
    vkGetPhysicalDeviceSurfaceSupportKHR(device, (u32)propID, surface, &canPresent);
    if (canPresent) {
      result.present = Ou32_some((u32)propID);
    }
    if (result.graphics.hasValue && result.present.hasValue) {
      break;
    }
  }
  return result;
}
// namespace _
// namespace mvk.queue
static VkDeviceQueueCreateInfo mvk_queue_setupCfg (u32 const famID, f32 const priority) {
  /// @descr Returns a Queue configuration object
  assert(f32_zeroToOne(priority) && "Queue priority must be in the f32[0..1] range");
  f32 const prio[1] = {
    [0]= priority,
  };
  return (VkDeviceQueueCreateInfo){
      .sType= VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkDeviceQueueCreateFlags)0,
      .queueFamilyIndex= famID,
      .queueCount= 1,
      .pQueuePriorities= prio,
      };
}
static mvk_QueueEntry mvk_queue_graphicsCreate (VkDevice const device, const mvk_QueueFamilies* const fams) {
  /// @descr Returns the Graphics Queue data of the given Device
  mvk_QueueEntry result =(mvk_QueueEntry){
    .id= Ou32_none(),
    .ct= NULL,
    };
  result.id = fams->graphics;
  vkGetDeviceQueue(device, result.id.value, 0, &result.ct);
  return result;
}
static mvk_QueueEntry mvk_queue_presentCreate (VkDevice const device, const mvk_QueueFamilies* const fams) {
  /// @descr Returns the Graphics Queue data of the given Device
  mvk_QueueEntry result =(mvk_QueueEntry){
    .id= Ou32_none(),
    .ct= NULL,
    };
  result.id = fams->present;
  vkGetDeviceQueue(device, result.id.value, 0, &result.ct);
  return result;
}
mvk_Queue mvk_queue_create (VkPhysicalDevice const physicalDev, VkDevice const logicalDev, VkSurfaceKHR const surface);
mvk_Queue mvk_queue_create (VkPhysicalDevice const physicalDev, VkDevice const logicalDev, VkSurfaceKHR const surface) {
  /// @descr Returns the Queue data of the given Device
  mvk_QueueFamilies fam = mvk_queue_families_create(physicalDev, surface);
  mvk_Queue result =(mvk_Queue){
    .graphics= mvk_queue_graphicsCreate(logicalDev, &fam),
    .present= mvk_queue_presentCreate(logicalDev, &fam),
    };
  mvk_queue_families_destroy(&fam);
  return result;
}
// namespace _
// namespace mvk.device.swapchainSupport
mvk_device_SwapchainSupport mvk_device_swapchainSupport_create (VkPhysicalDevice const device, VkSurfaceKHR const surface);
mvk_device_SwapchainSupport mvk_device_swapchainSupport_create (VkPhysicalDevice const device, VkSurfaceKHR const surface) {
  /// @descr Returns the Swapchain support information for the given Device+Surface
  /// @note Allocates memory for its formats and modes lists
  mvk_device_SwapchainSupport result = {0};
  VkResult code;
  code = vkGetPhysicalDeviceSurfaceCapabilitiesKHR(device, surface, &result.caps);
  if (code != VK_SUCCESS) {
    err("Failed to retrieve the Swapchain Surface capabilities for the selected device.");
  }
  code = vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &result.formatCount, NULL);
  if (code != VK_SUCCESS) {
    err("Failed to retrieve the number of Swapchain Formats for the selected device.");
  }
  if (result.formatCount > 0) {
    result.formats = (VkSurfaceFormatKHR*)calloc(result.formatCount, sizeof(VkSurfaceFormatKHR));
    code = vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &result.formatCount, result.formats);
    if (code != VK_SUCCESS) {
      err("Failed to retrieve the list of Swapchain Formats for the selected device.");
    }
  }
  code = vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface, &result.modeCount, NULL);
  if (code != VK_SUCCESS) {
    err("Failed to retrieve the number of Swapchain Present Modes for the selected device.");
  }
  if (result.modeCount > 0) {
    result.modes = (VkPresentModeKHR*)calloc(result.modeCount, sizeof(VkPresentModeKHR));
    code = vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface, &result.modeCount, result.modes);
    if (code != VK_SUCCESS) {
      err("Failed to retrieve the list of Swapchain Present Modes for the selected device.");
    }
  }
  return result;
}
void mvk_device_swapchainSupport_destroy (mvk_device_SwapchainSupport* const support);
void mvk_device_swapchainSupport_destroy (mvk_device_SwapchainSupport* const support) {
  /// @descr
  ///  Releases all information contained in the given object.
  ///  Frees the allocated data, and sets every other value to empty.
  support->caps = (VkSurfaceCapabilitiesKHR){0};
  support->formatCount = 0;
  free(support->formats);
  support->modeCount = 0;
  free(support->modes);
}
bool mvk_device_swapchainSupport_available (mvk_device_SwapchainSupport* const support);
bool mvk_device_swapchainSupport_available (mvk_device_SwapchainSupport* const support) {
  /// @descr Returns true if the device has support for Swapchain creation
  return support->formatCount > 0 && support->modeCount > 0;
}
// namespace _
// namespace mvk.device.extensions
#define mvk_device_extensions_Max 1
const/*comptime*/ static cstr mvk_device_extensions_List[mvk_device_extensions_Max] = {
  [0]= VK_KHR_SWAPCHAIN_EXTENSION_NAME,
};
cstr* mvk_device_extensions_get (VkPhysicalDevice const device, u32* const count);
cstr* mvk_device_extensions_get (VkPhysicalDevice const device, u32* const count) {
  /// @descr Gets a list with the names of all extensions supported by the device
  u32 propCount;
  vkEnumerateDeviceExtensionProperties(device, NULL, &propCount, NULL);
  VkExtensionProperties* props = (VkExtensionProperties*)calloc(propCount, sizeof(VkExtensionProperties));
  vkEnumerateDeviceExtensionProperties(device, NULL, &propCount, props);
  cstr* result = (cstr*)calloc(propCount, sizeof(cstr));
  for(size_t propID = 0; propID < propCount; ++propID) {
    VkExtensionProperties const prop = props[propID];
    result[propID] = cstr_dup(prop.extensionName);
  }
  *count = propCount;
  free(props);
  return result;
}
bool mvk_device_extensions_areSupported (VkPhysicalDevice const device, u32 const count, const cstr* const exts);
bool mvk_device_extensions_areSupported (VkPhysicalDevice const device, u32 const count, const cstr* const exts) {
  /// @descr Returns true if the {@arg device} supports all extensions contained in the {@arg exts} list
  u32 extCount;
  cstr* extNames = mvk_device_extensions_get(device, &extCount);
  for(size_t id = 0; id < count; ++id) {
    cstr const req = exts[id];
    if (!cstr_arr_contains(extNames, extCount, req)) {
      free(extNames);
      return false;
    }
  }
  free(extNames);
  return true;
}
// namespace _
// namespace mvk.device.physical
bool mvk_device_physical_isSuitable (VkPhysicalDevice const device, mvk_QueueFamilies* const fams, mvk_device_SwapchainSupport* const support);
bool mvk_device_physical_isSuitable (VkPhysicalDevice const device, mvk_QueueFamilies* const fams, mvk_device_SwapchainSupport* const support) {
  /// Returns true if the given device is considered suitable to run with the default mvk configuration
  VkPhysicalDeviceProperties props = {0};
  vkGetPhysicalDeviceProperties(device, &props);
  return props.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU && fams->graphics.hasValue && fams->present.hasValue && mvk_device_extensions_areSupported(device, mvk_device_extensions_Max, mvk_device_extensions_List) && mvk_device_swapchainSupport_available(support);
}
VkPhysicalDevice mvk_device_physical_create (VkInstance const instance, VkSurfaceKHR const surface, bool const forceFirst);
VkPhysicalDevice mvk_device_physical_create (VkInstance const instance, VkSurfaceKHR const surface, bool const forceFirst) {
  /// @descr Returns a Physical Device suitable to run with the default mvk configuration
  u32 count;
  VkResult code = vkEnumeratePhysicalDevices(instance, &count, NULL);
  if (code != VK_SUCCESS) {
    printf("[Vulkan Error] ( %i )\n", code);
    err("Failed when searching for GPUs with Vulkan support.");
  }
  if (!count) {
    err("Failed to find any GPUs with Vulkan support.");
  }
  VkPhysicalDevice* devices = (VkPhysicalDevice*)calloc(count, sizeof(VkPhysicalDevice));
  code = vkEnumeratePhysicalDevices(instance, &count, devices);
  if (code != VK_SUCCESS) {
    printf("[Vulkan Error] ( %i )\n", code);
    err("Failed to retrieve the list of GPUs.");
  }
  VkPhysicalDevice result = NULL;
  for(size_t id = 0; id < count; ++id) {
    if (forceFirst) {
      result = devices[0];
      break;
    }
    mvk_QueueFamilies fam = mvk_queue_families_create(devices[id], surface);
    mvk_device_SwapchainSupport support = mvk_device_swapchainSupport_create(devices[id], surface);
    if (mvk_device_physical_isSuitable(devices[id], &fam, &support)) {
      result = devices[id];
      mvk_device_swapchainSupport_destroy(&support);
      mvk_queue_families_destroy(&fam);
      break;
    }
    mvk_device_swapchainSupport_destroy(&support);
    mvk_queue_families_destroy(&fam);
  }
  free(devices);
  if (result == NULL) {
    err("Failed to find any suitable GPU.");
  }
  return result;
}
// namespace _
// namespace mvk.device.logical
static VkDeviceCreateInfo mvk_device_logical_setupCfg (u32 const queueCfgCount, const VkDeviceQueueCreateInfo* const queueCfgs, u32 const extCount, const cstr* const extNames, const VkPhysicalDeviceFeatures* const features) {
  return (VkDeviceCreateInfo){
      .sType= VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkDeviceCreateFlags)0,
      .queueCreateInfoCount= queueCfgCount,
      .pQueueCreateInfos= queueCfgs,
      .enabledLayerCount= 0,
      .ppEnabledLayerNames= NULL,
      .enabledExtensionCount= extCount,
      .ppEnabledExtensionNames= extNames,
      .pEnabledFeatures= features,
      };
}
VkDevice mvk_device_logical_create (VkPhysicalDevice const device, VkSurfaceKHR const surface, VkAllocationCallbacks* const allocator);
VkDevice mvk_device_logical_create (VkPhysicalDevice const device, VkSurfaceKHR const surface, VkAllocationCallbacks* const allocator) {
  /// @descr Returns a Logical Device suitable to run with the default mvk configuration
  mvk_QueueFamilies fam = mvk_queue_families_create(device, surface);
  u32 queueCfgCount;
  VkDeviceQueueCreateInfo* queueCfg;
  if (fam.graphics.value == fam.present.value) {
    queueCfgCount = 1;
    queueCfg = (VkDeviceQueueCreateInfo*)calloc(queueCfgCount, sizeof(VkDeviceQueueCreateInfo));
    queueCfg[0] = mvk_queue_setupCfg(fam.graphics.value, 1.0);
  } else {
    queueCfgCount = 2;
    queueCfg = (VkDeviceQueueCreateInfo*)calloc(queueCfgCount, sizeof(VkDeviceQueueCreateInfo));
    queueCfg[0] = mvk_queue_setupCfg(fam.graphics.value, 1.0);
    queueCfg[1] = mvk_queue_setupCfg(fam.present.value, 1.0);
  }
  VkPhysicalDeviceFeatures const features = {0};
  VkDeviceCreateInfo const cfg = mvk_device_logical_setupCfg(queueCfgCount, queueCfg, mvk_device_extensions_Max, mvk_device_extensions_List, &features);
  VkDevice result = NULL;
  VkResult const code = vkCreateDevice(device, &cfg, allocator, &result);
  if (code != VK_SUCCESS) {
    err("Failed to create the Vulkan Logical device");
  }
  free(queueCfg);
  mvk_queue_families_destroy(&fam);
  return result;
}
// namespace _
// namespace mvk.device
mvk_Device mvk_device_create (mvk_Instance const instance, mvk_Surface const surface, bool const forceFirst);
mvk_Device mvk_device_create (mvk_Instance const instance, mvk_Surface const surface, bool const forceFirst) {
  /// @descr Returns a complete Device object based on the given configuration options
  mvk_Device result;
  result.physical = mvk_device_physical_create(instance.ct, surface, forceFirst);
  result.logical = mvk_device_logical_create(result.physical, surface, instance.allocator);
  result.queue = mvk_queue_create(result.physical, result.logical, surface);
  return result;
}
// namespace _
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview Raw api for managing the mvk_Swapchain object
// namespace mvk.swapchain
VkSurfaceFormatKHR mvk_swapchain_formatSelect (mvk_device_SwapchainSupport* const support);
VkSurfaceFormatKHR mvk_swapchain_formatSelect (mvk_device_SwapchainSupport* const support) {
  /// @descr Returns the preferred format for the Swapchain Surface
  u32 const count = support->formatCount;
  for(size_t id = 0; id < count; ++id) {
    VkSurfaceFormatKHR const format = support->formats[id];
    if (format.format == VK_FORMAT_B8G8R8A8_SRGB && format.colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
      return format;
    }
  }
  return support->formats[0];
}
VkPresentModeKHR mvk_swapchain_modeSelect (mvk_device_SwapchainSupport* const support);
VkPresentModeKHR mvk_swapchain_modeSelect (mvk_device_SwapchainSupport* const support) {
  /// @descr Returns the preferred present mode for the Swapchain Surface
  /// @note Searches for Mailbox support first, and returns FIFO if not found
  u32 const count = support->modeCount;
  for(size_t id = 0; id < count; ++id) {
    VkPresentModeKHR const mode = support->modes[id];
    if (mode == VK_PRESENT_MODE_MAILBOX_KHR) {
      return VK_PRESENT_MODE_MAILBOX_KHR;
    }
  }
  return VK_PRESENT_MODE_FIFO_KHR;
}
VkExtent2D mvk_swapchain_sizeSelect (mvk_device_SwapchainSupport* const support, i32 const W, i32 const H);
VkExtent2D mvk_swapchain_sizeSelect (mvk_device_SwapchainSupport* const support, i32 const W, i32 const H) {
  /// @descr Returns the size of the Swapchain Surface
  /// @note Measurements in pixels/units are compared, in case they don't match
  if (support->caps.currentExtent.width != u32_high) {
    return support->caps.currentExtent;
  }
  return (VkExtent2D){
      .width= u32_clamp((u32)W, support->caps.minImageExtent.width, support->caps.maxImageExtent.width),
      .height= u32_clamp((u32)H, support->caps.minImageExtent.height, support->caps.maxImageExtent.height),
      };
}
u32 mvk_swapchain_imgMinSelect (mvk_device_SwapchainSupport* const support);
u32 mvk_swapchain_imgMinSelect (mvk_device_SwapchainSupport* const support) {
  /// @descr Returns the minimum number of images that the Swapchain will contain
  u32 result = support->caps.minImageCount + 1;
  if (support->caps.maxImageCount > 0) {
    result = u32_max(result, support->caps.maxImageCount);
  }
  return result;
}
VkSwapchainCreateInfoKHR mvk_swapchain_setupCfg (VkPhysicalDevice const device, VkSurfaceKHR const surface, u32 const imgMin, VkSurfaceFormatKHR const format, VkExtent2D const size, VkSurfaceCapabilitiesKHR* const caps, VkPresentModeKHR const mode);
VkSwapchainCreateInfoKHR mvk_swapchain_setupCfg (VkPhysicalDevice const device, VkSurfaceKHR const surface, u32 const imgMin, VkSurfaceFormatKHR const format, VkExtent2D const size, VkSurfaceCapabilitiesKHR* const caps, VkPresentModeKHR const mode) {
  /// @descr Returns a Swapchain configuration object for the given properties
  /// @note Allocates some of the required data
  /// @todo Pass an allocator
  mvk_QueueFamilies fam = mvk_queue_families_create(device, surface);
  VkSharingMode sharingMode;
  u32 famCount;
  u32* famIDs;
  if (Ou32_eq(fam.graphics, fam.present)) {
    sharingMode = VK_SHARING_MODE_EXCLUSIVE;
    famCount = 0;
    famIDs = NULL;
  } else if (fam.graphics.hasValue && fam.present.hasValue) {
    sharingMode = VK_SHARING_MODE_CONCURRENT;
    famCount = 2;
    famIDs = (u32*)calloc(famCount, sizeof(u32));
    famIDs[0] = fam.graphics.value;
    famIDs[1] = fam.present.value;
  } else {
    err("Something went wrong during Swapchain config setup when defining the Sharing mode.");
  }
  VkSwapchainCreateInfoKHR result =(VkSwapchainCreateInfoKHR){
    .sType= VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
    .pNext= NULL,
    .flags= (VkSwapchainCreateFlagsKHR)0,
    .surface= surface,
    .minImageCount= imgMin,
    .imageFormat= format.format,
    .imageColorSpace= format.colorSpace,
    .imageExtent= size,
    .imageArrayLayers= 1,
    .imageUsage= VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,
    .imageSharingMode= sharingMode,
    .queueFamilyIndexCount= famCount,
    .pQueueFamilyIndices= famIDs,
    .preTransform= caps->currentTransform,
    .compositeAlpha= VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,
    .presentMode= mode,
    .clipped= VK_TRUE,
    .oldSwapchain= NULL,
    };
  if (famIDs != NULL) {
    free(famIDs);
  }
  mvk_queue_families_destroy(&fam);
  return result;
}
mvk_Swapchain mvk_swapchain_create (mvk_Device* const device, VkSurfaceKHR const surface, i32 const W, i32 const H, VkAllocationCallbacks* const allocator);
mvk_Swapchain mvk_swapchain_create (mvk_Device* const device, VkSurfaceKHR const surface, i32 const W, i32 const H, VkAllocationCallbacks* const allocator) {
  /// @descr Creates a Swapchain object for the given device and surface
  mvk_device_SwapchainSupport support = mvk_device_swapchainSupport_create(device->physical, surface);
  mvk_Swapchain result =(mvk_Swapchain){
    .ct= NULL,
    .format= mvk_swapchain_formatSelect(&support),
    .mode= mvk_swapchain_modeSelect(&support),
    .size= mvk_swapchain_sizeSelect(&support, W, H),
    .imgMin= mvk_swapchain_imgMinSelect(&support),
    };
  VkSwapchainCreateInfoKHR const cfg = mvk_swapchain_setupCfg(device->physical, surface, result.imgMin, result.format, result.size, &support.caps, result.mode);
  VkResult code = vkCreateSwapchainKHR(device->logical, &cfg, allocator, &result.ct);
  if (code != VK_SUCCESS) {
    err("Failed to create the Swapchain");
  }
  code = vkGetSwapchainImagesKHR(device->logical, result.ct, &result.imgCount, NULL);
  if (code != VK_SUCCESS) {
    err("Failed to retrieve the number of Images used by the Swapchain.");
  }
  result.images = (VkImage*)calloc(result.imgCount, sizeof(VkImage));
  code = vkGetSwapchainImagesKHR(device->logical, result.ct, &result.imgCount, result.images);
  if (code != VK_SUCCESS) {
    err("Failed to retrieve the list of Images used by the Swapchain.");
  }
  result.views = (VkImageView*)calloc(result.imgCount, sizeof(VkImageView));
  for(size_t id = 0; id < result.imgCount; ++id) {
    code = vkCreateImageView(device->logical, &(VkImageViewCreateInfo){
      .sType= VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkImageViewCreateFlags)0,
      .image= result.images[id],
      .viewType= VK_IMAGE_VIEW_TYPE_2D,
      .format= result.format.format,
      .components= (VkComponentMapping){
        .r= 0,
        .g= 0,
        .b= 0,
        .a= 0,
        },
      .subresourceRange= (VkImageSubresourceRange){
        .aspectMask= VK_IMAGE_ASPECT_COLOR_BIT,
        .baseMipLevel= 0,
        .levelCount= 1,
        .baseArrayLayer= 0,
        .layerCount= 1,
        },
      }, allocator, &result.views[id]);
    if (code != VK_SUCCESS) {
      err("Failed to retrieve one of the ImageViews used by the Swapchain.");
    }
  }
  mvk_device_swapchainSupport_destroy(&support);
  return result;
}
void mvk_swapchain_destroy (VkDevice const device, mvk_Swapchain* const swapchain, VkAllocationCallbacks* const allocator);
void mvk_swapchain_destroy (VkDevice const device, mvk_Swapchain* const swapchain, VkAllocationCallbacks* const allocator) {
  /// @descr Releases the Swapchain object and all its ImageViews
  u32 const count = swapchain->imgCount;
  for(size_t id = 0; id < count; ++id) {
    vkDestroyImageView(device, swapchain->views[id], allocator);
  }
  vkDestroySwapchainKHR(device, swapchain->ct, allocator);
}
// namespace _
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview Raw api for managing mvk_Pipeline objects
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview Raw api for creating Shader Modules
// namespace mvk.shader
VkShaderModule mvk_shader_moduleFromSpv (VkDevice const device, Sz const size, const u32* const spv, VkAllocationCallbacks* const allocator);
VkShaderModule mvk_shader_moduleFromSpv (VkDevice const device, Sz const size, const u32* const spv, VkAllocationCallbacks* const allocator) {
  /// Returns a Shader Module from the given spirv code
  VkShaderModule result = NULL;
  VkResult const code = vkCreateShaderModule(device, &(VkShaderModuleCreateInfo){
    .sType= VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
    .pNext= NULL,
    .flags= (VkShaderModuleCreateFlags)0,
    .codeSize= size,
    .pCode= spv,
    }, allocator, &result);
  if (code != VK_SUCCESS) {
    err("Failed to create a Shader Module from spv.");
  }
  return result;
}
// namespace _
/// __________________________________________________________
static const u32 tri_vert[] = {0x07230203,0x00010000,0x000d000b,0x00000036,0x00000000,0x00020011,0x00000001,0x0006000b,0x00000001,0x4c534c47,0x6474732e,0x3035342e,0x00000000,0x0003000e,0x00000000,0x00000001,0x0008000f,0x00000000,0x00000004,0x6e69616d,0x00000000,0x00000022,0x00000026,0x00000031,0x00030003,0x00000002,0x000001c2,0x000a0004,0x475f4c47,0x4c474f4f,0x70635f45,0x74735f70,0x5f656c79,0x656e696c,0x7269645f,0x69746365,0x00006576,0x00080004,0x475f4c47,0x4c474f4f,0x6e695f45,0x64756c63,0x69645f65,0x74636572,0x00657669,0x00040005,0x00000004,0x6e69616d,0x00000000,0x00040005,0x0000000c,0x736f5061,0x00000000,0x00040005,0x00000017,0x6c6f4361,0x0000726f,0x00060005,0x00000020,0x505f6c67,0x65567265,0x78657472,0x00000000,0x00060006,0x00000020,0x00000000,0x505f6c67,0x7469736f,0x006e6f69,0x00070006,0x00000020,0x00000001,0x505f6c67,0x746e696f,0x657a6953,0x00000000,0x00070006,0x00000020,0x00000002,0x435f6c67,0x4470696c,0x61747369,0x0065636e,0x00070006,0x00000020,0x00000003,0x435f6c67,0x446c6c75,0x61747369,0x0065636e,0x00030005,0x00000022,0x00000000,0x00060005,0x00000026,0x565f6c67,0x65747265,0x646e4978,0x00007865,0x00040005,0x00000031,0x6c6f4376,0x0000726f,0x00050048,0x00000020,0x00000000,0x0000000b,0x00000000,0x00050048,0x00000020,0x00000001,0x0000000b,0x00000001,0x00050048,0x00000020,0x00000002,0x0000000b,0x00000003,0x00050048,0x00000020,0x00000003,0x0000000b,0x00000004,0x00030047,0x00000020,0x00000002,0x00040047,0x00000026,0x0000000b,0x0000002a,0x00040047,0x00000031,0x0000001e,0x00000000,0x00020013,0x00000002,0x00030021,0x00000003,0x00000002,0x00030016,0x00000006,0x00000020,0x00040017,0x00000007,0x00000006,0x00000002,0x00040015,0x00000008,0x00000020,0x00000000,0x0004002b,0x00000008,0x00000009,0x00000003,0x0004001c,0x0000000a,0x00000007,0x00000009,0x00040020,0x0000000b,0x00000006,0x0000000a,0x0004003b,0x0000000b,0x0000000c,0x00000006,0x0004002b,0x00000006,0x0000000d,0x00000000,0x0004002b,0x00000006,0x0000000e,0xbf000000,0x0005002c,0x00000007,0x0000000f,0x0000000d,0x0000000e,0x0004002b,0x00000006,0x00000010,0x3f000000,0x0005002c,0x00000007,0x00000011,0x00000010,0x00000010,0x0005002c,0x00000007,0x00000012,0x0000000e,0x00000010,0x0006002c,0x0000000a,0x00000013,0x0000000f,0x00000011,0x00000012,0x00040017,0x00000014,0x00000006,0x00000003,0x0004001c,0x00000015,0x00000014,0x00000009,0x00040020,0x00000016,0x00000006,0x00000015,0x0004003b,0x00000016,0x00000017,0x00000006,0x0004002b,0x00000006,0x00000018,0x3f800000,0x0006002c,0x00000014,0x00000019,0x00000018,0x0000000d,0x0000000d,0x0006002c,0x00000014,0x0000001a,0x0000000d,0x00000018,0x0000000d,0x0006002c,0x00000014,0x0000001b,0x0000000d,0x0000000d,0x00000018,0x0006002c,0x00000015,0x0000001c,0x00000019,0x0000001a,0x0000001b,0x00040017,0x0000001d,0x00000006,0x00000004,0x0004002b,0x00000008,0x0000001e,0x00000001,0x0004001c,0x0000001f,0x00000006,0x0000001e,0x0006001e,0x00000020,0x0000001d,0x00000006,0x0000001f,0x0000001f,0x00040020,0x00000021,0x00000003,0x00000020,0x0004003b,0x00000021,0x00000022,0x00000003,0x00040015,0x00000023,0x00000020,0x00000001,0x0004002b,0x00000023,0x00000024,0x00000000,0x00040020,0x00000025,0x00000001,0x00000023,0x0004003b,0x00000025,0x00000026,0x00000001,0x00040020,0x00000028,0x00000006,0x00000007,0x00040020,0x0000002e,0x00000003,0x0000001d,0x00040020,0x00000030,0x00000003,0x00000014,0x0004003b,0x00000030,0x00000031,0x00000003,0x00040020,0x00000033,0x00000006,0x00000014,0x00050036,0x00000002,0x00000004,0x00000000,0x00000003,0x000200f8,0x00000005,0x0003003e,0x0000000c,0x00000013,0x0003003e,0x00000017,0x0000001c,0x0004003d,0x00000023,0x00000027,0x00000026,0x00050041,0x00000028,0x00000029,0x0000000c,0x00000027,0x0004003d,0x00000007,0x0000002a,0x00000029,0x00050051,0x00000006,0x0000002b,0x0000002a,0x00000000,0x00050051,0x00000006,0x0000002c,0x0000002a,0x00000001,0x00070050,0x0000001d,0x0000002d,0x0000002b,0x0000002c,0x0000000d,0x00000018,0x00050041,0x0000002e,0x0000002f,0x00000022,0x00000024,0x0003003e,0x0000002f,0x0000002d,0x0004003d,0x00000023,0x00000032,0x00000026,0x00050041,0x00000033,0x00000034,0x00000017,0x00000032,0x0004003d,0x00000014,0x00000035,0x00000034,0x0003003e,0x00000031,0x00000035,0x000100fd,0x00010038};
static const u32 tri_frag[] = {0x07230203,0x00010000,0x000d000b,0x00000013,0x00000000,0x00020011,0x00000001,0x0006000b,0x00000001,0x4c534c47,0x6474732e,0x3035342e,0x00000000,0x0003000e,0x00000000,0x00000001,0x0007000f,0x00000004,0x00000004,0x6e69616d,0x00000000,0x00000009,0x0000000c,0x00030010,0x00000004,0x00000007,0x00030003,0x00000002,0x000001c2,0x000a0004,0x475f4c47,0x4c474f4f,0x70635f45,0x74735f70,0x5f656c79,0x656e696c,0x7269645f,0x69746365,0x00006576,0x00080004,0x475f4c47,0x4c474f4f,0x6e695f45,0x64756c63,0x69645f65,0x74636572,0x00657669,0x00040005,0x00000004,0x6e69616d,0x00000000,0x00040005,0x00000009,0x6c6f4366,0x0000726f,0x00040005,0x0000000c,0x6c6f4376,0x0000726f,0x00040047,0x00000009,0x0000001e,0x00000000,0x00040047,0x0000000c,0x0000001e,0x00000000,0x00020013,0x00000002,0x00030021,0x00000003,0x00000002,0x00030016,0x00000006,0x00000020,0x00040017,0x00000007,0x00000006,0x00000004,0x00040020,0x00000008,0x00000003,0x00000007,0x0004003b,0x00000008,0x00000009,0x00000003,0x00040017,0x0000000a,0x00000006,0x00000003,0x00040020,0x0000000b,0x00000001,0x0000000a,0x0004003b,0x0000000b,0x0000000c,0x00000001,0x0004002b,0x00000006,0x0000000e,0x3f800000,0x00050036,0x00000002,0x00000004,0x00000000,0x00000003,0x000200f8,0x00000005,0x0004003d,0x0000000a,0x0000000d,0x0000000c,0x00050051,0x00000006,0x0000000f,0x0000000d,0x00000000,0x00050051,0x00000006,0x00000010,0x0000000d,0x00000001,0x00050051,0x00000006,0x00000011,0x0000000d,0x00000002,0x00070050,0x00000007,0x00000012,0x0000000f,0x00000010,0x00000011,0x0000000e,0x0003003e,0x00000009,0x00000012,0x000100fd,0x00010038};
/// __________________________________________________________
// namespace mvk.pipeline
mvk_Pipeline mvk_pipeline_create (VkDevice const device, mvk_Swapchain* const swapchain, VkAllocationCallbacks* const allocator);
mvk_Pipeline mvk_pipeline_create (VkDevice const device, mvk_Swapchain* const swapchain, VkAllocationCallbacks* const allocator) {
  /// Creates a Generic Pipeline object, using the mvk defaults
  mvk_Pipeline result = {0};
  VkResult code;
  result.shader.vert = (VkPipelineShaderStageCreateInfo){
    .sType= VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
    .pNext= NULL,
    .flags= (VkPipelineShaderStageCreateFlags)0,
    .stage= VK_SHADER_STAGE_VERTEX_BIT,
    .module= mvk_shader_moduleFromSpv(device, sizeof(tri_vert), tri_vert, allocator),
    .pName= "main",
    .pSpecializationInfo= &(VkSpecializationInfo){
      .mapEntryCount= 0,
      .pMapEntries= NULL,
      .dataSize= 0,
      .pData= NULL,
      },
    };
  result.shader.frag = (VkPipelineShaderStageCreateInfo){
    .sType= VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
    .pNext= NULL,
    .flags= (VkPipelineShaderStageCreateFlags)0,
    .stage= VK_SHADER_STAGE_FRAGMENT_BIT,
    .module= mvk_shader_moduleFromSpv(device, sizeof(tri_frag), tri_frag, allocator),
    .pName= "main",
    .pSpecializationInfo= &(VkSpecializationInfo){
      .mapEntryCount= 0,
      .pMapEntries= NULL,
      .dataSize= 0,
      .pData= NULL,
      },
    };
  VkPipelineShaderStageCreateInfo const shaders[] = {
    [0]= result.shader.vert,
    [1]= result.shader.frag,
  };
  u32 const dynCount = 2;
  VkDynamicState* dynamics = (VkDynamicState*)calloc(dynCount, sizeof(VkDynamicState));
  dynamics[0] = VK_DYNAMIC_STATE_VIEWPORT;
  result.viewport = (VkViewport){
    .x= 0.0,
    .y= 0.0,
    .width= (f32)(swapchain->size.width),
    .height= (f32)(swapchain->size.width),
    .minDepth= 0.0,
    .maxDepth= 1.0,
    };
  dynamics[1] = VK_DYNAMIC_STATE_SCISSOR;
  result.scissor = (VkRect2D){
    .offset= (VkOffset2D){
      .x= 0,
      .y= 0,
      },
    .extent= swapchain->size,
    };
  code = vkCreatePipelineLayout(device, &(VkPipelineLayoutCreateInfo){
    .sType= VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
    .pNext= NULL,
    .flags= (VkPipelineLayoutCreateFlags)0,
    .setLayoutCount= 0,
    .pSetLayouts= NULL,
    .pushConstantRangeCount= 0,
    .pPushConstantRanges= NULL,
    }, allocator, &result.shape);
  if (code != VK_SUCCESS) {
    err("Failed to create the Pipeline Shape.");
  }
  code = vkCreateRenderPass(device, &(VkRenderPassCreateInfo){
    .sType= VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO,
    .pNext= NULL,
    .flags= (VkRenderPassCreateFlags)0,
    .attachmentCount= 1,
    .pAttachments= &(VkAttachmentDescription){
      .flags= (VkAttachmentDescriptionFlags)0,
      .format= swapchain->format.format,
      .samples= VK_SAMPLE_COUNT_1_BIT,
      .loadOp= VK_ATTACHMENT_LOAD_OP_CLEAR,
      .storeOp= VK_ATTACHMENT_STORE_OP_STORE,
      .stencilLoadOp= VK_ATTACHMENT_LOAD_OP_DONT_CARE,
      .stencilStoreOp= VK_ATTACHMENT_STORE_OP_DONT_CARE,
      .initialLayout= VK_IMAGE_LAYOUT_UNDEFINED,
      .finalLayout= VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,
      },
    .subpassCount= 1,
    .pSubpasses= &(VkSubpassDescription){
      .flags= (VkSubpassDescriptionFlags)0,
      .pipelineBindPoint= VK_PIPELINE_BIND_POINT_GRAPHICS,
      .inputAttachmentCount= 0,
      .pInputAttachments= NULL,
      .colorAttachmentCount= 1,
      .pColorAttachments= &(VkAttachmentReference){
        .attachment= 0,
        .layout= VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        },
      .pResolveAttachments= NULL,
      .pDepthStencilAttachment= NULL,
      .preserveAttachmentCount= 0,
      .pPreserveAttachments= NULL,
      },
    .dependencyCount= 1,
    .pDependencies= &(VkSubpassDependency){
      .srcSubpass= VK_SUBPASS_EXTERNAL,
      .dstSubpass= 0,
      .srcStageMask= VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
      .dstStageMask= VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
      .srcAccessMask= (VkAccessFlags)0,
      .dstAccessMask= VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT,
      .dependencyFlags= (VkDependencyFlags)0,
      },
    }, allocator, &result.target.ct);
  if (code != VK_SUCCESS) {
    err("Failed to create the Render Target");
  }
  result.target.fbCount = swapchain->imgCount;
  result.target.fbuffers = (VkFramebuffer*)calloc(result.target.fbCount, sizeof(VkFramebuffer));
  for(size_t id = 0; id < result.target.fbCount; ++id) {
    code = vkCreateFramebuffer(device, &(VkFramebufferCreateInfo){
      .sType= VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkFramebufferCreateFlags)0,
      .renderPass= result.target.ct,
      .attachmentCount= 1,
      .pAttachments= &swapchain->views[id],
      .width= swapchain->size.width,
      .height= swapchain->size.height,
      .layers= 1,
      }, allocator, &result.target.fbuffers[id]);
    if (code != VK_SUCCESS) {
      err("Failed to create one of the Render Target Framebuffers");
    }
  }
  code = vkCreateGraphicsPipelines(device, NULL, 1, &(VkGraphicsPipelineCreateInfo){
    .sType= VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
    .pNext= NULL,
    .flags= (VkPipelineCreateFlags)0,
    .stageCount= 2,
    .pStages= shaders,
    .pVertexInputState= &(VkPipelineVertexInputStateCreateInfo){
      .sType= VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkPipelineVertexInputStateCreateFlags)0,
      .vertexBindingDescriptionCount= 0,
      .pVertexBindingDescriptions= NULL,
      .vertexAttributeDescriptionCount= 0,
      .pVertexAttributeDescriptions= NULL,
      },
    .pInputAssemblyState= &(VkPipelineInputAssemblyStateCreateInfo){
      .sType= VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkPipelineInputAssemblyStateCreateFlags)0,
      .topology= VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
      .primitiveRestartEnable= VK_FALSE,
      },
    .pTessellationState= NULL,
    .pViewportState= &(VkPipelineViewportStateCreateInfo){
      .sType= VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkPipelineViewportStateCreateFlags)0,
      .viewportCount= 1,
      .pViewports= &result.viewport,
      .scissorCount= 1,
      .pScissors= &result.scissor,
      },
    .pRasterizationState= &(VkPipelineRasterizationStateCreateInfo){
      .sType= VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkPipelineRasterizationStateCreateFlags)0,
      .depthClampEnable= VK_FALSE,
      .rasterizerDiscardEnable= VK_FALSE,
      .polygonMode= VK_POLYGON_MODE_FILL,
      .cullMode= VK_CULL_MODE_NONE,
      .frontFace= VK_FRONT_FACE_COUNTER_CLOCKWISE,
      .depthBiasEnable= VK_FALSE,
      .depthBiasConstantFactor= 0.0,
      .depthBiasClamp= 0.0,
      .depthBiasSlopeFactor= 0.0,
      .lineWidth= 1.0,
      },
    .pMultisampleState= &(VkPipelineMultisampleStateCreateInfo){
      .sType= VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkPipelineMultisampleStateCreateFlags)0,
      .rasterizationSamples= VK_SAMPLE_COUNT_1_BIT,
      .sampleShadingEnable= VK_FALSE,
      .minSampleShading= 1.0,
      .pSampleMask= NULL,
      .alphaToCoverageEnable= VK_FALSE,
      .alphaToOneEnable= VK_FALSE,
      },
    .pDepthStencilState= NULL,
    .pColorBlendState= &(VkPipelineColorBlendStateCreateInfo){
      .sType= VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkPipelineColorBlendStateCreateFlags)0,
      .logicOpEnable= VK_FALSE,
      .logicOp= VK_LOGIC_OP_COPY,
      .attachmentCount= 1,
      .pAttachments= &(VkPipelineColorBlendAttachmentState){
        .blendEnable= VK_TRUE,
        .srcColorBlendFactor= VK_BLEND_FACTOR_SRC_ALPHA,
        .dstColorBlendFactor= VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
        .colorBlendOp= VK_BLEND_OP_ADD,
        .srcAlphaBlendFactor= VK_BLEND_FACTOR_ONE,
        .dstAlphaBlendFactor= VK_BLEND_FACTOR_ZERO,
        .alphaBlendOp= VK_BLEND_OP_ADD,
        .colorWriteMask= VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT | VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT,
        },
      .blendConstants=  {
        [0]= 0.0,
      },
      },
    .pDynamicState= &(VkPipelineDynamicStateCreateInfo){
      .sType= VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO,
      .pNext= NULL,
      .flags= (VkPipelineDynamicStateCreateFlags)0,
      .dynamicStateCount= dynCount,
      .pDynamicStates= dynamics,
      },
    .layout= result.shape,
    .renderPass= result.target.ct,
    .subpass= 0,
    .basePipelineHandle= NULL,
    .basePipelineIndex= -1,
    }, allocator, &result.ct);
  if (code != VK_SUCCESS) {
    err("Failed to create the tutorial Pipeline");
  }
  return result;
}
void mvk_pipeline_destroy (VkDevice const device, mvk_Pipeline* const pipeline, VkAllocationCallbacks* const allocator);
void mvk_pipeline_destroy (VkDevice const device, mvk_Pipeline* const pipeline, VkAllocationCallbacks* const allocator) {
  /// Releases the Pipeline object and all its contents
  u32 const count = pipeline->target.fbCount;
  for(size_t id = 0; id < count; ++id) {
    vkDestroyFramebuffer(device, pipeline->target.fbuffers[id], allocator);
  }
  free(pipeline->target.fbuffers);
  vkDestroyPipeline(device, pipeline->ct, allocator);
  vkDestroyPipelineLayout(device, pipeline->shape, allocator);
  vkDestroyRenderPass(device, pipeline->target.ct, allocator);
  vkDestroyShaderModule(device, pipeline->shader.vert.module, allocator);
  vkDestroyShaderModule(device, pipeline->shader.frag.module, allocator);
}
// namespace _
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview Raw api to manage Command types
// namespace mvk.commands
mvk_CommandBatch mvk_commands_create (VkDevice const device, mvk_Queue* const queue, VkAllocationCallbacks* const allocator);
mvk_CommandBatch mvk_commands_create (VkDevice const device, mvk_Queue* const queue, VkAllocationCallbacks* const allocator) {
  assert(queue->graphics.id.hasValue && "Creating a Graphics CommandBatch requires the graphics queue family id to have a value");
  mvk_CommandBatch result = {0};
  VkResult code;
  code = vkCreateCommandPool(device, &(VkCommandPoolCreateInfo){
    .sType= VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
    .pNext= NULL,
    .flags= VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
    .queueFamilyIndex= queue->graphics.id.value,
    }, allocator, &result.pool);
  if (code != VK_SUCCESS) {
    err("Failed to create a Graphics CommandBatch");
  }
  code = vkAllocateCommandBuffers(device, &(VkCommandBufferAllocateInfo){
    .sType= VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
    .pNext= NULL,
    .commandPool= result.pool,
    .level= VK_COMMAND_BUFFER_LEVEL_PRIMARY,
    .commandBufferCount= 1,
    }, &result.buffer);
  if (code != VK_SUCCESS) {
    err("Failed to create a Graphics CommandBatch Buffer");
  }
  return result;
}
void mvk_commands_destroy (VkDevice const device, mvk_CommandBatch* const cmds, VkAllocationCallbacks* const allocator);
void mvk_commands_destroy (VkDevice const device, mvk_CommandBatch* const cmds, VkAllocationCallbacks* const allocator) {
  vkDestroyCommandPool(device, cmds->pool, allocator);
}
// namespace _
/// m*vk  :  @copyright heysokam LGPLv3-or-later  :
/// @fileoverview Raw api to manage Vulkan Synchronization
// namespace mvk.sync
mvk_Sync mvk_sync_create (VkDevice const device, VkAllocationCallbacks* const allocator);
mvk_Sync mvk_sync_create (VkDevice const device, VkAllocationCallbacks* const allocator) {
  mvk_Sync result = {0};
  VkResult code;
  code = vkCreateSemaphore(device, &(VkSemaphoreCreateInfo){
    .sType= VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
    .pNext= NULL,
    .flags= (VkSemaphoreCreateFlags)0,
    }, allocator, &result.imageAvailable);
  if (code != VK_SUCCESS) {
    err("Failed to create the imageAvailable Semaphore");
  }
  code = vkCreateSemaphore(device, &(VkSemaphoreCreateInfo){
    .sType= VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
    .pNext= NULL,
    .flags= (VkSemaphoreCreateFlags)0,
    }, allocator, &result.renderFinished);
  if (code != VK_SUCCESS) {
    err("Failed to create the renderFinished Semaphore");
  }
  code = vkCreateFence(device, &(VkFenceCreateInfo){
    .sType= VK_STRUCTURE_TYPE_FENCE_CREATE_INFO,
    .pNext= NULL,
    .flags= VK_FENCE_CREATE_SIGNALED_BIT,
    }, allocator, &result.framesPending);
  if (code != VK_SUCCESS) {
    err("Failed to create the framesPending Fence");
  }
  return result;
}
void mvk_sync_destroy (VkDevice const device, mvk_Sync* const sync, VkAllocationCallbacks* const allocator);
void mvk_sync_destroy (VkDevice const device, mvk_Sync* const sync, VkAllocationCallbacks* const allocator) {
  vkDestroySemaphore(device, sync->imageAvailable, allocator);
  vkDestroySemaphore(device, sync->renderFinished, allocator);
  vkDestroyFence(device, sync->framesPending, allocator);
}
// namespace _
// namespace cfg
const/*comptime*/ static Sz cfg_W = 960;
const/*comptime*/ static Sz cfg_H = 540;
#if mstd_debug
extern const/*comptime*/ cstr cfg_mvk_Title; const/*comptime*/ cstr cfg_mvk_Title = "MinC | Vulkan.mvk.goal  ->Debug";
extern const/*comptime*/ cstr cfg_mgpu_Title; const/*comptime*/ cstr cfg_mgpu_Title = "MinC | Vulkan.mgpu.goal  ->Debug";
#elif mstd_release
extern const/*comptime*/ cstr cfg_mvk_Title; const/*comptime*/ cstr cfg_mvk_Title = "MinC | Vulkan.mvk.goal";
extern const/*comptime*/ cstr cfg_mgpu_Title; const/*comptime*/ cstr cfg_mgpu_Title = "MinC | Vulkan.mgpu.goal";
#endif
// namespace _
typedef struct tst_Gpu tst_Gpu;
struct tst_Gpu {
  mvk_Instance instance;
  mvk_Device device;
  mvk_Surface surface;
  mvk_Swapchain swapchain;
  mvk_Pipeline pipeline;
  mvk_CommandBatch cmds;
  mvk_Sync sync;
  };
// namespace mgpu.instance.extensions
cstr* mgpu_instance_extensions_get (u32 const listCount, cstr const list[], u32* const total);
cstr* mgpu_instance_extensions_get (u32 const listCount, cstr const list[], u32* const total) {
  /// @internal
  /// @descr Gets the full list of instance extensions, by merging our desired {@arg list} with the ones required by the system.
  /// @todo Forces the library to depend on GLFW
  cstr* const required = glfwGetRequiredInstanceExtensions(total);
  if (!required) {
    err("Couldn't find any Vulkan Extensions. Vk is not usable (probably not installed)");
  }
  cstr exts[listCount];
  for(size_t id = 0; id < listCount; ++id) {
    exts[id] = list[id];
  }
  cstr* const result = cstr_arr_merge(required, (Sz)(*total), exts, listCount);
  *total = *total + listCount;
  return result;
}
// namespace _
// namespace mgpu.surface
mvk_Surface mgpu_surface_create (mvk_Instance const instance, GLFWwindow* const window);
mvk_Surface mgpu_surface_create (mvk_Instance const instance, GLFWwindow* const window) {
  /// @descr Returns a valid Vulkan Surface for the {@arg window}
  /// @todo Forces the library to depend on GLFW
  mvk_Surface result = NULL;
  VkResult const code = glfwCreateWindowSurface(instance.ct, window, instance.allocator, &result);
  if (code != VK_SUCCESS) {
    err("Failed to get the Vulkan Surface from the given GLFW window.");
  }
  return result;
}
// namespace _
// namespace mgpu.swapchain
mvk_Swapchain mgpu_swapchain_create (mvk_Device* const device, GLFWwindow* const window, VkSurfaceKHR const surface, VkAllocationCallbacks* const allocator);
mvk_Swapchain mgpu_swapchain_create (mvk_Device* const device, GLFWwindow* const window, VkSurfaceKHR const surface, VkAllocationCallbacks* const allocator) {
  /// @descr Returns a Swapchain object with the size of the {@arg window}
  /// @todo Forces the library to depend on GLFW
  i32 W = 0;
  i32 H = 0;
  glfwGetFramebufferSize(window, &W, &H);
  return mvk_swapchain_create(device, surface, W, H, allocator);
}
// namespace _
tst_Gpu API_init (cstr const appName, u32 const appVers, cstr const engineName, u32 const engineVers, GLFWwindow* const window, PFN_vkDebugUtilsMessengerCallbackEXT const dbgCallback, void* const dbgUserdata, VkAllocationCallbacks* const allocator);
tst_Gpu API_init (cstr const appName, u32 const appVers, cstr const engineName, u32 const engineVers, GLFWwindow* const window, PFN_vkDebugUtilsMessengerCallbackEXT const dbgCallback, void* const dbgUserdata, VkAllocationCallbacks* const allocator) {
  tst_Gpu result = {0};
  u32 extCount = 0;
  cstr* const exts = mgpu_instance_extensions_get(mvk_cfg_instance_ExtensionsCount, mvk_cfg_instance_Extensions, &extCount);
  result.instance = mvk_instance_create(appName, appVers, engineName, engineVers, mvk_cfg_Version, mvk_cfg_instance_Flags, extCount, exts, mvk_cfg_validation_Active, mvk_cfg_validation_LayerCount, mvk_cfg_validation_Layers, mvk_cfg_validation_DebugFlags, mvk_cfg_validation_DebugSeverity, mvk_cfg_validation_DebugMsgType, (dbgCallback == NULL) ? mvk_cb_debug : dbgCallback, dbgUserdata, allocator);
  result.surface = mgpu_surface_create(result.instance, window);
  result.device = mvk_device_create(result.instance, result.surface, mvk_cfg_device_ForceFirst);
  result.swapchain = mgpu_swapchain_create(&result.device, window, result.surface, result.instance.allocator);
  result.pipeline = mvk_pipeline_create(result.device.logical, &result.swapchain, result.instance.allocator);
  result.cmds = mvk_commands_create(result.device.logical, &result.device.queue, result.instance.allocator);
  result.sync = mvk_sync_create(result.device.logical, result.instance.allocator);
  return result;
}
void API_term (tst_Gpu* const gpu);
void API_term (tst_Gpu* const gpu) {
  vkDeviceWaitIdle(gpu->device.logical);
  mvk_sync_destroy(gpu->device.logical, &gpu->sync, gpu->instance.allocator);
  mvk_commands_destroy(gpu->device.logical, &gpu->cmds, gpu->instance.allocator);
  mvk_pipeline_destroy(gpu->device.logical, &gpu->pipeline, gpu->instance.allocator);
  mvk_swapchain_destroy(gpu->device.logical, &gpu->swapchain, gpu->instance.allocator);
  vkDestroySurfaceKHR(gpu->instance.ct, gpu->surface, gpu->instance.allocator);
  vkDestroyDevice(gpu->device.logical, gpu->instance.allocator);
  mvk_validate_debug_destroy(gpu->instance.ct, &gpu->instance.dbg, gpu->instance.allocator, mvk_cfg_validation_Active);
  vkDestroyInstance(gpu->instance.ct, gpu->instance.allocator);
  (void)gpu->instance.allocator;/*discard*/
  return ;
}
void API_update (tst_Gpu* const gpu);
void API_update (tst_Gpu* const gpu) {
  VkResult code;
  code = vkWaitForFences(gpu->device.logical, 1, &gpu->sync.framesPending, VK_TRUE, u64_high);
  vkResetFences(gpu->device.logical, 1, &gpu->sync.framesPending);
  u32 fbufferID = 0;
  code = vkAcquireNextImageKHR(gpu->device.logical, gpu->swapchain.ct, u64_high, gpu->sync.imageAvailable, VK_NULL_HANDLE, &fbufferID);
  vkResetCommandBuffer(gpu->cmds.buffer, (VkCommandBufferResetFlags)0);
  code = vkBeginCommandBuffer(gpu->cmds.buffer, &(VkCommandBufferBeginInfo){
    .sType= VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
    .pNext= NULL,
    .flags= (VkCommandBufferUsageFlags)0,
    .pInheritanceInfo= NULL,
    });
  if (code != VK_SUCCESS) {
    err("Failed to record the tutorial Command Buffer");
  }
  vkCmdBeginRenderPass(gpu->cmds.buffer, &(VkRenderPassBeginInfo){
    .sType= VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,
    .pNext= NULL,
    .renderPass= gpu->pipeline.target.ct,
    .framebuffer= gpu->pipeline.target.fbuffers[fbufferID],
    .renderArea= (VkRect2D){
      .offset= (VkOffset2D){
        .x= 0,
        .y= 0,
        },
      .extent= gpu->swapchain.size,
      },
    .clearValueCount= 1,
    .pClearValues= &(VkClearValue){
      .color= (VkClearColorValue){ .float32= { [0]= 0.222, [1]= 0.333, [2]= 0.444, [3]= 1.0 } },
      },
    }, VK_SUBPASS_CONTENTS_INLINE);
  vkCmdBindPipeline(gpu->cmds.buffer, VK_PIPELINE_BIND_POINT_GRAPHICS, gpu->pipeline.ct);
  vkCmdSetViewport(gpu->cmds.buffer, 0, 1, &gpu->pipeline.viewport);
  vkCmdSetScissor(gpu->cmds.buffer, 0, 1, &gpu->pipeline.scissor);
  vkCmdDraw(gpu->cmds.buffer, 3, 1, 0, 0);
  vkCmdEndRenderPass(gpu->cmds.buffer);
  code = vkEndCommandBuffer(gpu->cmds.buffer);
  if (code != VK_SUCCESS) {
    err("Failed to record the tutorial Commands");
  }
  VkPipelineStageFlagBits const waitStages[] = {
    [0]= VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
  };
  code = vkQueueSubmit(gpu->device.queue.graphics.ct, 1, &(VkSubmitInfo){
    .sType= VK_STRUCTURE_TYPE_SUBMIT_INFO,
    .pNext= NULL,
    .waitSemaphoreCount= 1,
    .pWaitSemaphores= &gpu->sync.imageAvailable,
    .pWaitDstStageMask= waitStages,
    .commandBufferCount= 1,
    .pCommandBuffers= &gpu->cmds.buffer,
    .signalSemaphoreCount= 1,
    .pSignalSemaphores= &gpu->sync.renderFinished,
    }, gpu->sync.framesPending);
  if (code != VK_SUCCESS) {
    err("Failed to submit the Drawing Command Buffer to the Device Queue");
  }
  code = vkQueuePresentKHR(gpu->device.queue.present.ct, &(VkPresentInfoKHR){
    .sType= VK_STRUCTURE_TYPE_PRESENT_INFO_KHR,
    .pNext= NULL,
    .waitSemaphoreCount= 1,
    .pWaitSemaphores= &gpu->sync.renderFinished,
    .swapchainCount= 1,
    .pSwapchains= &gpu->swapchain.ct,
    .pImageIndices= &fbufferID,
    .pResults= NULL,
    });
}
// i32 main (void) {
//   msys_System sys = msys_init(cfg_W, cfg_H, cfg_mvk_Title, msys_cb_error, NULL, i_key, NULL, NULL, NULL, NULL);
//   tst_Gpu gpu = API_init(cfg_mvk_Title, mstd_vers_new(1, 0, 0), cfg_mvk_Title, mstd_vers_new(1, 0, 0), sys.win.ct, NULL, NULL, NULL);
//   while (!msys_close(&sys)) {
//     msys_update(&sys);
//     API_update(&gpu);
//   }
//   API_term(&gpu);
//   msys_term(&sys);
//   return 0;
// }

