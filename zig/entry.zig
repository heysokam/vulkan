//:_____________________________________________________________________________________
//  Vulkan: All-the-Things  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:_____________________________________________________________________________________
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("./zstd.zig");
const zsys = @import("./zsys.zig");


const shd = struct {
  const vert align(@alignOf(u32)) = @embedFile("shd_vert").*;
  const frag align(@alignOf(u32)) = @embedFile("shd_frag").*;
};
const appName = "Zig | Vulkan-All-the-Things";
var size      = zgpu.Size{.width= 960, .height= 540};

//______________________________________
// @section Entry Point
//____________________________
pub fn main () !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = zgpu.Allocator.create(arena.allocator());

  try zstd.echo("Hello zvk Entry");
  try zstd.echo(appName);
  var sys = try zsys.init(size.width, size.height, appName);
  var gpu = try tut.Gpu.init(.{
    .appName    = appName,
    .appVers    = zgpu.version.new(0, 0, 1),
    .engineName = "zvk | Triangle Engine",
    .engineVers = zgpu.version.new(0, 0, 1),
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
  const zvk  = @import("./zvk.zig").zvk;

  pub const render = struct {
    pub const Clear = struct {
      A     : zgpu.Allocator,

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

    pub const Triangle10 = struct {
      A     : zgpu.Allocator,
      pso   : zgpu.pipeline.Graphics,

      pub fn create (
          S : zgpu.System,
        ) !tut.render.Triangle10 {
        const tri_vert  :zvk.SpirV align(@alignOf(u32))= &.{0x07230203,0x00010000,0x000d000b,0x00000036,0x00000000,0x00020011,0x00000001,0x0006000b,0x00000001,0x4c534c47,0x6474732e,0x3035342e,0x00000000,0x0003000e,0x00000000,0x00000001,0x0008000f,0x00000000,0x00000004,0x6e69616d,0x00000000,0x00000022,0x00000026,0x00000031,0x00030003,0x00000002,0x000001c2,0x000a0004,0x475f4c47,0x4c474f4f,0x70635f45,0x74735f70,0x5f656c79,0x656e696c,0x7269645f,0x69746365,0x00006576,0x00080004,0x475f4c47,0x4c474f4f,0x6e695f45,0x64756c63,0x69645f65,0x74636572,0x00657669,0x00040005,0x00000004,0x6e69616d,0x00000000,0x00040005,0x0000000c,0x736f5061,0x00000000,0x00040005,0x00000017,0x6c6f4361,0x0000726f,0x00060005,0x00000020,0x505f6c67,0x65567265,0x78657472,0x00000000,0x00060006,0x00000020,0x00000000,0x505f6c67,0x7469736f,0x006e6f69,0x00070006,0x00000020,0x00000001,0x505f6c67,0x746e696f,0x657a6953,0x00000000,0x00070006,0x00000020,0x00000002,0x435f6c67,0x4470696c,0x61747369,0x0065636e,0x00070006,0x00000020,0x00000003,0x435f6c67,0x446c6c75,0x61747369,0x0065636e,0x00030005,0x00000022,0x00000000,0x00060005,0x00000026,0x565f6c67,0x65747265,0x646e4978,0x00007865,0x00040005,0x00000031,0x6c6f4376,0x0000726f,0x00050048,0x00000020,0x00000000,0x0000000b,0x00000000,0x00050048,0x00000020,0x00000001,0x0000000b,0x00000001,0x00050048,0x00000020,0x00000002,0x0000000b,0x00000003,0x00050048,0x00000020,0x00000003,0x0000000b,0x00000004,0x00030047,0x00000020,0x00000002,0x00040047,0x00000026,0x0000000b,0x0000002a,0x00040047,0x00000031,0x0000001e,0x00000000,0x00020013,0x00000002,0x00030021,0x00000003,0x00000002,0x00030016,0x00000006,0x00000020,0x00040017,0x00000007,0x00000006,0x00000002,0x00040015,0x00000008,0x00000020,0x00000000,0x0004002b,0x00000008,0x00000009,0x00000003,0x0004001c,0x0000000a,0x00000007,0x00000009,0x00040020,0x0000000b,0x00000006,0x0000000a,0x0004003b,0x0000000b,0x0000000c,0x00000006,0x0004002b,0x00000006,0x0000000d,0x00000000,0x0004002b,0x00000006,0x0000000e,0xbf000000,0x0005002c,0x00000007,0x0000000f,0x0000000d,0x0000000e,0x0004002b,0x00000006,0x00000010,0x3f000000,0x0005002c,0x00000007,0x00000011,0x00000010,0x00000010,0x0005002c,0x00000007,0x00000012,0x0000000e,0x00000010,0x0006002c,0x0000000a,0x00000013,0x0000000f,0x00000011,0x00000012,0x00040017,0x00000014,0x00000006,0x00000003,0x0004001c,0x00000015,0x00000014,0x00000009,0x00040020,0x00000016,0x00000006,0x00000015,0x0004003b,0x00000016,0x00000017,0x00000006,0x0004002b,0x00000006,0x00000018,0x3f800000,0x0006002c,0x00000014,0x00000019,0x00000018,0x0000000d,0x0000000d,0x0006002c,0x00000014,0x0000001a,0x0000000d,0x00000018,0x0000000d,0x0006002c,0x00000014,0x0000001b,0x0000000d,0x0000000d,0x00000018,0x0006002c,0x00000015,0x0000001c,0x00000019,0x0000001a,0x0000001b,0x00040017,0x0000001d,0x00000006,0x00000004,0x0004002b,0x00000008,0x0000001e,0x00000001,0x0004001c,0x0000001f,0x00000006,0x0000001e,0x0006001e,0x00000020,0x0000001d,0x00000006,0x0000001f,0x0000001f,0x00040020,0x00000021,0x00000003,0x00000020,0x0004003b,0x00000021,0x00000022,0x00000003,0x00040015,0x00000023,0x00000020,0x00000001,0x0004002b,0x00000023,0x00000024,0x00000000,0x00040020,0x00000025,0x00000001,0x00000023,0x0004003b,0x00000025,0x00000026,0x00000001,0x00040020,0x00000028,0x00000006,0x00000007,0x00040020,0x0000002e,0x00000003,0x0000001d,0x00040020,0x00000030,0x00000003,0x00000014,0x0004003b,0x00000030,0x00000031,0x00000003,0x00040020,0x00000033,0x00000006,0x00000014,0x00050036,0x00000002,0x00000004,0x00000000,0x00000003,0x000200f8,0x00000005,0x0003003e,0x0000000c,0x00000013,0x0003003e,0x00000017,0x0000001c,0x0004003d,0x00000023,0x00000027,0x00000026,0x00050041,0x00000028,0x00000029,0x0000000c,0x00000027,0x0004003d,0x00000007,0x0000002a,0x00000029,0x00050051,0x00000006,0x0000002b,0x0000002a,0x00000000,0x00050051,0x00000006,0x0000002c,0x0000002a,0x00000001,0x00070050,0x0000001d,0x0000002d,0x0000002b,0x0000002c,0x0000000d,0x00000018,0x00050041,0x0000002e,0x0000002f,0x00000022,0x00000024,0x0003003e,0x0000002f,0x0000002d,0x0004003d,0x00000023,0x00000032,0x00000026,0x00050041,0x00000033,0x00000034,0x00000017,0x00000032,0x0004003d,0x00000014,0x00000035,0x00000034,0x0003003e,0x00000031,0x00000035,0x000100fd,0x00010038};
        const tri_frag  :zvk.SpirV align(@alignOf(u32))= &.{0x07230203,0x00010000,0x000d000b,0x00000013,0x00000000,0x00020011,0x00000001,0x0006000b,0x00000001,0x4c534c47,0x6474732e,0x3035342e,0x00000000,0x0003000e,0x00000000,0x00000001,0x0007000f,0x00000004,0x00000004,0x6e69616d,0x00000000,0x00000009,0x0000000c,0x00030010,0x00000004,0x00000007,0x00030003,0x00000002,0x000001c2,0x000a0004,0x475f4c47,0x4c474f4f,0x70635f45,0x74735f70,0x5f656c79,0x656e696c,0x7269645f,0x69746365,0x00006576,0x00080004,0x475f4c47,0x4c474f4f,0x6e695f45,0x64756c63,0x69645f65,0x74636572,0x00657669,0x00040005,0x00000004,0x6e69616d,0x00000000,0x00040005,0x00000009,0x6c6f4366,0x0000726f,0x00040005,0x0000000c,0x6c6f4376,0x0000726f,0x00040047,0x00000009,0x0000001e,0x00000000,0x00040047,0x0000000c,0x0000001e,0x00000000,0x00020013,0x00000002,0x00030021,0x00000003,0x00000002,0x00030016,0x00000006,0x00000020,0x00040017,0x00000007,0x00000006,0x00000004,0x00040020,0x00000008,0x00000003,0x00000007,0x0004003b,0x00000008,0x00000009,0x00000003,0x00040017,0x0000000a,0x00000006,0x00000003,0x00040020,0x0000000b,0x00000001,0x0000000a,0x0004003b,0x0000000b,0x0000000c,0x00000001,0x0004002b,0x00000006,0x0000000e,0x3f800000,0x00050036,0x00000002,0x00000004,0x00000000,0x00000003,0x000200f8,0x00000005,0x0004003d,0x0000000a,0x0000000d,0x0000000c,0x00050051,0x00000006,0x0000000f,0x0000000d,0x00000000,0x00050051,0x00000006,0x00000010,0x0000000d,0x00000001,0x00050051,0x00000006,0x00000011,0x0000000d,0x00000002,0x00070050,0x00000007,0x00000012,0x0000000f,0x00000010,0x00000011,0x0000000e,0x0003003e,0x00000009,0x00000012,0x000100fd,0x00010038};
        const result = tut.render.Triangle10{
          .A     = S.A,
          .pso   = try zgpu.pipeline.Graphics.create_spv(S.device, S.swapchain,
            .{.vert= tri_vert, .frag= tri_frag}, .{}, S.A),
          }; //:: result
        return result;
      } //:: tut.render.Triangle10.create

      pub fn destroy (
          R : *tut.render.Triangle10,
          S : zgpu.System,
        ) void {
        R.pso.destroy(S.device);
      } //:: tut.render.Triangle10.destroy

      pub fn update (
          R : *tut.render.Triangle10,
          S : zgpu.System,
        ) !void {_=R; _=S;
      } //:: tut.render.Triangle10.update
    }; //:: tut.render.Triangle10

    // Currently active Tutorial
    pub const Tutorial = tut.render.Triangle10;
  }; //:: tut.render

  pub const Gpu = struct {
    system : zgpu.System,
    render : tut.render.Tutorial,  // @todo: Make the Gpu typename specific to the Renderer

    pub fn update (gpu :*Gpu) !void {
      try gpu.render.update(gpu.system);
    } //:: zgpu.Gpu.update

    pub fn init (in:struct {
        appName    : zgpu.String  = zgpu.cfg.default.appName,
        appVers    : zgpu.Version = zgpu.cfg.default.appVers,
        engineName : zgpu.String  = zgpu.cfg.default.engineName,
        engineVers : zgpu.Version = zgpu.cfg.default.engineVers, },
        window     : ?*glfw.Window,
        A          : zgpu.Allocator,
      ) !tut.Gpu {
      var result = Gpu{.system=undefined, .render=undefined};
      result.system = try zgpu.System.create(.{
        .appName    = in.appName,
        .appVers    = in.appVers,
        .engineName = in.engineName,
        .engineVers = in.engineVers,
        }, window, A);
      result.render = try tut.render.Tutorial.create(result.system);
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
  const zvk  = @import("./zvk.zig").zvk;

  //______________________________________
  // @section zvk Forward Exports
  //____________________________
  pub const Allocator  = zvk.Allocator;
  pub const String     = zvk.String;
  pub const Size       = zvk.Size;
  pub const SpirV      = zvk.SpirV;
  pub const version    = zvk.version;
  pub const Version    = zvk.Version;
  pub const Surface    = zvk.Surface;
  pub const Swapchain  = zvk.Swapchain;
  pub const pipeline   = struct {
    pub const Graphics = zvk.pipeline.Graphics;
  };

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
    device    :zvk.Device,
    surface   :zvk.Surface,
    swapchain :zvk.Swapchain,

    //______________________________________
    // @section System: Surface
    //____________________________
    pub const Surface = struct {
      /// @descr Creates a native Surface that Vulkan can draw into
      /// @note Makes this library dependent on GLFW
      pub fn create (
          I : zvk.Instance,
          W : ?*glfw.Window,
          A : zvk.Allocator,
        ) !zvk.Surface {
        var result :zvk.Surface= null;
        try zvk.ok(glfw.vk.surface.create(@ptrCast(I.ct), W, @ptrCast(A.vk), @ptrCast(&result)));
        return result;
      } //:: zgpu.System.Surface.create

      pub fn destroy (
          I : zvk.Instance,
          S : zvk.Surface,
          A : zvk.Allocator,
        ) void {
        zvk.surface.destroy(I.ct, S, A.vk);
      } //:: zgpu.System.Surface.destroy
    }; //:: zgpu.System.surface

    //______________________________________
    // @section System: Swapchain
    //____________________________
    pub const Swapchain = struct {
      /// @descr Returns a Swapchain object with the size of the {@arg window}
      /// @note Makes this library dependent on GLFW
      pub fn create (
          D : zvk.Device,
          S : zvk.Surface,
          W : ?*glfw.Window,
          A : zvk.Allocator,
        ) !zvk.Swapchain {
        var sz = zvk.Size{};
        glfw.framebuffer.size(W, @ptrCast(&sz.width), @ptrCast(&sz.height));
        return zvk.Swapchain.create(D, S, sz, A);
      } //:: zgpu.System.swapchain.create
    }; //:: zgpu.System.swapchain


    //______________________________________
    // @section System Management
    //____________________________
    fn empty () zgpu.System { return zgpu.System{
      .A         = undefined,
      .instance  = undefined,
      .dbg       = undefined,
      .device    = undefined,
      .surface   = undefined,
      .swapchain = undefined, };
    } //:: zgpu.System.empty

    pub fn create (in:struct {
        appName    : zgpu.String  = zgpu.cfg.default.appName,
        appVers    : zgpu.Version = zgpu.cfg.default.appVers,
        engineName : zgpu.String  = zgpu.cfg.default.engineName,
        engineVers : zgpu.Version = zgpu.cfg.default.engineVers, },
        window     : ?*glfw.Window,
        A          : zgpu.Allocator,
      ) !zgpu.System {
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
      result.surface   = try zgpu.System.Surface.create(result.instance, window, result.A);
      result.device    = try zvk.Device.create(result.instance, result.surface, result.A);
      result.swapchain = try zgpu.System.Swapchain.create(result.device, result.surface, window, A);
      return result;
    } //:: zgpu.System.create

    pub fn destroy (S :*System) !void {
      S.swapchain.destroy(S.device);
      S.device.destroy();
      zgpu.System.Surface.destroy(S.instance, S.surface, S.A);
      try zvk.validation.debug.destroy(S.instance, S.dbg, S.A);
      S.instance.destroy();
    } //:: zgpu.System.destroy

    pub fn waitIdle (S :*const System) !void { try S.device.waitIdle(); }
  }; //:: zgpu.System
}; //:: zgpu

