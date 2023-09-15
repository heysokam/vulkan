#:___________________________________________________
#  nvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
import ./vulkan
import ./cfg
import ./element/instance

type VulkanCfg * = object
  appName    *:string= cfg.Prefix&" | Application"
  appVers    *:uint32= vkMakeVersion(0,0,0)
  engineName *:string= cfg.Prefix&" | Engine"
  engineVers *:uint32= vkMakeVersion(0,0,0)

type Vulkan * = ref object
  instance :VkInstance

proc update *(vk :var Vulkan) :void= discard
proc term   *(vk :var Vulkan) :void= discard
proc init   *(vc :VulkanCfg) :Vulkan=
  new result
  result.instance = instance.create(
    appName    = vc.appName,
    appVers    = vc.appVers,
    engineName = vc.engineName,
    engineVers = vc.engineVers,
    ) # << instance.create( ... )

