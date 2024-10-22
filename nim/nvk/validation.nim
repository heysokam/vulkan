#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps vulkan
from ../nvulkan as vk import nil
# @deps nvk
import ./cfg

proc checkSupport *(
    active = cfg.validation_active;
    layers = cfg.validation_layers;
  ) :void=
  discard
