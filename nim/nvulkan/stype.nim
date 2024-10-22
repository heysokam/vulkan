#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h".}

type StructureType *{.importc:"VkStructureType", vulkan.}= uint32

const ApplicationCfg *{.importc:"VK_STRUCTURE_TYPE_APPLICATION_INFO", vulkan.}:StructureType= 0
const InstanceCfg    *{.importc:"VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO", vulkan.}:StructureType= 1
const DebugCfg       *{.importc:"VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT", vulkan.}:StructureType= 1000128004

