#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps ndk
from ../nvulkan as vk import nil
from nstd import debug


#______________________________________
# @section Configuration: n*vk General Options
#____________________________
const Prefix * = "nvk"
let api_version *:vk.Version= vk.version.api(0, 1,3,0)


#______________________________________
# @section Configuration: General Default Values
#____________________________
const default_appName    * = cfg.Prefix&" | Applicacion"
const default_engineName * = cfg.Prefix&" | Engine"


#______________________________________
# @section Configuration: Debug & Validation Layers
#____________________________
const validation_active * = nstd.debug
const validation_layers * = when nstd.debug: @[vk.String("VK_LAYER_KHRONOS_validation")] else: @[]
const validation_debug_flags * = vk.debug.Flags(0)
const validation_debug_severity *:vk.debug.Severities= {
  vk.debug.Severity.verbose,
  vk.debug.Severity.warning,
  vk.debug.Severity.error,
  } #:: nvk.cfg.validation.debug.severity
const validation_debug_msgType *:vk.debug.MsgTypes= {
  vk.debug.MsgType.general,
  vk.debug.MsgType.validation,
  vk.debug.MsgType.performance,
  } #:: nvk.cfg.validation.debug.mgsType


#______________________________________
# @section Configuration: Instance
#____________________________
const instance_flags *:vk.instance.Flags= when defined(macosx): {vk.instance.Flag.portability} else: {}
const instance_extensions * =
  when defined(macosx): @[vk.extensions.Debug, vk.extensions.Portability]
  else                : @[vk.extensions.Debug]


#______________________________________
# @section Configuration: Device
#____________________________
const device_forceFirst * = true

