#:___________________________________________________
#  nvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
import ../vulkan as vk
import ./application

proc info *(
  app   :ptr vk.ApplicationInfo;
  flags :vk.InstanceCreateFlags;
  ) :vk.InstanceCreateInfo=
  vk.InstanceCreateInfo(
    sType                   : vk.StructureType_Instance_CreateInfo,
    pNext                   : nil,
    flags                   : flags,
    pApplicationInfo        : app,
    enabledLayerCount       : 0,
    ppEnabledLayerNames     : nil,
    enabledExtensionCount   : 0,
    ppEnabledExtensionNames : nil,
    )

proc create *(
  appName    :string;
  appVers    :uint32;
  engineName :string;
  engineVers :uint32;
  ) :vk.Instance=
  var info = instance.info(
    app          = vaddr application.info(
      appName    = appName,
      appVers    = appVers,
      engineName = engineName,
      engineVers = engineVers,
      ), # << application.info( ... )
    flags = 0 as vk.InstanceCreateFlags,
    ) # instance.info( ... )
