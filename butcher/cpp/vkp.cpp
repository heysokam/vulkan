//:__________________________________________________________________
//  vk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./vkp.hpp"

#include <stdio.h>
#define HERE printf("HERE------------->    (file:%s  line:%d)\n", __FILE__, __LINE__);

namespace cvk {
struct SwapchainT {
  SwapchainCT ct;
  Format      format;
  vec<Image>  images;
  vec<View>   views;
};
typedef SwapchainT* Swapchain;

class Gpu {
 public:
  /* Gpu(str label, u32 appVers, u32 engineVers, w::Window* win, cvk::Allocator allocator); */
  /* ~Gpu(); */
  /* void update(void); */

 private:
  /* Gpu*                m = this; */
  /* str                 label; */
  /* str                 appName    = ""; */
  /* u32                 appVers    = 0; */
  /* str                 engineName = ""; */
  /* u32                 engineVers = 0; */
  /* cvk::Instance       instance   = nullptr; */
  /* cvk::Allocator      allocator  = nullptr; */
  /* cvk::DebugMessenger dbg        = nullptr; */
  /* cvk::Surface        surface    = nullptr; */
  /* cvk::DeviceGPU      deviceGPU  = nullptr; */
  /* cvk::Device         device     = nullptr; */
  /* cvk::Swapchain      swapchain  = nullptr; */
};
Gpu::Gpu(str label, u32 appVers, u32 engineVers, w::Window* win, cvk::Allocator allocator = nullptr) {
  /* //________________________________________________ */
  /* // Application Configuration */
  /* m->label      = label; */
  /* m->appName    = m->label + str(" | Application"); */
  /* m->appVers    = appVers; */
  /* m->engineName = m->label + str(" | Engine"); */
  /* m->engineVers = engineVers; */
  /* //________________________________________________ */
  /* // Allocator.assign() */
  /* m->allocator  = allocator; */
  //________________________________________________
  // Instance.create()
  vkb::InstanceBuilder instBuilder;  // clang-format off
  vkb::Instance instRes = instBuilder.require_api_version(1,1,0)
    .request_validation_layers(true)
    .use_default_debug_messenger()
    .set_app_name(m->appName.data())
    .set_engine_name(m->engineName.data())
    .build().value();
  m->instance = instRes.instance;
  m->dbg      = instRes.debug_messenger;  // clang-format on
  //________________________________________________
  // Surface.get()
  m->surface = cvk::getSurface(m->instance, win->ct, m->allocator);
  //________________________________________________
  // PhysicalDevice.create()
  vkb::PhysicalDeviceSelector gpuSel { instRes };  // clang-format off
  vkb::PhysicalDevice gpuRes = gpuSel
    .set_minimum_version(1,1)
    .set_surface(m->surface)
    .select().value();  // clang-format on
  m->deviceGPU = gpuRes.physical_device;
  //________________________________________________
  // Device.create()
  vkb::DeviceBuilder devBuilder { gpuRes };
  vkb::Device        devRes = devBuilder.build().value();
  m->device                 = devRes.device;
  //________________________________________________
  // Swapchain.create()
  vkb::SwapchainBuilder swcBuilder { m->deviceGPU, m->device, m->surface };  // clang-format off
  vkb::Swapchain swcRes = swcBuilder
    .use_default_format_selection()
    .set_desired_present_mode(VK_PRESENT_MODE_FIFO_KHR)
    .set_desired_extent(win->size.x, win->size.y)
    .build().value();  // clang-format on
  m->swapchain         = new SwapchainT;
  m->swapchain->ct     = swcRes.swapchain;
  m->swapchain->images = swcRes.get_images().value();
  m->swapchain->views  = swcRes.get_image_views().value();
  m->swapchain->format = swcRes.image_format;
}
Gpu::~Gpu(void) {
  cvk::swapchain::destroy(m->device, m->swapchain->ct, m->allocator);
  for (auto view : m->swapchain->views) cvk::view::destroy(m->device, view, m->allocator);
  cvk::device::destroy(m->device, m->allocator);
  cvk::surface::destroy(m->instance, m->surface, m->allocator);
  vkb::destroy_debug_utils_messenger(m->instance, m->dbg);
  cvk::instance::destroy(m->instance, m->allocator);
}
void Gpu::update(void) {}
}  // namespace cvk


namespace cvk {
namespace args {
// clang-format off
struct init {
  str label;
  u32 appVersion; u32 engineVersion;
  };  /// r::init( ... )
// clang-format on
}  // namespace args

// Version Generation
inline u32 makeVersion(const u32 major, const u32 minor, const u32 patch) { return VK_MAKE_VERSION(major, minor, patch); }
inline u32 apiVersion(const u32 major, const u32 minor, const u32 patch) { return VK_MAKE_API_VERSION(0, major, minor, patch); }

#define chk(x)                                                     \
  {                                                                \
    VkResult code = x;                                             \
    if (code) {                                                    \
      std::cout << "Detected Vulkan error: " << code << std::endl; \
      abort();                                                     \
    }                                                              \
  }
}  // namespace cvk

