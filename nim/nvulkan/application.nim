#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h".}
# @deps nvulkan
import ./stype
import ./strings
import ./version

type Cfg *{.importc:"VkApplicationInfo", vulkan.}= object
  sType        {.importc:"sType"             .}:StructureType = stype.ApplicationCfg  # VkStructureType             sType;
  next        *{.importc:"pNext"             .}:pointer       = nil                   # const void*                 pNext;
  appName     *{.importc:"pApplicationName"  .}:String   #  const char*        pApplicationName;
  appVers     *{.importc:"applicationVersion".}:Version  #  uint32_t           applicationVersion;
  engineName  *{.importc:"pEngineName"       .}:String   #  const char*        pEngineName;
  engineVers  *{.importc:"engineVersion"     .}:Version  #  uint32_t           engineVersion;
  apiVers     *{.importc:"apiVersion"        .}:Version  #  uint32_t           apiVersion;

