#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps std
from std/strformat import fmt
# @deps vulkan
from ../nvulkan as vk import `$`
# @deps nvk
import ./allocator

type Flags      * = vk.debug.Flags
type Severity   * = vk.debug.Severity
type Severities * = vk.debug.Severities
type MsgType    * = vk.debug.MsgType
type MsgTypes   * = vk.debug.MsgTypes
type Callback   * = vk.debug.Callback
type Cfg        * = vk.debug.Cfg

type Debug * = object
  A       :Allocator
  ct      :vk.debug.Debug
  cfg     :vk.debug.Cfg
  active  :bool


proc cb *(
    severity : vk.debug.Severity;
    msgType  : vk.debug.MsgTypes_C;
    cbData   : vk.debug.CallbackData_C;
    userdata : pointer;
  ) :uint32 {.cdecl.}=
  discard userData
  let data = cast[ptr vk.debug.CallbackData](cbData)
  echo fmt"[vulkan | {vk.debug.MsgType(msgType)}.{$severity}] : {data.msg}"

proc create *(_:typedesc[Debug];
    I      : vk.Instance;
    cfg    : debug.Cfg;
    active : bool;
    A      : Allocator;
  ) :Debug=
  result.A      = A
  result.cfg    = cfg
  result.active = active
  result.ct     = vk.debug.create(I, result.cfg.addr, result.A.vk)


proc destroy *(
    D : Debug;
    I : vk.Instance;
  ) :void=
  if D.active: return
  vk.debug.destroy(I, D.ct, D.A.vk)

