#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h", cdecl.}
# @deps vulkan
from ../nvulkan as vk import nil

type Version * = vk.Version

proc new *(
    M :SomeInteger= 0;
    m :SomeInteger= 0;
    p :SomeInteger= 0;
  ) :Version {.importc:"VK_MAKE_VERSION", vulkan.}

