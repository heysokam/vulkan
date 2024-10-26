{.passL: "-lglfw3".}
{.passL: "-lvulkan".}
{.passC: "-std=c2x".}
{.compile: "mvk.c".}


#_________________________________________________
# @section mstd wrapper
#_____________________________
type i32    * = int32
type u32    * = uint32
type f64    * = float64
type Sz     * = csize_t
type cstr   * = cstring
type Ou32   * = object
type Handle * = object
  id  *:u32
proc vers_new *(M, m, p :u32) :u32 {.importc: "mstd_vers_new", cdecl.}


#_________________________________________________
# @section GLFW types required by msys
#_____________________________
{.pragma: glfw, cdecl, header: "GLFW/glfw3.h".}
type GLFWwindow             * = ptr object
type GLFWerrorfun           * = proc(error_code :i32; description :cstr) :void {.cdecl.}
type GLFWframebuffersizefun * = proc(window :GLFWwindow; width :i32; height :i32) :void {.cdecl.}
type GLFWkeyfun             * = proc(window :GLFWwindow; key :i32; scancode :i32, action: i32, mods: i32) :void {.cdecl.}
type GLFWcursorposfun       * = proc(window :GLFWwindow; xpos :f64; ypos :f64) :void {.cdecl.}
type GLFWmousebuttonfun     * = proc(window :GLFWwindow; button :i32; action :i32, mods: i32) :void {.cdecl.}
type GLFWscrollfun          * = proc(window :GLFWwindow; xoffset :f64; yoffset :f64) :void {.cdecl.}


#_________________________________________________
# @section msys wrapper
#_____________________________
type Input  * = Handle
type Window * = object
  ct     *:GLFWwindow
  W      *:Sz
  H      *:Sz
  title  *:cstr
type System * = object
  win  *:Window
  inp  *:Input
proc key       *(win :GLFWwindow; key, code, action, mods :i32) :void {.importc: "i_key", cdecl.}
proc error     *(code :i32; descr :cstr) :void {.importc: "msys_cb_error", cdecl.}
proc close     *(sys :ptr System) :bool {.importc: "msys_close", cdecl.}
proc update    *(sys :ptr System) :void {.importc: "msys_update", cdecl.}
proc term      *(sys :ptr System) :void {.importc: "msys_term", cdecl.}
proc msys_init *(
    W,H         : Sz;
    title       : cstr;
    errorCB     : GLFWerrorfun           = error;
    resizeCB    : GLFWframebuffersizefun = nil;
    key         : GLFWkeyfun             = key;
    mousePos    : GLFWcursorposfun       = nil;
    mouseBtn    : GLFWmousebuttonfun     = nil;
    mouseScroll : GLFWscrollfun          = nil;
    userdata    : pointer                = nil;
  ) :System {.importc: "msys_init", cdecl.}


#[
struct mvk_QueueFamilies {
  u32 propCount;
  u32 priv_pad;
  VkQueueFamilyProperties* props;
  Ou32 graphics;
  Ou32 present;
  };
struct mvk_device_SwapchainSupport {
  VkSurfaceCapabilitiesKHR caps;
  u32 formatCount;
  VkSurfaceFormatKHR* formats;
  u32 priv_pad1;
  u32 modeCount;
  VkPresentModeKHR* modes;
  };
]#

#_________________________________________________
# @section Vulkan wrapper
#_____________________________
{.pragma: vulkan, importc, header: "<vulkan/vulkan.h>".}
# Constants / Enums
const VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR *{.vulkan.}= 0x00000001
const VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME    *{.vulkan.}= cstring "VK_KHR_portability_enumeration"
const VK_EXT_DEBUG_UTILS_EXTENSION_NAME                *{.vulkan.}= cstring "VK_EXT_debug_utils"
const VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT  *{.vulkan.}= 0x00000001
const VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT  *{.vulkan.}= 0x00000100
const VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT    *{.vulkan.}= 0x00001000
const VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT      *{.vulkan.}= 0x00000001
const VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT   *{.vulkan.}= 0x00000002
const VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT  *{.vulkan.}= 0x00000004
const VK_SUCCESS                                       *{.vulkan.}= 0
# Objects / Types
type VkBool32                               *{.vulkan.}= uint32
type VkResult                               *{.vulkan.}= uint32
type VkDebugUtilsMessengerCreateFlagsEXT    *{.vulkan.}= uint32
type VkDebugUtilsMessageSeverityFlagBitsEXT *{.vulkan.}= uint32
type VkDebugUtilsMessageSeverityFlagsEXT    *{.vulkan.}= uint32
type VkDebugUtilsMessageTypeFlagsEXT        *{.vulkan.}= uint32
type VkDebugUtilsMessengerCallbackDataEXT   *{.vulkan.}= object
type VkDebugUtilsMessengerCreateInfoEXT     *{.vulkan.}= object
type VkDebugUtilsMessengerEXT               *{.vulkan.}= object
type VkInstanceCreateFlags                  *{.vulkan.}= uint32
type VkInstance                             *{.vulkan.}= object
type VkApplicationInfo                      *{.vulkan.}= object
type VkAllocationCallbacks                  *{.vulkan.}= object
type VkPhysicalDevice                       *{.vulkan.}= object
type VkQueue                                *{.vulkan.}= object
type VkDevice                               *{.vulkan.}= object
type VkSurfaceKHR                           *{.vulkan.}= object
type VkSwapchainKHR                         *{.vulkan.}= object
type VkSurfaceFormatKHR                     *{.vulkan.}= object
type VkPresentModeKHR                       *{.vulkan.}= object
type VkExtent2D                             *{.vulkan.}= object
type VkImage                                *{.vulkan.}= object
type VkImageView                            *{.vulkan.}= object
type VkRect2D                               *{.vulkan.}= object
type VkViewport                             *{.vulkan.}= object
type VkPipelineLayout                       *{.vulkan.}= object
type VkRenderPass                           *{.vulkan.}= object
type VkFramebuffer                          *{.vulkan.}= object
type VkPipeline                             *{.vulkan.}= object
type VkCommandPool                          *{.vulkan.}= object
type VkCommandBuffer                        *{.vulkan.}= object
type VkSemaphore                            *{.vulkan.}= object
type VkFence                                *{.vulkan.}= object
type VkPipelineShaderStageCreateInfo        *{.vulkan.}= object
# Function types
type PFN_vkDebugUtilsMessengerCallbackEXT *{.vulkan.}= proc (
    severity : VkDebugUtilsMessageSeverityFlagBitsEXT;
    types    : VkDebugUtilsMessageTypeFlagsEXT;
    cbdata   : ptr VkDebugUtilsMessengerCallbackDataEXT;
    userdata : pointer
  ) :VkBool32 {.cdecl.}


#_________________________________________________
# @section GLFW Vulkan.
#  Required by the `api_functionName` functions
#_____________________________
proc glfwGetRequiredInstanceExtensions *(count :ptr uint32) :cstringArray {.importc, glfw.}
proc glfwCreateWindowSurface *(
    instance  : VkInstance;
    window    : GLFWWindow;
    allocator : ptr VkAllocationCallbacks;
    surface   : ptr VkSurfaceKHR;
  ) :VkResult {.importc, glfw.}
proc glfwGetFramebufferSize *(
    window : GLFWWindow;
    width  : ptr int32;
    height : ptr int32;
  ): void {.importc, glfw.}


#_______________________________________
# @section mvk Configuration
#_____________________________
const debug *{.booldefine.}=  not (defined(release) or (defined(danger)))
#___________________
# General Config
let cfg_Version *:u32=  vers_new(1,0,0)
#___________________
# Validation Layers
const cfg_validation_Active *{.booldefine.}=  mvk.debug
const cfg_validation_LayerCount * = when cfg_validation_Active: 1 else: 0
const cfg_validation_Layers *:array[cfg_validation_LayerCount,cstr]=
  when cfg_validation_Active : [ cstring "VK_LAYER_KHRONOS_validation" ]
  else                       : []
#___________________
# Debug Messenger
const cfg_validation_DebugFlags    *:VkDebugUtilsMessengerCreateFlagsEXT= 0
const cfg_validation_DebugSeverity *:VkDebugUtilsMessageSeverityFlagsEXT=
  VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT or VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT or VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT
const cfg_validation_DebugMsgType  *:VkDebugUtilsMessageTypeFlagsEXT=
  VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT or VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT or VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT
#___________________
# Instance Extensions
const cfg_instance_Flags           * = when defined(macosx): VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR else: 0
const cfg_instance_ExtensionsCount * = when defined(macosx): 2 else: 1
const cfg_instance_Extensions *:array[cfg_instance_ExtensionsCount,cstr]=
  when defined(macosx) : [ VK_EXT_DEBUG_UTILS_EXTENSION_NAME, VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME ]
  else                 : [ VK_EXT_DEBUG_UTILS_EXTENSION_NAME ]
#___________________
# Device (Physical + Logical + Queue)
const cfg_device_forceFirst *{.booldefine.}= off


#_______________________________________
# @section mvk Utilities
#_____________________________
proc cb_debug *(
    severity : VkDebugUtilsMessageSeverityFlagBitsEXT;
    types    : VkDebugUtilsMessageTypeFlagsEXT;
    cbdata   : ptr VkDebugUtilsMessengerCallbackDataEXT;
    userdata : pointer;
  ) :VkBool32 {.importc: "mvk_cb_debug", cdecl.}


#_________________________________________________
# @section mvk Types
#_____________________________
type Debug * = object
  ct   *:ptr VkDebugUtilsMessengerEXT
  cfg  *:VkDebugUtilsMessengerCreateInfoEXT
#___________________
type Instance * = object
  ct    *:VkInstance
  info  *:VkApplicationInfo
  dbg   *:Debug
  allocator *:ptr VkAllocationCallbacks
#___________________
type QueueEntry * = object
  id  *:Ou32
  ct  *:VkQueue
#___________________
type Queue * = object
  graphics  *:QueueEntry
  present   *:QueueEntry
#___________________
type Device * = object
  physical  *:VkPhysicalDevice
  queue     *:Queue
  logical   *:VkDevice
#___________________
type Surface * = VkSurfaceKHR
type Swapchain * = object
  ct        *:VkSwapchainKHR
  format    *:VkSurfaceFormatKHR
  mode      *:VkPresentModeKHR
  size      *:VkExtent2D
  priv_pad:u32
  imgMin    *:u32
  imgCount  *:u32
  images    *:ptr VkImage
  views     *:ptr VkImageView
#___________________
type Shader * = object
  vert  *:VkPipelineShaderStageCreateInfo
  frag  *:VkPipelineShaderStageCreateInfo
#___________________
type RenderTarget * = object
  ct        *:VkRenderPass
  priv_pad:u32
  fbCount   *:u32
  fbuffers  *:ptr VkFramebuffer
#___________________
type Pipeline * = object
  ct        *:VkPipeline
  shader    *:Shader
  viewport  *:VkViewport
  scissor   *:VkRect2D
  shape     *:VkPipelineLayout
  target    *:RenderTarget
#___________________
type CommandBatch * = object
  pool    *:VkCommandPool
  buffer  *:VkCommandBuffer
#___________________
type Sync * = object
  imageAvailable  *:VkSemaphore
  renderFinished  *:VkSemaphore
  framesPending   *:VkFence


#_______________________________________
# @section mvk Bootstrap Toolset
#_____________________________
proc instance_create *(
    # AppInfo
    appName     : cstr;
    appVers     : u32;
    engineName  : cstr;
    engineVers  : u32;
    apiVersion  : u32;
    # Instance Options
    flags       : VkInstanceCreateFlags;
    extCount    : u32;
    exts        : ptr cstring;
    # Validation
    validate    : bool;
    layerCount  : u32;
    layers      : ptr cstring;
    dbgFlags    : VkDebugUtilsMessengerCreateFlagsEXT;
    dbgSeverity : VkDebugUtilsMessageSeverityFlagsEXT;
    dbgMsgType  : VkDebugUtilsMessageTypeFlagsEXT;
    dbgCallback : PFN_vkDebugUtilsMessengerCallbackEXT;
    dbgUserdata : pointer;
    # Allocation
    allocator   : ptr VkAllocationCallbacks;
  ) :Instance {.importc: "mvk_instance_create", cdecl.}
#___________________
proc device_create *(
    instance   : Instance;
    surface    : Surface;
    forceFirst : bool;
  ) :Device {.importc: "mvk_device_create", cdecl.}
#___________________
proc swapchain_create *(
    device    : ptr Device;
    surface   : VkSurfaceKHR;
    W,H       : i32;
    allocator : ptr VkAllocationCallbacks;
  ) :Swapchain {.importc: "mvk_swapchain_create", cdecl.}

#_____________________________
# @section mvk Beyond-Boostrap Toolset
#___________________
proc pipeline_create *(
    device    : VkDevice;
    swapchain : ptr Swapchain;
    allocator : ptr VkAllocationCallbacks;
  ) :Pipeline {.importc: "mvk_pipeline_create", cdecl.}
#___________________
proc commands_create *(
    device    : VkDevice;
    queue     : ptr Queue;
    allocator : ptr VkAllocationCallbacks;
  ) :CommandBatch {.importc: "mvk_commands_create", cdecl.}
#___________________
proc sync_create *(
    device    : VkDevice;
    allocator : ptr VkAllocationCallbacks;
  ) :Sync {.importc: "mvk_sync_create", cdecl.}

