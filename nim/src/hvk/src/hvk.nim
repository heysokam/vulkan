import ./mvk

#_______________________________________
# @section Configuration
#_____________________________
const W     = 940
const H     = 540
const Title = "Hacky VulkanNim"
proc err (msg :string) :void= quit(Title&": "&msg)



#_______________________________________
# @section API
#_____________________________
# @deps std
from std/sequtils import toSeq
#_____________________________
# Types
#___________________
type GPU * = object
  instance   *:Instance
  device     *:Device
  surface    *:Surface
  swapchain  *:Swapchain
  pipeline   *:Pipeline
  cmds       *:CommandBatch
  sync       *:Sync
#_____________________________
# Functions
#___________________
proc api_instance_extensions_get *(exts :openArray[cstring]= []) :seq[cstring]=
  ## @internal
  ## @descr Gets the full list of instance extensions, by merging our desired {@arg list} with the ones required by the system.
  ## @todo Forces the library to depend on GLFW
  result = exts.toSeq
  var reqCount :u32= 0
  var required = glfwGetRequiredInstanceExtensions(addr reqCount)
  if required.isNil: err "Couldn't find any Extensions. Vulkan is not usable (probably not installed)"
  for ext in cstringArrayToSeq(required, reqCount): result.add(ext.cstring)
#___________________
proc api_surface_create *(
    instance  : mvk.Instance;
    window    : GLFWwindow;
  ) :mvk.Surface=
  ## @descr Returns a valid Vulkan Surface for the {@arg window}
  ## @todo Forces the library to depend on GLFW
  let code :VkResult= glfwCreateWindowSurface(instance.ct, window, instance.allocator, addr result)
  if code != VK_SUCCESS: err "Failed to get the Vulkan Surface from the given GLFW window."
  return result
#___________________
proc api_swapchain_create *(
    device    : mvk.Device;
    window    : GLFWwindow;
    surface   : mvk.Surface;
    allocator : ptr VkAllocationCallbacks;
  ) :mvk.Swapchain=
  ## @descr Returns a Swapchain object with the size of the {@arg window}
  ## @todo Forces the library to depend on GLFW
  # Get the initial size
  var W :i32= 0
  var H :i32= 0
  glfwGetFramebufferSize(window, addr W, addr H)
  # Create the Swapchain object
  result = mvk.swapchain_create(
    #[ device    ]# device.addr,
    #[ surface   ]# surface,
    #[ W,H       ]# W,H,
    #[ allocator ]# allocator,
    ) # << mvk_swapchain_create( ... )


#_______________________________________
# @section Core API functionality
#_____________________________
proc init (
    appName     : string;
    appVers     : u32;
    engineName  : string;
    engineVers  : u32;
    window      : GLFWwindow;
    dbgCallback : PFN_vkDebugUtilsMessengerCallbackEXT = nil;
    dbgUserdata : pointer                              = nil;
    allocator   : ptr VkAllocationCallbacks            = nil;
  ) :GPU=
  # 1. Create Instance
  let exts = api_instance_extensions_get([])
  result.instance = mvk.instance_create(
    # 2.2.1 Pass AppInfo
    appName     = appName.cstring,
    appVers     = appVers,
    engineName  = engineName.cstring,
    engineVers  = engineVers,
    apiVersion  = mvk.cfg_Version,
    # 2.2.2 Instance Options
    flags       = mvk.cfg_instance_Flags,
    extCount    = exts.len.uint32,
    exts        = exts[0].addr,
    # 2.2.3 Validation
    validate    = mvk.cfg_validation_Active,
    layerCount  = mvk.cfg_validation_LayerCount,
    layers      = mvk.cfg_validation_Layers[0].addr,
    # 2.2.4 Debug
    dbgFlags    = mvk.cfg_validation_DebugFlags,
    dbgSeverity = mvk.cfg_validation_DebugSeverity,
    dbgMsgType  = mvk.cfg_validation_DebugMsgType,
    dbgCallback = if dbgCallback.isNil: mvk.cb_debug else: dbgCallback,
    dbgUserdata = dbgUserdata,
    # 2.2.5 Pass Allocator
    allocator   = allocator,
    ) # << mvk_instance_create( ... )
  # 2. Create Surface
  result.surface = api_surface_create(
    instance = result.instance,
    window   = window,
    ) # << api_surface_create( ... )
  # 3. Create Device   (physical+logical+queue)
  result.device = mvk.device_create(
    instance   = result.instance,
    surface    = result.surface,
    forceFirst = mvk.cfg_device_ForceFirst,
    ) # << mvk_device_create( ... )
  # 4. Create Swapchain
  result.swapchain = api_swapchain_create(
    device    = result.device,
    window    = window,
    surface   = result.surface,
    allocator = result.instance.allocator,
    ) # << api_swapchain_create( ... )
  #_____________________________
  # @section Triangle Tutorial: Initialization
  #_____________________________
  # 6. Create the Pipeline
  result.pipeline = mvk.pipeline_create(
    device    = result.device.logical,
    swapchain = addr result.swapchain,
    allocator = result.instance.allocator,
    ) # << mvk_pipeline_create( ... )
  # 7. Create the Command Batches
  result.cmds = mvk.commands_create(
    device    = result.device.logical,
    queue     = addr result.device.queue,
    allocator = result.instance.allocator,
    ) # << mvk_commands_create( ... )
  # 8. Create the Synchronization objects
  result.sync = mvk.sync_create(
    device    = result.device.logical,
    allocator = result.instance.allocator,
    ) # << mvk_sync_create( ... )
#___________________
# TODO: Port the code, remove the wrapper
proc term   *(gpu :ptr GPU) :void {.importc: "API_term".}
proc update *(gpu :ptr GPU) :void {.importc: "API_update".}


#_______________________________________
# @section Entry Point
#_____________________________
when isMainModule:
  echo "Hello ", Title
  # Initialize
  var sys = msys_init(W,H, Title.cstring)  # Create the window+input.
  var gpu = hvk.init(                      # Initialize the GPU object
    appName     = Title,
    appVers     = mvk.vers_new(1,0,0),
    engineName  = Title,
    engineVers  = mvk.vers_new(1,0,0),
    window      = sys.win.ct,
    ) # << hvk.init( ... )
  # Update Loop
  while not sys.addr.close:
    sys.addr.update
    gpu.addr.update
  # Terminate
  sys.addr.term
  gpu.addr.term

