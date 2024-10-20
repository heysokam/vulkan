//:___________________________________________________________________
//  cvk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
#pragma once
// @deps cdk
#include "./alias.hpp"
#include "./cstd.hpp"
#include "./cstr.hpp"
// @deps External
#include <vulkan/vulkan.h>

namespace cvk {
  using StringList = seq<cstr>;
  using Extensions = cvk::StringList;
  using Allocator  = VkAllocationCallbacks*;
  using Userdata   = void*;
  enum class Error {
    none = 0,
    extensions, debug, validation,
    instance,
  };
  aliasf(fail, cdk::fail);

  namespace debug {
    using Flags    =  VkDebugUtilsMessengerCreateFlagsEXT;
    using Severity =  VkDebugUtilsMessageSeverityFlagsEXT;
    using MsgType  =  VkDebugUtilsMessageTypeFlagsEXT;
    using T        =  VkDebugUtilsMessengerEXT;
    using Cfg      =  VkDebugUtilsMessengerCreateInfoEXT;
    using Callback =  PFN_vkDebugUtilsMessengerCallbackEXT;

    /// @internal
    /// @descr Configures the required data for Vulkan to send back debug information with the Messenger Extension.
    inline cvk::debug::Cfg setup (
        cvk::debug::Flags    const flags,
        cvk::debug::Severity const severity,
        cvk::debug::MsgType  const msgType,
        cvk::debug::Callback const callback,
        cvk::Userdata        const userdata
      ) {
      return (VkDebugUtilsMessengerCreateInfoEXT){
        .sType           = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
        .pNext           = NULL,
        .flags           = flags,
        .messageSeverity = severity,
        .messageType     = msgType,
        .pfnUserCallback = callback,
        .pUserData       = userdata,
        };
    } //:: cvk.debug.setup

    inline VkBool32 cb (
        VkDebugUtilsMessageSeverityFlagBitsEXT const        severity,
        VkDebugUtilsMessageTypeFlagsEXT        const        types,
        VkDebugUtilsMessengerCallbackDataEXT   const* const cbdata,
        void*                                  const        userdata
      ) {
      (void)userdata; /*discard*/
      printf("[Vulkan Validation] (%d %d) : %s\n", types, severity, cbdata->pMessage);
      return false;
    } //:: cvk.debug.cb
  }; //:: cvk.debug
  namespace validation {
    inline void checkSupport (
        bool const validate,
        seq<cstr> const list
      ) {
      if (!validate) return;
      u32 count;
      vkEnumerateInstanceLayerProperties(&count, NULL);
      VkLayerProperties* layers = (VkLayerProperties*)calloc(count, sizeof(VkLayerProperties));
      vkEnumerateInstanceLayerProperties(&count, layers);
      bool found = false;
      for(size_t layerId = 0; layerId < count; ++layerId) {
        VkLayerProperties const layer = layers[layerId];
        for(size_t vlayerID = 0; vlayerID < list.size(); ++vlayerID) {
          if (cstring::eq(layer.layerName, list.at(vlayerID))) { found = true; goto end; }
        }
      } end:
      free(layers);
      if (!found) cvk::fail(cvk::Error::validation, "One or more of the validation layers requested is not available in this system.");
    }
  }

  class Instance;
  class Debug {
    Debug* m = this;
   public:
    /// @descr Creates a Vulkan Debug Messenger using the given {@arg cfg} configuration
    Debug(
      VkInstance      const I,
      cvk::debug::Cfg const cfg,
      bool            const active,
      cvk::Allocator  const A
      );
    Debug() {};
    ~Debug() {};
    /// @descr Destroys a Vulkan Debug Messenger object created with {@link cvk::Debug constructor}
    void destroy (cvk::Instance const I);
   private:
    cvk::Allocator  A;
    cvk::debug::T   ct;
    cvk::debug::Cfg cfg;
    bool            active;
  }; //:: cvk.Debug

  using Version = cdk::Version;
  namespace version {
    using T = cvk::Version;
  } //:: cvk.version

  class Instance {
   public:
    Instance(
      str                   const appName,
      cvk::Version          const appVers,
      str                   const engineName,
      cvk::Version          const engineVers,
      cvk::Version          const apiVers,
      VkInstanceCreateFlags const flags,
      seq<cstr>             const exts,
      bool                  const validate,
      seq<cstr>             const layers,
      cvk::debug::Cfg       const dbg,
      cvk::Allocator        const A
      );
    Instance() {};

    void destroy (void);

    inline VkInstance handle (void) const { return ct; }
   private:
    Instance* m = this;
    cvk::Allocator       A;
    VkInstance           ct;
    VkInstanceCreateInfo cfg;
    cvk::Debug           dbg;
  }; //:: cvk.Instance
  namespace instance {
    using Flags = VkInstanceCreateFlags;
  } //:: cvk.instance
} //:: cvk

