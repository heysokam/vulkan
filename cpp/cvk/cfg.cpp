//:___________________________________________________________________
//  cvk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
#include "../cvk.hpp"

namespace cvk {
  namespace cfg {
    constexpr cvk::Version version = cdk::version::make_api(0, 1,3,0);
    constexpr bool debug = cdk::debug;

    //______________________________________
    // @section Configuration: Validation Layers and Debug Messenger
    //____________________________
    namespace validation {
      constexpr bool active = cdk::debug;
      seq<cstr> const layers = {(cvk::cfg::validation::active) ? "VK_LAYER_KHRONOS_validation" : ""};

      namespace debug {
        constexpr cvk::debug::Flags flags = 0;
        constexpr cvk::debug::Severity severity =
          VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT |
          VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
          VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
        constexpr cvk::debug::MsgType msgType =
          VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
          VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
          VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
      } //:: cvk.cfg.validation.debug
    } //:: cvk.cfg.validation

    //______________________________________
    // @section Configuration: Instance
    //____________________________
    namespace instance {
      constexpr cvk::instance::Flags flags = (cdk::Mac) ? VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR : 0;
      seq<cstr> const extensions = {
        VK_EXT_DEBUG_UTILS_EXTENSION_NAME,
        #if defined(macosx)
        VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME,
        #endif
      };
    } //:: cvk.cfg.instance


    //______________________________________
    // @section Configuration: Device
    //____________________________
    namespace device {
      constexpr bool forceFirst = true;
    } //:: cvk.cfg.device
  } //:: cvk.cfg
} //:: cvk

