//:_____________________________________________________________________________________
//  Vulkan: All-the-Things  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:_____________________________________________________________________________________
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("./zstd.zig");
const zsys = @import("./zsys.zig");
const zvk  = @import("./zvk.zig").zvk;


const shd = struct {
  const vert align(@alignOf(u32)) = @embedFile("shd_vert").*;
  const frag align(@alignOf(u32)) = @embedFile("shd_frag").*;
};
const appName = "Zig | Vulkan-All-the-Things";
var size      = zvk.Size{.width= 960, .height= 540};

//______________________________________
// @section Entry Point
//____________________________
pub fn main () !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = zvk.Allocator.create(arena.allocator());

  try zstd.echo("Hello zvk Entry");
  try zstd.echo(appName);
  var sys = try zsys.init(size.width, size.height, appName);
  var gpu = try tut.Gpu.init(.{
    .appName    = appName,
    .appVers    = zvk.version.new(0, 0, 1),
    .engineName = "zvk | Triangle Engine",
    .engineVers = zvk.version.new(0, 0, 1),
    }, sys.win.ct, A);
  while (!sys.close()) {
    sys.update();
    try gpu.update();
    }
  try gpu.term();
  sys.term();
} //:: main


//______________________________________
// @section Core Logic
//____________________________
pub const tut = struct {
  const glfw = @import("./zglfw.zig");

  pub const render = struct {
    pub const Clear = struct {
      A     : zvk.Allocator,

      pub fn create (
          S : zgpu.System,
        ) !tut.render.Clear {
        const result = tut.render.Clear{
          .A     = S.A,
          }; //:: result
        return result;
      } //:: tut.render.Clear.create

      pub fn destroy (
          R : *tut.render.Clear,
          S : zgpu.System,
        ) void {_=R; _=S;
      } //:: tut.render.Clear.destroy

      pub fn update (
          R : *tut.render.Clear,
          S : zgpu.System,
        ) !void {_=R; _=S;
      } //:: tut.render.Clear.update
    }; //:: tut.render.Clear
  }; //:: tut.render

  pub const Gpu = struct {
    system : zgpu.System,
    render : tut.render.Clear,  // @todo: Make the Gpu typename specific to the Renderer

    pub fn update (gpu :*Gpu) !void {
      try gpu.render.update(gpu.system);
    } //:: zgpu.Gpu.update

    pub fn init (in:struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers, },
        window     : ?*glfw.Window,
        A          : zvk.Allocator,
      ) !tut.Gpu {
      var result = Gpu{.system=undefined, .render=undefined};
      result.system = try zgpu.System.create(.{
        .appName    = in.appName,
        .appVers    = in.appVers,
        .engineName = in.engineName,
        .engineVers = in.engineVers,
        }, window, A);
      result.render = try tut.render.Clear.create(result.system);
      return result;
    } //:: zgpu.Gpu.init

    pub fn term (gpu :*Gpu) !void {
      try gpu.system.waitIdle();
      gpu.render.destroy(gpu.system);
      try gpu.system.destroy();
    } //:: Gpu.term
  }; //:: Gpu
}; //:: app


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pub const zgpu = struct {
  const glfw = @import("./zglfw.zig");

  //______________________________________
  // @section zvk Forward Exports
  //____________________________
  pub const Allocator = zvk.Allocator;
  pub const String    = zvk.String;
  pub const Size      = zvk.Size;
  pub const SpirV     = zvk.SpirV;
  pub const version   = zvk.version;
  pub const Version   = zvk.Version;
  pub const Surface   = zvk.Surface;
  pub const Swapchain = zvk.Swapchain;

  //______________________________________
  // @section Configuration
  //____________________________
  pub const cfg = struct {
    pub const default = struct {
      pub const appName    = "z*gpu | Application";
      pub const appVers    = zgpu.version.new(0, 0, 0);
      pub const engineName = "z*gpu | Engine";
      pub const engineVers = zgpu.version.new(0, 0, 0);
    }; //:: zgpu.cfg.default

    pub const render = struct {
      pub const frame = struct {
        /// @descr Number of simultaneous frames that the Renderers will have by default.
        pub const count = 2;
      }; //:: zgpu.cfg.frame
    }; //:: zgpu.cfg.render
  }; //:: zgpu.cfg

  pub const System = struct {
    A         :zvk.Allocator,
    instance  :zvk.Instance,
    dbg       :zvk.Debug,
    // surface   :zvk.Surface,
    // device    :zvk.Device,
    // swapchain :zvk.Swapchain,

    //______________________________________
    // @section System: Surface
    //____________________________
    // pub const surface = struct {
    //   /// @descr Creates a native Surface that Vulkan can draw into
    //   /// @note Makes this library dependent on GLFW
    //   pub fn create (
    //       I : zvk.Instance,
    //       W : ?*glfw.Window,
    //       A : zvk.Allocator,
    //     ) !zvk.Surface {
    //     var result :zvk.Surface= null;
    //     try zvk.vk.ok(glfw.vk.surface.create(@ptrCast(I.ct), W, @ptrCast(A.vk), @ptrCast(&result)));
    //     return result;
    //   } //:: zgpu.System.surface.create
    //
    //   pub fn destroy (
    //       I : zvk.Instance,
    //       S : zvk.Surface,
    //       A : zvk.Allocator,
    //     ) void {
    //     zvk.surface.destroy(I.ct, S, A.vk);
    //   } //:: zgpu.System.surface.destroy
    // }; //:: zgpu.System.surface

    //______________________________________
    // @section System: Swapchain
    //____________________________
    // pub const swapchain = struct {
    //   /// @descr Returns a Swapchain object with the size of the {@arg window}
    //   /// @note Makes this library dependent on GLFW
    //   pub fn create (
    //       D : zvk.Device,
    //       S : zvk.Surface,
    //       W : ?*glfw.Window,
    //       A : zvk.Allocator,
    //     ) !zvk.Swapchain {
    //     var sz = zvk.Size{};
    //     glfw.framebuffer.size(W, @ptrCast(&sz.width), @ptrCast(&sz.height));
    //     return zvk.Swapchain.create(D, S, sz, A);
    //   } //:: zgpu.System.swapchain.create
    // }; //:: zgpu.System.swapchain
    //

    //______________________________________
    // @section System Management
    //____________________________
    fn empty () zgpu.System { return zgpu.System{
      .A         = undefined,
      .instance  = undefined,
      .dbg       = undefined,
      // .surface   = undefined,
      // .device    = undefined,
      // .swapchain = undefined, };
      };
    } //:: zgpu.System.empty

    pub fn create (in:struct {
        appName    : zgpu.String  = zgpu.cfg.default.appName,
        appVers    : zgpu.Version = zgpu.cfg.default.appVers,
        engineName : zgpu.String  = zgpu.cfg.default.engineName,
        engineVers : zgpu.Version = zgpu.cfg.default.engineVers, },
        window     : ?*glfw.Window,
        A          : zgpu.Allocator,
      ) !zgpu.System {_=window;
      const debugCfg = zvk.validation.debug.setup(.{
        .flags     = zvk.cfg.debug.flags,
        .severity  = zvk.cfg.debug.severity,
        .msgType   = zvk.cfg.debug.msgType,
        .callback  = &zvk.validation.debug.callback,
        .userdata  = null,
        });
      var result = zgpu.System.empty();
      result.A = A;
      result.instance = try zvk.Instance.create(.{
        .appName    = in.appName,
        .appVers    = in.appVers,
        .engineName = in.engineName,
        .engineVers = in.engineVers, },
        &debugCfg, result.A);
      result.dbg       = try zvk.validation.debug.create(result.instance, &debugCfg, result.A);
      // result.surface   = try tut.System.surface.create(result.instance, window, result.A);
      // result.device    = try zvk.Device.create(result.instance, result.surface, result.A);
      // result.swapchain = try tut.System.swapchain.create(result.device, result.surface, window, A);
      return result;
    } //:: zgpu.System.create

    pub fn destroy (S :*System) !void {
      // S.swapchain.destroy(S.device);
      // tut.System.surface.destroy(S.instance, S.surface, S.A);
      // S.device.destroy();
      try zvk.validation.debug.destroy(S.instance, S.dbg, S.A);
      S.instance.destroy();
    } //:: zgpu.System.destroy

    pub fn waitIdle (S :*const System) !void { _=S; } //try S.device.waitIdle(); }
  }; //:: zgpu.System
}; //:: zgpu

