#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h".}
# @deps nvulkan
from ./strings as vk import nil

const Portability *{.importc:"VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME", vulkan.}= vk.String"VK_KHR_portability_enumeration"
const Debug       *{.importc:"VK_EXT_DEBUG_UTILS_EXTENSION_NAME",             vulkan.}= vk.String"VK_EXT_debug_utils"

