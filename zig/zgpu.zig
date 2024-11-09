//:__________________________________________________________________
//  zgpu  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps zdk
const zstd = @import("./zstd.zig");
const echo = zstd.echo;
const zsys = @import("./zsys.zig");
const zvk  = @import("./zvk.zig").zvk;


pub const zgpu = struct {
  const glfw = @import("./zglfw.zig");
  const vk   = @import("./zvulkan.zig");
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

  //______________________________________
  // @section System Handles and Data
  //____________________________
  pub const System = struct {
    A         :zgpu.Allocator,
    instance  :zvk.Instance,
    dbg       :zvk.Debug,
    surface   :zvk.Surface,
    device    :zvk.Device,
    swapchain :zvk.Swapchain,

    //______________________________________
    // @section System: Surface
    //____________________________
    pub const surface = struct {
      /// @descr Creates a native Surface that Vulkan can draw into
      /// @note Makes this library dependent on GLFW
      pub fn create (
          I : zvk.Instance,
          W : ?*glfw.Window,
          A : zgpu.Allocator,
        ) !zgpu.Surface {
        var result :zgpu.Surface= null;
        try zvk.vk.ok(glfw.vk.surface.create(@ptrCast(I.ct), W, @ptrCast(A.vk), @ptrCast(&result)));
        return result;
      } //:: zgpu.System.surface.create

      pub fn destroy (
          I : zvk.Instance,
          S : zgpu.Surface,
          A : zgpu.Allocator,
        ) void {
        zvk.surface.destroy(I.ct, S, A.vk);
      } //:: zgpu.System.surface.destroy
    }; //:: zgpu.System.surface

    //______________________________________
    // @section System: Swapchain
    //____________________________
    pub const swapchain = struct {
      /// @descr Returns a Swapchain object with the size of the {@arg window}
      /// @note Makes this library dependent on GLFW
      pub fn create (
          D : zvk.Device,
          S : zgpu.Surface,
          W : ?*glfw.Window,
          A : zgpu.Allocator,
        ) !zgpu.Swapchain {
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
      .surface   = undefined,
      .device    = undefined,
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
      result.surface   = try zgpu.System.surface.create(result.instance, window, result.A);
      result.device    = try zvk.Device.create(result.instance, result.surface, result.A);
      result.swapchain = try zgpu.System.swapchain.create(result.device, result.surface, window, A);
      return result;
    } //:: zgpu.System.create

    pub fn destroy (S :*System) !void {
      S.swapchain.destroy(S.device);
      zgpu.System.surface.destroy(S.instance, S.surface, S.A);
      S.device.destroy();
      try zvk.validation.debug.destroy(S.instance, S.dbg, S.A);
      S.instance.destroy();
    } //:: zgpu.System.destroy

    pub fn waitIdle (S :*const System) !void { try S.device.waitIdle(); }
  }; //:: zgpu.System

  //______________________________________
  // @section System Handles and Data
  //____________________________
  pub const render = struct {
    pub const Frame = struct {
      A            :zvk.Allocator,
      cmd          :zvk.command.Batch,
      __fence      :zvk.sync.Fence,
      __semaphore  :zvk.sync.Semaphore,
      pub const ID = u64;

      pub fn fence     (F :*const zgpu.render.Frame) vk.sync.Fence     { return F.__fence.ct; }
      pub fn semaphore (F :*const zgpu.render.Frame) vk.sync.Semaphore { return F.__semaphore.ct; }

      pub fn wait (
          F : *const zgpu.render.Frame,
          D : zvk.Device,
        ) !void {
        try vk.ok(vk.sync.fence.wait(D.logical, 1, &F.fence(), vk.toBool(true), 1_000_000_000));
        try vk.ok(vk.sync.fence.reset(D.logical, 1, &F.fence()));
      }

      pub fn create (
          D   : zvk.Device,
          cmd : zvk.command.Batch.CreateOptions,
          A   : zvk.Allocator,
        ) !zgpu.render.Frame {
        return zgpu.render.Frame{
          .A           = A,
          .cmd         = try zvk.command.Batch.create(D, cmd, A),
          .__fence     = try zvk.sync.Fence.create(D, .{}, A),
          .__semaphore = try zvk.sync.Semaphore.create(D, A),
          }; //:: result
      } //:: zgpu.render.Frame.create

      pub fn destroy (
         F : *zgpu.render.Frame,
         S : zgpu.System,
        ) void {
        F.cmd.destroy(S.device);
        F.__fence.destroy(S.device);
        F.__semaphore.destroy(S.device);
      } //:: zgpu.render.Frame.destroy

      pub fn Data (frameCount :usize) type {
        return struct {
          A     :zgpu.Allocator,
          __id  :zgpu.render.Frame.ID= 0,
          list  :[frameCount]zgpu.render.Frame,

          pub const count = frameCount;
          pub fn incr (F :*@This()      ) void { F.__id += 1; }
          pub fn id   (F :*const @This()) zgpu.render.Frame.ID { return F.__id % frameCount; }
          pub fn curr (F :*const @This()) zgpu.render.Frame { return F.list[F.id()]; }
          pub fn next (F :*@This()      ) zgpu.render.Frame { F.incr(); return F.list[F.id()]; }

          pub fn create (
              D   : zvk.Device,
              cmd : zvk.command.Batch.CreateOptions,
              A   : zvk.Allocator,
            ) !@This() {
            var result = @This(){.A= A, .list=undefined};
            for (0..@This().count) |frameID| {
              result.list[frameID] = try zgpu.render.Frame.create(D, cmd, result.A);
            }
            return result;
          } //:: zgpu.render.Frame.Data.create

          pub fn destroy (
              D : *@This(),
              S : zgpu.System,
            ) void {
            for (0..D.list.len) |frameID| D.list[frameID].destroy(S);
          } //:: zgpu.render.Frame.Data.destroy
        };
      } //:: zgpu.render.Frame.Data
    }; //:: zgpu.render.Frame

    /// @description
    ///  Simplest Possible Renderer
    ///  Clears the screen with a color and presents it.
    ///  No Pipelines. Draws directly to the Swapchain (vkCmdClearColorImage)
    pub const Clear = struct {
      A     : zgpu.Allocator,
      frame : @This().FrameData,

      pub const FrameData = zgpu.render.Frame.Data(zgpu.cfg.render.frame.count);

      pub fn create (
          S : zgpu.System,
        ) !zgpu.render.Clear {
        const result = zgpu.render.Clear{
          .A     = S.A,
          .frame = try zgpu.render.Clear.FrameData.create(S.device, .{}, S.A),
          }; //:: result
        return result;
      } //:: zgpu.render.Clear.create

      pub fn destroy (
          R : *zgpu.render.Clear,
          S : zgpu.System,
        ) void {
        R.frame.destroy(S);
      } //:: zgpu.render.Clear.destroy

      pub fn update (
          R : *zgpu.render.Clear,
          S : zgpu.System,
        ) !void {
        const F = R.frame.next(); // Get the framedata for the next frame
        try F.wait(S.device);
        _ = S.swapchain.nextImage(S.device, R.frame.list[R.frame.id()]);
      } //:: zgpu.render.Clear.update

    }; //:: zgpu.render.Clear
  }; //:: zgpu.render
}; //:: zgpu




//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


