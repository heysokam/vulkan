//:__________________________________________________________________
//  vk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
#include "cglfw.hpp"
#include <cstddef>
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
using Size = cvk::Size;

const str  label     = "vk+";
      Size size      = {.width= 960, .height= 540};
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
    Surface(cvk::Instance const I, glfw::Window* const W, cvk::Allocator A) {
      m->A = A;
      VkResult const code = glfwCreateWindowSurface(I.handle(), W, I.allo(), &m->ct);
      if (code != VK_SUCCESS) { cvk::fail(code, "Failed to get the Vulkan Surface from the given GLFW window."); }
    }
    Surface() {}

    void destroy (cvk::Instance* const I) {
      cvk::surface::destroy(I->handle(), m->ct, m->A);
    } //:: gpu.Surface.destroy

    cvk::Surface handle() { return m->ct; };
   private:
    Surface* m = this;
    cvk::Allocator A  = NULL;
    cvk::Surface   ct = NULL;
  }; //:: gpu.Surface

  namespace swapchain {
    cvk::Swapchain create (
        cvk::Device*   const D,
        glfw::Window*  const win,
        cvk::Surface   const S,
        cvk::Size*     const size,
        cvk::Allocator const A
      ) {
      i32 W = 0; i32 H = 0;
      glfwGetFramebufferSize(win, &W, &H);
      size->width  = (u32)W;
      size->height = (u32)H;
      return cvk::Swapchain(D, S, size, A);
    } //:: gpu.swapchain.create
  } //:: gpu.swapchain
} //:: gpu

class Gpu { Gpu* m = this;
 private:
  cvk::Allocator A;
  str            label;
  cvk::Instance  instance;
  gpu::Surface   surface;
  cvk::Device    device;
  cvk::Swapchain swapchain;

 public:
  Gpu (str label, cdk::Version appVers, cdk::Version engineVers, csys::Window* win, cvk::Size* size, cvk::Allocator A) {
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
    m->surface   = gpu::Surface(m->instance, win->ct, m->A);
    m->device    = cvk::Device(&m->instance, m->surface.handle(), cvk::cfg::device::forceFirst, m->A);
    m->swapchain = gpu::swapchain::create(&m->device, win->ct, m->surface.handle(), size, m->A);
  }; //:: Gpu::Constructor

  void update(void) {
    (void)m;
  };

  void term () {
    m->swapchain.destroy(&m->device);
    m->device.destroy();
    m->surface.destroy(&m->instance);
    m->instance.destroy();
  } //:: Gpu.term()
}; //:: Gpu

//______________________________________
// @section Entry Point
//____________________________
namespace cli { void report (void); }
i32 main (i32 const argc, cstr argv[argc]) {
  cli::report();
  csys::System sys(cfg::label + " | Example", cfg::size.width, cfg::size.height, cfg::resizable);
  Gpu gpu(cfg::label, cfg::appVers, cfg::engineVers, &sys.win, &cfg::size, nullptr);
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

