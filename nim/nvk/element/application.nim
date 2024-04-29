import ../vulkan as vk
import ../cfg

proc info *(
  appName    :string;
  appVers    :uint32;
  engineName :string;
  engineVers :uint32;
  ) :vk.ApplicationInfo=
  result = vk.ApplicationInfo(
    sType              : vk.StructureType_ApplicationInfo,
    pNext              : nil,
    pApplicationName   : appName.cstring,
    applicationVersion : appVers,
    pEngineName        : engineName.cstring,
    engineVersion      : engineVers,
    apiVersion         : cfg.ApiVersion.uint32,
    ) # << vk.ApplicationInfo( ... )

