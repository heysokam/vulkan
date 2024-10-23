//:__________________________________________________________________
//  vk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
#include <cstdio>
#define DEBUG
// @deps cdk
#include "cstd.hpp"
#include "csys.hpp"
#include "cvk.hpp"
// @deps Buildsystem SCU
#include "./cstd.cpp"
#include "./csys.cpp"
#define cvk_SCU
#include "./cvk.cpp"


namespace cfg {
const str  label     = "vk+";
const u32  W         = 960;
const u32  H         = 540;
const bool resizable = false;
const cdk::Version appVers    = cdk::version::make(0, 0, 0);
const cdk::Version engineVers = cdk::version::make(0, 0, 0);
}  // namespace cfg

namespace gpu {
  namespace extensions {
    cvk::Extensions getList (void) {
      u32 count = 0;
      cstr_List const required = glfw::vk::instance::getExts(&count);
      if (!required) cvk::fail(cvk::Error::extensions, "Couldn't find any Vulkan Extensions. Vk is not usable (probably not installed)");
      cvk::Extensions result;
      for (Sz id=0; id<count; ++id) result.emplace_back(required[id]);
      for (cstr const& ext : cvk::cfg::instance::extensions) result.emplace_back(ext);
      return result;
    } //:: gpu.extensions.getList
  } //:: gpu.extensions

  class Surface {
   public:
    /// @descr Returns a valid Vulkan Surface for the {@arg window}
    /// @note Makes the library to dependent on GLFW
    Surface(cvk::Instance const I, glfw::Window* const W) {
      VkResult const code = glfwCreateWindowSurface(I.handle(), W, I.allo(), &m->ct);
      if (code != VK_SUCCESS) { cvk::fail(code, "Failed to get the Vulkan Surface from the given GLFW window."); }
    }
    Surface() {}

    void destroy (cvk::Instance const I) {
      cvk::surface::destroy(I.handle(), m->ct, I.allo());
    } //:: gpu.Surface.destroy
   private:
    Surface* m = this;
    VkSurfaceKHR ct = NULL;
  }; //:: gpu.Surface
} //:: gpu

class Gpu {
 public:
  Gpu (str label, cdk::Version appVers, cdk::Version engineVers, csys::Window* win, cvk::Allocator A) {
    m->A     = A;
    m->label = label;
    //____________________________
    // Debug: Configuration
    cvk::debug::Cfg debugCfg = cvk::debug::setup(
      /* flags    */  cvk::cfg::validation::debug::flags,
      /* severity */  cvk::cfg::validation::debug::severity,
      /* msgType  */  cvk::cfg::validation::debug::msgType,
      /* callback */  cvk::debug::cb,
      /* userdata */  nullptr
      ); //:: debugCfg

    //____________________________
    // Instance
    m->instance = cvk::Instance(
      /* appName    */  m->label + str(" | Application"),
      /* appVers    */  appVers,
      /* engineName */  m->label + str(" | Engine"),
      /* engineVers */  engineVers,
      /* apiVers    */  cvk::cfg::version,
      /* flags      */  cvk::cfg::instance::flags,
      /* exts       */  gpu::extensions::getList(),
      /* validate   */  cvk::cfg::validation::active,
      /* layers     */  cvk::cfg::validation::layers,
      /* dbg        */  debugCfg,
      /* A          */  m->A
      );

    //____________________________
    // Device & Swapchain
    m->surface = gpu::Surface(m->instance, win->ct);

  }; //:: Gpu::Constructor

  void update(void) {
    (void)m;
  };

  void term () {
    // m->device.destroy(m->instance);
    m->surface.destroy(m->instance);
    m->instance.destroy();
  } //:: Gpu.term()

 private:
  Gpu* m = this;
  cvk::Allocator A;
  str            label;
  cvk::Instance  instance;
  gpu::Surface   surface;
  // cvk::Device    device;
  // cvk::Swapchain swapchain;

};

//______________________________________
// @section Entry Point
//____________________________
namespace cli { void report (void); }
i32 main (i32 const argc, cstr argv[argc]) {
  cli::report();
  csys::System sys(cfg::label + " | Example", cfg::W, cfg::H, cfg::resizable);
  Gpu gpu(cfg::label, cfg::appVers, cfg::engineVers, &sys.win, nullptr);
  while (!sys.close()) {
    sys.update();
    gpu.update();
  }
  gpu.term();
  return 0;
} //:: main


//__________________
namespace cli {
inline void report (void) {
  if (cdk::debug) echo("Hello cvk+ Entry with -DDEBUG. Validation Layers are active.");
  else            echo("Hello cvk+ Entry. Validation Layers are inactive.");
}
} // namespace cli

