#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps vulkan
from ../nvulkan as vk import nil

type Allocator * = object
  vk  *:ptr vk.Allocator=  nil

