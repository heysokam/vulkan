#:___________________________________________________
#  nvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
import ./vulkan as vk
import ./cfg
import ./element/instance

type VulkanCfg * = object
  appName    *:string= cfg.Prefix&" | Application"
  appVers    *:uint32= vk.makeVersion(0,0,0)
  engineName *:string= cfg.Prefix&" | Engine"
  engineVers *:uint32= vk.makeVersion(0,0,0)

type Vulkan * = ref object
  instance :vk.Instance

proc update *(gpu :var Vulkan) :void= discard
proc term   *(gpu :var Vulkan) :void= discard
proc init   *(vc :VulkanCfg= VulkanCfg()) :Vulkan=
  new result
  result.instance = instance.create(
    appName    = vc.appName,
    appVers    = vc.appVers,
    engineName = vc.engineName,
    engineVers = vc.engineVers,
    ) # << instance.create( ... )

