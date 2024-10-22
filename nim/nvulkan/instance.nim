#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h".}
# @deps nvulkan
from ./base as vk import nil
import ./stype
import ./strings
import ./result as R
import ./allocator
import ./application as App

#_____________________________
type Instance * = vk.Instance

#_____________________________
type Flags_C *{.importc:"VkInstanceCreateFlags", vulkan.}= uint32
type Flag *{.importc:"VkInstanceCreateFlagBits", vulkan, pure, size:sizeof(int32).}= enum
  portability
type Flags * = set[Flag]
converter toFlags *(flag :Flag) :Flags= {flag}
converter toFlag  *(flags :Flags_C) :Flags= cast[Flags](flags)

#_____________________________
type Cfg *{.importc:"VkInstanceCreateInfo", vulkan.}= object
  sType       {.importc:"sType"                  .}:StructureType  = stype.InstanceCfg  # VkStructureType  sType;
  next       *{.importc:"pNext"                  .}:pointer        = nil                # const void*      pNext;
  flags      *{.importc:"flags"                  .}:Flags          # VkInstanceCreateFlags       flags;
  appCfg     *{.importc:"pApplicationInfo"       .}:ptr App.Cfg    # const VkApplicationInfo*    pApplicationInfo;
  layerCount *{.importc:"enabledLayerCount"      .}:uint32         # uint32_t                    enabledLayerCount;
  layers     *{.importc:"ppEnabledLayerNames"    .}:StringList     # const char* const*          ppEnabledLayerNames;
  extCount   *{.importc:"enabledExtensionCount"  .}:uint32         # uint32_t                    enabledExtensionCount;
  exts       *{.importc:"ppEnabledExtensionNames".}:StringList     # const char* const*          ppEnabledExtensionNames;

proc create *(
    cfg    : ptr instance.Cfg;
    A      : ptr Allocator;
    result : ptr vk.Instance;
  ) :Result {.importc:"vkCreateInstance", vulkan, cdecl.}

proc destroy *(
    I : vk.Instance;
    A : ptr Allocator;
  ) :void {.importc:"vkDestroyInstance", vulkan, cdecl.}

