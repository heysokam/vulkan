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
#include <vulkan/vulkan_core.h>

namespace cvk {
  using StringList = seq<cstr>;
  using Extensions = cvk::StringList;
  using Allocator  = VkAllocationCallbacks*;
  using Userdata   = void*;
  using Surface    = VkSurfaceKHR;
  enum class Error {
    none = 0,
    extensions, debug, validation,
    instance, surface, device, swapchain,
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
  class Debug { Debug* m = this;
   private:
    cvk::Allocator  A;
    cvk::debug::T   ct;
    cvk::debug::Cfg cfg;
    bool            active;
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
  }; //:: cvk.Debug

  using Version = cdk::Version;
  namespace version {
    using T = cvk::Version;
  } //:: cvk.version

  class Instance { Instance* m = this;
   private:
    cvk::Allocator       A;
    VkInstance           ct;
    VkInstanceCreateInfo cfg;
    cvk::Debug           dbg;
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

    inline VkInstance     handle (void) const { return m->ct; }
    inline cvk::Allocator allo   (void) const { return m->A; }
  }; //:: cvk.Instance
  namespace instance {
    using Flags = VkInstanceCreateFlags;
  } //:: cvk.instance

  namespace surface {
    aliasf(destroy, vkDestroySurfaceKHR);
  } //:: cvk.surface

  namespace device {
    class SwapchainSupport { SwapchainSupport* m = this;
     private:
      VkSurfaceCapabilitiesKHR  caps;
      seq<VkSurfaceFormatKHR>   formats;
      seq<VkPresentModeKHR>     modes;
     public:
      SwapchainSupport(
        VkPhysicalDevice const device,
        cvk::Surface     const surface);

      bool available () { return m->formats.size() > 0 && m->modes.size() > 0; }
    }; //:: cvk.device.SwapchainSupport

    namespace extensions {
      seq<cstr> getList (VkPhysicalDevice const D);
      bool supported (
        VkPhysicalDevice const device,
        seq<cstr>        const exts);
    } //:: cvk.device.extensions

    namespace queue {
      class Families { Families* m = this;
       public:
        seq<VkQueueFamilyProperties>  props;
        cdk::Opt<u32>                 graphics;
        cdk::Opt<u32>                 present;

        Families(
         VkPhysicalDevice const D,
         cvk::Surface     const S);
      }; //:: cvk.device.queue.Families
    };

    namespace physical {
      class Physical { Physical* m = this;
       private:
        cvk::Allocator        A;
        VkPhysicalDevice      ct;
        seq<VkPhysicalDevice> all;
       public:
        Physical(cvk::Instance I, cvk::Surface S, bool forceFirst, cvk::Allocator A);
        Physical() {};
        void destroy (void);
        inline VkPhysicalDevice handle (void) const { return m->ct; }
      }; //:: cvk.device.Physical
      using T = cvk::device::physical::Physical;

      bool isSuitable (
        VkPhysicalDevice               const D,
        cvk::device::queue::Families*  const fams,
        cvk::device::SwapchainSupport* const support);
    }; //:: cvk.device.physical
    using Physical = cvk::device::physical::T;

    class Logical { Logical* m = this;
     private:
      cvk::Allocator     A;
      VkDevice           ct;
      VkDeviceCreateInfo cfg;
     public:
      Logical(cvk::device::Physical D, cvk::Surface S, cvk::Allocator A);
      Logical() {};
      void destroy (void);
      inline VkDevice handle (void) const { return m->ct; }
    }; //:: cvk.device.Logical

    namespace queue {
      namespace entry {
        class Entry { Entry* m = this;
          VkQueue ct;
          u32     id;
         public:
          Entry(
            cvk::device::Logical  const D,
            u32                   const id);
        }; //:: cvk.device.queue.entry.T
      }; //:: cvk.device.queue.entry
      using Entry = cdk::Opt<cvk::device::queue::entry::Entry>;

      class Queue { Queue* m = this;
       private:
        cvk::device::queue::Entry graphics;
        cvk::device::queue::Entry present;
      public:
        Queue(cvk::device::Physical P, cvk::device::Logical L, cvk::Surface S, cvk::Allocator A);
        Queue() {};
      }; //:: cvk.device.Queue
    }; //:: cvk.device.queue
    using Queue = cvk::device::queue::Queue;
  } //:: cvk.device

  class Device {
   private:
    Device* m = this;
    cvk::device::Physical physical;
    cvk::device::Logical  logical;
    cvk::device::Queue    queue;
   public:
    Device(cvk::Instance I, cvk::Surface S, bool forceFirst, cvk::Allocator A);
    Device() {};
    void destroy (void);
  }; //:: cvk.Device
} //:: cvk

