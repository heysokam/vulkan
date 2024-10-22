#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h".}
# @deps nvulkan
from ./base as vk import nil
import ./stype
import ./otype
import ./strings
import ./result as R
import ./allocator

#_____________________________
type Debug *{.importc:"VkDebugUtilsMessengerEXT", vulkan.}=  ptr object
type Flags *{.importc:"VkDebugUtilsMessengerCreateFlagsEXT", vulkan.}=  uint32

#_____________________________
type Label *{.importc:"VkDebugUtilsLabelEXT", vulkan.}= object
  sType   {.importc:"sType"     .}:StructureType      # VkStructureType  sType;
  pNext   {.importc:"pNext"     .}:pointer            # const void*      pNext;
  label  *{.importc:"pLabelName".}:String             # const char*      pLabelName;
  color  *{.importc:"color"     .}:array[4, float32]  # float            color[4];

#_____________________________
type ObjectName *{.importc:"VkDebugUtilsObjectNameInfoEXT", vulkan.}= object
  sType    {.importc:"sType"       .}:StructureType  # VkStructureType  sType;
  pNext    {.importc:"pNext"       .}:pointer        # const void*      pNext;
  typ     *{.importc:"objectType"  .}:ObjectType     # VkObjectType     objectType;
  handle  *{.importc:"objectHandle".}:uint64         # uint64_t         objectHandle;
  name    *{.importc:"pObjectName" .}:String         # const char*      pObjectName;

#_____________________________
type CallbackFlags  *{.importc:"VkDebugUtilsMessengerCallbackDataFlagsEXT", vulkan.}=  uint32
type CallbackData_C *{.importc:"const struct VkDebugUtilsMessengerCallbackDataEXT *", vulkan.}= pointer
type CallbackData   *{.importc:"VkDebugUtilsMessengerCallbackDataEXT", vulkan.}= object
  sType             {.importc:"sType"           .}:StructureType   # VkStructureType                            sType;
  next              {.importc:"pNext"           .}:pointer         # const void*                                pNext;
  flags            *{.importc:"flags"           .}:CallbackFlags   # VkDebugUtilsMessengerCallbackDataFlagsEXT  flags;
  msgName          *{.importc:"pMessageIdName"  .}:String          # const char*                                pMessageIdName;
  msgMumber        *{.importc:"messageIdNumber" .}:int32           # int32_t                                    messageIdNumber;
  msg              *{.importc:"pMessage"        .}:String          # const char*                                pMessage;
  queueLabelCount  *{.importc:"queueLabelCount" .}:uint32          # uint32_t                                   queueLabelCount;
  queueLabels      *{.importc:"pQueueLabels"    .}:ptr Label       # const VkDebugUtilsLabelEXT*                pQueueLabels;
  cmdBufLabelCount *{.importc:"cmdBufLabelCount".}:uint32          # uint32_t                                   cmdBufLabelCount;
  cmdBufLabels     *{.importc:"pCmdBufLabels"   .}:ptr Label       # const VkDebugUtilsLabelEXT*                pCmdBufLabels;
  objCount         *{.importc:"objectCount"     .}:uint32          # uint32_t                                   objectCount;
  objs             *{.importc:"pObjects"        .}:ptr ObjectName  # const VkDebugUtilsObjectNameInfoEXT*       pObjects;
#_____________________________
type Severity *{.importc:"VkDebugUtilsMessageSeverityFlagBitsEXT", vulkan, pure, size:sizeof(int32).}= enum
  verbose, info, warning, error
type Severities * = set[Severity]
type Severities_C *{.importc:"VkDebugUtilsMessageSeverityFlagsEXT", vulkan.}= uint32
converter toSeverities *(val :Severity)     :Severities= {val}
converter toSeverities *(val :Severities_C) :Severities= cast[Severities](val)

#_____________________________
type MsgType *{.importc:"VkDebugUtilsMessageTypeFlagBitsEXT", vulkan, pure, size:sizeof(int32).}= enum
  general, validation, performance, deviceAddressBinding
type MsgTypes * = set[MsgType]
type MsgTypes_C *{.importc:"VkDebugUtilsMessageTypeFlagsEXT", vulkan.}= uint32
converter toMsgTypes *(val :MsgType)    :MsgTypes= {val}
converter toMsgTypes *(val :MsgTypes_C) :MsgTypes= cast[MsgTypes](val)

#_____________________________
type Callback * = proc (
    severity : debug.Severity;
    msgType  : debug.MsgTypes_C;
    data     : debug.CallbackData_C;
    userdata : pointer;
  ) :uint32 {.cdecl.} # importc:"PFN_vkDebugUtilsMessengerCallbackEXT", vulkan

#_____________________________
type Cfg *{.importc:"VkDebugUtilsMessengerCreateInfoEXT", vulkan.}= object
  stype      {.importc:"sType"          .}:StructureType = stype.DebugCfg #  VkStructureType                       sType;
  next      *{.importc:"pNext"          .}:pointer       = nil            #  const void*                           pNext;
  flags     *{.importc:"flags"          .}:Flags                          #  VkDebugUtilsMessengerCreateFlagsEXT   flags;
  severity  *{.importc:"messageSeverity".}:Severities                     #  VkDebugUtilsMessageSeverityFlagsEXT   messageSeverity;
  msgType   *{.importc:"messageType"    .}:MsgTypes                       #  VkDebugUtilsMessageTypeFlagsEXT       messageType;
  callback  *{.importc:"pfnUserCallback".}:Callback                       #  PFN_vkDebugUtilsMessengerCallbackEXT  pfnUserCallback;
  userdata  *{.importc:"pUserData"      .}:pointer                        #  void*                                 pUserData;

#_____________________________
type Fn_vk_debug_create  *{.importc:"PFN_vkCreateDebugUtilsMessengerEXT",  vulkan.}= proc (
    instance  : vk.Instance;
    cfg       : ptr debug.Cfg;
    allocator : ptr Allocator;
    result    : ptr debug.Debug;
  ) :Result {.cdecl.}
type Fn_vk_debug_destroy *{.importc:"PFN_vkDestroyDebugUtilsMessengerEXT", vulkan.}= proc (
    instance  : vk.Instance;
    messenger : debug.Debug;
    allocator : ptr Allocator;
  ) :void {.cdecl.}

#_____________________________
proc create *(
    I   : vk.Instance;
    cfg : ptr debug.Cfg;
    A   : ptr Allocator;
    ) :debug.Debug=
  let debug_create = cast[Fn_vk_debug_create](vk.getProc(I, "vkCreateDebugUtilsMessengerEXT".String))
  # var debug_create = getFn_create(I)
  discard debug_create(I, cfg, A, result.addr)

proc destroy *(
    I   : vk.Instance;
    trg : debug.Debug;
    A   : ptr Allocator;
  ) :void=
  let debug_destroy = cast[Fn_vk_debug_destroy](vk.getProc(I, "vkDestroyDebugUtilsMessengerEXT".String))
  # var debug_destroy = getFn_destroy(I)
  debug_destroy(I, trg, A)

