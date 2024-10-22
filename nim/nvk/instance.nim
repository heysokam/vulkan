#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps vulkan
from ../nvulkan as vk import vaddr
# @deps nvk
import ./allocator
import ./version
import ./cfg
import ./debug
import ./validation
import ./check

type Instance * = object
  A    :Allocator
  ct   :vk.Instance
  cfg  :vk.instance.Cfg
  dbg  :Debug

proc create *(
    appName    : string  = cfg.default_appName,
    appVers    : Version = version.new(0, 0, 0),
    engineName : string  = cfg.default_engineName,
    engineVers : Version = version.new(0, 0, 0),
    exts       : seq[vk.String];
    dbg        : debug.Cfg;
    A          : Allocator;
  ) :Instance=
  result.A   = A
  result.cfg = vk.instance.Cfg(
    next         : cast[pointer](dbg.addr),
    flags        : cfg.instance_flags,
    appCfg       : vaddr vk.application.Cfg(
      appName    : vk.String(appName),
      appVers    : appVers,
      engineName : vk.String(engineName),
      engineVers : engineVers,
      apiVers    : cfg.api_version,
      ), #:: result.cfg.appCfg
    layerCount   : cfg.validation_layers.len.uint32,
    layers       : cast[vk.StringList](cfg.validation_layers[0].addr),
    extCount     : exts.len.uint32,
    exts         : cast[vk.StringList](exts[0].addr),
    ) #:: result.cfg
  validation.checkSupport(cfg.validation_active, cfg.validation_layers)
  check.ok(vk.instance.create(result.cfg.addr, result.A.vk, result.ct.addr))
  result.dbg = Debug.create(
    I      = result.ct,
    cfg    = dbg,
    active = cfg.validation_active,
    A      = result.A,
    ) #:: result.dbg

proc destroy *(
    I : Instance;
  ) :void=
  I.dbg.destroy(I.ct)
  vk.instance.destroy(I.ct, I.A.vk);

