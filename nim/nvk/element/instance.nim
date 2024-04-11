#:___________________________________________________
#  nvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
import ../vulkan
import ./application

proc info *(
  app   :ptr VkApplicationInfo;
  flags :VkInstanceCreateFlags;
  ) :VkInstanceCreateInfo=
  VkInstanceCreateInfo(
    sType                   : VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
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
  ) :VkInstance=
  var info = instance.info(
    app          = application.info(
      appName    = appName,
      appVers    = appVers,
      engineName = engineName,
      engineVers = engineVers,
      ) # << application.info( ... ),
    ) # instance.info( ... )
