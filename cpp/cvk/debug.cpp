#include "../cvk.hpp"

namespace vk {
  namespace debug {
    PFN_vkCreateDebugUtilsMessengerEXT  create  = nullptr;
    PFN_vkDestroyDebugUtilsMessengerEXT destroy = nullptr;
  }; //:: vk.debug
}; //:: vk

namespace cvk {
  namespace debug {
    namespace getFn {
      // Allow soft-type casting Vulkan function pointers for these functions
      //   cvk_debug_getFn_create
      //   cvk_debug_getFn_destroy
      #pragma clang diagnostic push
      #pragma clang diagnostic ignored "-Wcast-function-type-strict"

      /// @internal
      /// @descr Stores the Vulkan Debug Messenger create function into the {@link vk::debug} vtable
      static void create (VkInstance const I) {
        if (vk::debug::create) return;
        if (!vk::debug::create) vk::debug::create = (PFN_vkCreateDebugUtilsMessengerEXT)vkGetInstanceProcAddr(I, "vkCreateDebugUtilsMessengerEXT");
        if (!vk::debug::create) cvk::fail(cvk::Error::debug, "Failed to get the Vulkan Debug Messenger create function");
      } //:: cvk.debug.getFn.create

      /// @internal
      /// @descr Stores the Vulkan Debug Messenger destroy function into the {@link vk::debug} vtable
      static void destroy (VkInstance const I) {
        if (vk::debug::destroy) return;
        if (!vk::debug::destroy) vk::debug::destroy = (PFN_vkDestroyDebugUtilsMessengerEXT)vkGetInstanceProcAddr(I, "vkDestroyDebugUtilsMessengerEXT");
        if (!vk::debug::destroy) cvk::fail(cvk::Error::debug, "Failed to get the Vulkan Debug Messenger destroy function");
      } //:: cvk.debug.getFn.destroy

      // Stop->  diagnostic ignored "-Wcast-function-type-strict"
      #pragma clang diagnostic pop
    }; //:: cvk.debug.getFn
  }; //:: cvk.debug
}; //:: cvk

cvk::Debug::Debug(
    VkInstance      const I,
    cvk::debug::Cfg const cfg,
    bool            const active,
    cvk::Allocator  const A
  ) {
  if (!active) return;
  m->A      = A;
  m->cfg    = cfg;
  m->active = active;
  cvk::debug::getFn::create(I);
  VkResult const code = vk::debug::create(I, &m->cfg, m->A, &m->ct);
  if (code != VK_SUCCESS) cvk::fail(code, "Failed to create the Vulkan Debug Messenger");
}

void cvk::Debug::destroy (cvk::Instance const I) {
  if (!m->active) return;
  cvk::debug::getFn::destroy(I.handle());
  vk::debug::destroy(I.handle(), m->ct, m->A);
};

