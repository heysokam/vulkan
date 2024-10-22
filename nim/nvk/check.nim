#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps vulkan
from ../nvulkan as vk import toBool

type VulkanError = object of CatchableError
proc ok *(val :vk.Result) :void=
  if not val: raise newException(VulkanError, $val)

