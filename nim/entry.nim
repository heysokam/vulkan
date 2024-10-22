#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps ndk
from nglfw as glfw import nil
import nstd/types
import nsys
import ./nvk

type Gpu * = object
  A         :nvk.Allocator
  instance  :nvk.Instance

proc gpu_extensions_getList *() :seq[nvk.String]=
  var count :u32= 0
  let required = glfw.getRequiredInstanceExtensions(count.addr)
  if required.isNil: quit "Couldn't find any Vulkan Extensions. Vk is not usable (probably not installed)"
  for id in 0..count:  result.add( nvk.String(required[id]) )
  for ext in nvk.cfg.instance_extensions: result.add ext


proc init *(_:typedesc[Gpu];
    appName    : string      = nvk.cfg.default_appName;
    appVers    : nvk.Version = nvk.version.new(0, 0, 0);
    engineName : string      = nvk.cfg.default_engineName;
    engineVers : nvk.Version = nvk.version.new(0, 0, 0);
  ) :Gpu=
  result.A        = nvk.Allocator()
  result.instance = nvk.instance.create(
    appName    = appName,
    appVers    = appVers,
    engineName = engineName,
    engineVers = engineVers,
    exts       = gpu_extensions_getList(),
    A          = result.A,
    dbg        = nvk.debug.Cfg(
      flags    : nvk.cfg.validation_debug_flags,
      severity : nvk.cfg.validation_debug_severity,
      msgType  : nvk.cfg.validation_debug_msgType,
      callback : nvk.debug.cb,
      userdata : nil,
      ), #:: result.instance.dbg
    ) #:: result.instance
proc term   *(gpu :Gpu) :void= discard gpu
proc update *(gpu :Gpu) :void= discard gpu


#_______________________________________
# @section Entry Point
#_____________________________
when isMainModule:
  const appName = "Nim | Vulkan-All-the-Things";

  echo "Hello nvk Entry"
  var sys = nsys.init(960,540)
  var gpu = Gpu.init(
    appName    = appName,
    appVers    = nvk.version.new(0, 0, 1),
    engineName = "zvk | Triangle Engine",
    engineVers = nvk.version.new(0, 0, 1),
    ) #:: gpu
  while not sys.close():
    sys.update()
    gpu.update()
  gpu.term()
  sys.term()

