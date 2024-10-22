#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h", cdecl.}

type Version * = uint32
proc new *(
    M :SomeInteger= 0;
    m :SomeInteger= 0;
    p :SomeInteger= 0;
  ) :Version {.importc:"VK_MAKE_VERSION", vulkan.}

proc api *(
    V :SomeInteger= 0;
    M :SomeInteger= 0;
    m :SomeInteger= 0;
    p :SomeInteger= 0;
  ) :Version {.importc:"VK_MAKE_API_VERSION", vulkan.}

