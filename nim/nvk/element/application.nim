import ../vulkan
import ../cfg

proc info *(
  appName    :string;
  appVers    :uint32;
  engineName :string;
  engineVers :uint32;
  ) :ref VkApplicationInfo=
  new result
  result = VkApplicationInfo(
    sType              : VK_STRUCTURE_TYPE_APPLICATION_INFO,
    pNext              : nil,
    pApplicationName   : appName.cstring,
    applicationVersion : appVers,
    pEngineName        : engineName.cstring,
    engineVersion      : engineVers,
    apiVersion         : cfg.ApiVersion,
    ) # << VkApplicationInfo( ... )

