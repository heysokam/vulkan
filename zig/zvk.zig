//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Cable connector to the zvk modules
//_____________________________________________________|

pub const zvk = struct {
  const std = @import("std");
  // @deps zdk
  const vk   = @import("./zvulkan.zig");
  const zstd = @import("./zstd.zig");

  //______________________________________
  // @section General Type Aliases
  //____________________________
  pub const String   = vk.String;
  pub const Size     = vk.Size;
  pub const SpirV    = vk.SpirV;
  pub const version  = vk.version;
  pub const Version  = vk.Version;
  pub const Debug    = vk.Debug;
  pub const Surface  = vk.Surface;
  pub const ok       = vk.ok;

  //______________________________________
  // @section Allocator
  //____________________________
  pub const Allocator = struct {
    zig  :std.mem.Allocator,
    vk   :?*const vk.Allocator,

    pub fn create (A :std.mem.Allocator) Allocator {
      return Allocator{
       .zig = A,
       .vk  = null  // @maybe Allocator library ?
        };
    } //:: zvk.Allocator.create
  }; //:: zvk.Allocator

  //______________________________________
  // @section Configuration and Defaults
  //____________________________
  pub const cfg = struct {
    pub const debug = struct {
      pub const flags    = vk.validation.debug.flags.Create{};  // #define Cfg_DebugFlags 0
      pub const severity = vk.validation.debug.flags.Severity{  // Cfg_DebugSeverity
        .verbose = true,  // c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT
        .warning = true,  // c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT
        .Error   = true,  // c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT
        }; //:: zvk.cfg.debug.severity
      pub const msgType = vk.validation.debug.flags.MsgType{  // Cfg_DebugMsgType
        .general     = true,  // c.VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT
        .validation  = true,  // c.VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT
        .performance = true,  // c.VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT
        }; //:: zvk.cfg.debug.msgType
    }; //:: zvk.cfg.debug

    pub const device = struct {
      pub const forceFirst = true;
      pub const extensions = &.{vk.extensions.Swapchain};
      pub const present    = vk.device.present.Mailbox;
      pub const frames     = 2;
    }; //:: zvk.cfg.device

    pub const features = struct {
      pub const list = undefined;
      //   /// List of 'apis' to construct base, instance and device wrappers for vulkan-zig
      //   pub const list :[]const vk.ApiInfo = &.{
      //     .{  // Add invidiual functions by manually creating an 'api'
      //       .base_commands     = .{ .createInstance = true, },
      //       .instance_commands = .{ .createDevice   = true, },
      //       },
      //     // Add entire feature sets or extensions
      //     vk.features.version_1_0,
      //     vk.extensions.khr_surface,
      //     vk.extensions.khr_swapchain,
      //   }; //:: zvk.features.list
    }; //:: zvk.features

    pub const swapchain = struct {
      pub const flags    = vk.flags.Swapchain{};
      pub const alpha    = vk.flags.CompositeAlpha{.Opaque=true};
      pub const clipped  = true;
      pub const color    = struct {
        pub const format = vk.color.format.srgb.BGRA8;
        pub const space  = vk.color.space.srgb.nonLinear;
      }; //:: zvk.cfg.swapchain.color
    }; //:: zvk.cfg.swapchain

    pub const default = struct {
      pub const version    = zvk.version.api.v1_3;
      pub const appName    = "zvk.Application";
      pub const appVers    = zvk.version.new(0, 0, 0);
      pub const engineName = "zvk.Engine";
      pub const engineVers = zvk.version.new(0, 0, 0);
    }; //:: zvk.cfg.default

    pub const command = struct {
      pub const reset     = true;
      pub const transient = false;
      pub const protected = false;
      pub const primary   = false;
    }; //:: zvk.cfg.command
  }; //:: zvk.cfg

  //______________________________________
  // @section Validation
  //____________________________
  pub const validation = struct {
    pub const active = if (zstd.debug) true else false;
    pub const layers = if (zvk.validation.active) .{vk.validation.LayerName} else .{};
    pub fn checkSupport (A :zvk.Allocator) !void {
      if (!zvk.validation.active) return;
      // Get the layer names
      const required = try vk.validation.instance.getLayers(A.zig);
      defer A.zig.free(required);
      // Check if the requested names exist in the list available layers
      search: {
        for (required) |ext| {
          const last = std.mem.indexOfScalar(u8, &ext.layerName, 0) orelse 0;
          if (std.mem.eql(u8, ext.layerName[0..last], vk.validation.LayerName)) break :search;
        }
        return error.zvk_validation_NotSupported;
      } //:: search
    } //:: zvk.validation.checkSupport

    pub const debug = struct {
      pub const Cfg      = vk.validation.debug.Cfg;
      pub const Callback = vk.validation.debug.Callback;
      pub const setup    = vk.validation.debug.setup;

      pub fn create (
          I : zvk.Instance,
          C : *const Cfg,
          A : zvk.Allocator,
        // ) !zvk.Debug {
        ) !vk.Debug {
        // Exit early if validation is not active
        if (!zvk.validation.active) return null;
        // Get the proc address (extensions must be manually loaded)
        const createMessenger :vk.validation.debug.Fn.Create= @ptrCast(vk.instance.getProc(I.ct, "vkCreateDebugUtilsMessengerEXT"));
        if (createMessenger == null) return error.vkGetInstanceProcAddr_Failed;
        // Run and return the result
        var result :vk.Debug= undefined;
        try vk.ok(createMessenger.?(I.ct, C, A.vk, &result));
        return result;
      } //:: zvk.validation.debug.create

      pub fn destroy (
          I : zvk.Instance,
          D : zvk.Debug,
          A : zvk.Allocator,
        ) !void {
        // Exit early if there is nothing to do
        if (D == null) return;
        // Get the proc address (extensions must be manually loaded)
        const destroyMessenger :vk.validation.debug.Fn.Destroy= @ptrCast(vk.instance.getProc(I.ct, "vkDestroyDebugUtilsMessengerEXT"));
        if (destroyMessenger == null) return error.vkGetInstanceProcAddr_Failed;
        // Run the proc
        destroyMessenger.?(I.ct, D, A.vk);
      } //:: zvk.validation.debug.destroy

      pub fn callback (
          severity  : vk.validation.debug.flags.C.Severity,
          typ       : vk.validation.debug.flags.C.MsgType,
          cbdata    : vk.validation.debug.CallbackData,
          userdata  : vk.validation.debug.Data,
        ) callconv(.C) vk.Bool {
        _=severity; _=typ; _=userdata;
        std.debug.print("[vulkan] {s}\n", .{cbdata.*.pMessage});
        return vk.False;  // Always return VK_FALSE. Used to test the validation layers themselves.
        // TODO: Cases
        // severity:
        //   VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT: Diagnostic message
        //   VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT: Informational message like the creation of a resource
        //   VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT: Message about behavior that is not necessarily an error, but very likely a bug in your application
        //   VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT: Message about behavior that is invalid and may cause crashes
        // typ:
        //   VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT: Some event has happened that is unrelated to the specification or performance
        //   VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT: Something has happened that violates the specification or indicates a possible mistake
        //   VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT: Potential non-optimal use of Vulkan
        // cbdata:
        // VkDebugUtilsMessengerCallbackDataEXT contains the details of the message. Most important members:
        //   pMessage    : The debug message as a null-terminated string
        //   pObjects    : Array of Vulkan object handles related to the message
        //   objectCount : Number of objects in array
      } //:: zvk.validation.debug.callback
    }; //:: zvk.validation.debug
  }; //:: zvk.validation

  //______________________________________
  // @section Application
  //____________________________
  pub const App = struct {
    pub const Cfg = vk.App.Cfg;
    pub fn new (in :struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers,
      }) zvk.App.Cfg {
      return zvk.App.Cfg{
        .sType              = vk.stype.app.Cfg,         // @import("std").mem.zeroes(VkStructureType),
        .pNext              = null,                     // .pNext: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
        .pApplicationName   = in.appName.ptr,           // .pApplicationName: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
        .applicationVersion = in.appVers,               // .applicationVersion: u32 = @import("std").mem.zeroes(u32),
        .pEngineName        = in.engineName.ptr,        // .pEngineName: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
        .engineVersion      = in.engineVers,            // .engineVersion: u32 = @import("std").mem.zeroes(u32),
        .apiVersion         = zvk.cfg.default.version,  // .apiVersion: u32 = @import("std").mem.zeroes(u32),
        }; //:: zvk.App.Cfg{ ... }
    } //:: zvk.App.defaults
  }; //:: zvk.App

  //______________________________________
  // @section Surface
  //____________________________
  pub const surface = struct {
    pub const destroy = vk.surface.destroy;
  }; //:: zvk.surface


  //______________________________________
  // @section Instance
  //____________________________
  pub const Instance = struct {
    A    :zvk.Allocator,
    ct   :vk.instance.T,
    cfg  :vk.instance.Cfg,

    const glfw = @import("./zglfw.zig");
    pub fn create (in:struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers, },
        debugCfg   : *const zvk.validation.debug.Cfg,
        A          : zvk.Allocator,
      ) !zvk.Instance {
      // Get the Extensions
      var exts = try glfw.vk.instance.getExts(A.zig);  // FIX: Remove glfw from ZVK!!
      if (zstd.macos) try exts.append(vk.extensions.Portability); // Mac support with VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME : https://vulkan-tutorial.com/en/Drawing_a_triangle/Setup/Instance
      if (zvk.validation.active) try exts.append(vk.extensions.DebugUtils);
      // try vk.extensions.instance.supported(exts); // FIX: Missing vk.extensions.instance.supported
      // Get the Validation Layers
      try zvk.validation.checkSupport(A);
      const layerCount = zvk.validation.layers.len;
      var layers = if (zvk.validation.active) zvk.validation.layers[0].ptr else null;
      // Generate the result
      var result = zvk.Instance{.ct= undefined,
        .A                         = A,
        .cfg                       = vk.instance.Cfg{
          .sType                   = vk.stype.instance.Cfg,            // sType: VkStructureType = @import("std").mem.zeroes(VkStructureType),
          .pNext                   = debugCfg,                         // pNext: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
          .flags                   = vk.flags.InstanceCreate.toInt(.{  // flags: VkInstanceCreateFlags = @import("std").mem.zeroes(VkInstanceCreateFlags),
            .enumeratePortability  = if (zstd.macos) true else false,
            }), //:: flags
          .pApplicationInfo        = &zvk.App.new(.{
            .appName               = in.appName,
            .appVers               = in.appVers,
            .engineName            = in.engineName,
            .engineVers            = in.engineVers,
            }), //:: pApplicationInfo                                  // pApplicationInfo: [*c]const VkApplicationInfo = @import("std").mem.zeroes([*c]const VkApplicationInfo),
          .enabledLayerCount       = layerCount,                       // enabledLayerCount: u32 = @import("std").mem.zeroes(u32),
          .ppEnabledLayerNames     = &layers,                          // ppEnabledLayerNames: [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
          .enabledExtensionCount   = @intCast(exts.items.len),         // enabledExtensionCount: u32 = @import("std").mem.zeroes(u32),
          .ppEnabledExtensionNames = exts.items.ptr,                   // ppEnabledExtensionNames: [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
        }}; //:: zvk.Instance{ ... }
      try vk.instance.create(&result.cfg, result.A.vk, &result.ct);
      return result;
    } //:: zvk.Instance.create
    pub fn destroy (I :*zvk.Instance) void { vk.instance.destroy(I.ct, I.A.vk); }
  }; //:: zvk.Instance


}; //:: zvk

// pub const zvk2 = struct {
//   pub const Features = zvk.features.List;
//   pub const features = struct {
//     pub const List = struct {
//       list  :Flags,
//       const Flags    = std.EnumSet(zvk.Features.Flag);
//       const InitVals = std.enums.EnumFieldStruct(zvk.Features.Flag, bool, false);
//       pub fn create () zvk.features.List { return zvk.features.List{.list= Flags.initEmpty()}; }
//       pub fn init   (L :zvk.Features.InitVals) zvk.features.List { return zvk.features.List{.list= Flags.init(L)}; }
//       pub fn incl   (L :*zvk.features.List, V :zvk.Features.Flag) void { L.list.insert(V); }
//       pub fn excl   (L :*zvk.features.List, V :zvk.Features.Flag) void { L.list.remove(V); }
//       pub fn has    (L :*const zvk.features.List, V :zvk.Features.Flag) bool { return L.list.contains(V); }
//       pub fn hasVk  (L :*const zvk.features.List, V :zvk.Features.Flag) vk.Bool { return vk.toBool(L.has(V)); }
//
//       pub const Flag = enum {
//         shader_atomics_int64_buffer,                           // v12 :: shaderBufferInt64Atomics
//         shader_atomics_int64_shared,                           // v12 :: shaderSharedInt64Atomics
//         shader_dynamicIndexing_UniformBufferArray,             // v10 :: shaderUniformBufferArrayDynamicIndexing
//         shader_dynamicIndexing_sampledImageArray,              // v10 :: shaderSampledImageArrayDynamicIndexing
//         shader_dynamicIndexing_storageBufferArray,             // v10 :: shaderStorageBufferArrayDynamicIndexing
//         shader_dynamicIndexing_storageImageArray,              // v10 :: shaderStorageImageArrayDynamicIndexing
//         shader_dynamicIndexing_InputAttachmentArray,           // v12 :: shaderInputAttachmentArrayDynamicIndexing
//         shader_dynamicIndexing_UniformTexelBufferArray,        // v12 :: shaderUniformTexelBufferArrayDynamicIndexing
//         shader_dynamicIndexing_storageTexelBufferArray,        // v12 :: shaderStorageTexelBufferArrayDynamicIndexing
//         shader_nonUniformIndexing_UniformBufferArray,          // v12 :: shaderUniformBufferArrayNonUniformIndexing
//         shader_nonUniformIndexing_sampledImageArray,           // v12 :: shaderSampledImageArrayNonUniformIndexing
//         shader_nonUniformIndexing_storageBufferArray,          // v12 :: shaderStorageBufferArrayNonUniformIndexing
//         shader_nonUniformIndexing_storageImageArray,           // v12 :: shaderStorageImageArrayNonUniformIndexing
//         shader_nonUniformIndexing_InputAttachmentArray,        // v12 :: shaderInputAttachmentArrayNonUniformIndexing
//         shader_nonUniformIndexing_UniformTexelBufferArray,     // v12 :: shaderUniformTexelBufferArrayNonUniformIndexing
//         shader_nonUniformIndexing_storageTexelBufferArray,     // v12 :: shaderStorageTexelBufferArrayNonUniformIndexing
//         shader_output_viewportIndex,                           // v12 :: shaderOutputViewportIndex
//         shader_output_layer,                                   // v12 :: shaderOutputLayer
//         shader_invocation_demoteToHelper,                      // v13 :: shaderDemoteToHelperInvocation
//         shader_invocation_terminate,                           // v13 :: shaderTerminateInvocation
//         shader_workgroup_zeroInitializeMemory,                 // v13 :: shaderZeroInitializeWorkgroupMemory
//         shader_integerDotProduct,                              // v13 :: shaderIntegerDotProduct
//         shader_drawParameters,                                 // v11 :: shaderDrawParameters
//         shader_image_gatherExtended,                           // v10 :: shaderImageGatherExtended
//         shader_storageImage_extendedFormats,                   // v10 :: shaderStorageImageExtendedFormats
//         shader_storageImage_multisample,                       // v10 :: shaderStorageImageMultisample
//         shader_storageImage_readWithoutFormat,                 // v10 :: shaderStorageImageReadWithoutFormat
//         shader_storageImage_writeWithoutFormat,                // v10 :: shaderStorageImageWriteWithoutFormat
//         shader_clipDistance,                                   // v10 :: shaderClipDistance
//         shader_cullDistance,                                   // v10 :: shaderCullDistance
//         shader_int8,                                           // v12 :: shaderInt8
//         shader_int16,                                          // v10 :: shaderInt16
//         shader_int64,                                          // v11 :: shaderInt64
//         shader_float16,                                        // v12 :: shaderFloat16
//         shader_float64,                                        // v10 :: shaderFloat64
//         shader_resource_residency,                             // v10 :: shaderResourceResidency
//         shader_resource_minLoD,                                // v10 :: shaderResourceMinLod
//         shader_subgroup_extendedTypes,                         // v12 :: shaderSubgroupExtendedTypes
//         shader_geometry,                                       // v10 :: geometryShader
//         shader_tessellation,                                   // v10 :: tessellationShader
//         shader_tessellationAndGeometry_pointSize,              // v10 :: shaderTessellationAndGeometryPointSize
//
//         image_robustAccess,                                    // v13 :: robustImageAccess
//         image_cubeArray,                                       // v10 :: imageCubeArray
//         sampler_YCBCRConversion,                               // v11 :: samplerYcbcrConversion
//         sampler_mirrorClampToEdge,                             // v12 ::
//         sampler_filterMinmax,                                  // v12 :: samplerFilterMinmax
//         sampler_anisotropy,                                    // v10 :: samplerAnisotropy
//         texture_compressionASTC_HDR,                           // v13 :: textureCompressionASTC_HDR
//         texture_compressionETC2,                               // v10 :: textureCompressionETC2
//         texture_compressionASTC_LDR,                           // v10 :: textureCompressionASTC_LDR
//         texture_compressionBC,                                 // v10 :: textureCompressionBC
//
//         pipeline_creationCacheControl,                         // v13 :: pipelineCreationCacheControl
//         pipeline_statisticsQuery,                              // v10 :: pipelineStatisticsQuery
//         pipeline_vertex_storesAndAtomics,                      // v10 :: vertexPipelineStoresAndAtomics
//         pipeline_fragment_storesAndAtomics,                    // v10 :: fragmentStoresAndAtomics
//
//         compute_subgroupSizeControl,                           // v13 :: subgroupSizeControl
//         compute_subgroupBroadcastDynamicId,                    // v12 :: subgroupBroadcastDynamicId
//         compute_subgroupsFull,                                 // v13 :: computeFullSubgroups
//
//         dynamicRendering,                                      // v13 :: dynamicRendering
//         synchronization2,                                      // v13 :: synchronization2
//         maintenance4,                                          // v13 :: maintenance4
//
//         buffer_robustAccess,                                   // v10 :: robustBufferAccess
//         buffer_uniform_inlineBlock,                            // v13 :: inlineUniformBlock
//         buffer_uniform_standardLayout,                         // v12 :: uniformBufferStandardLayout
//         buffer_storage_access8Bit,                             // v12 :: storageBuffer8BitAccess
//         buffer_storage_access16Bit,                            // v11 :: storageBuffer16BitAccess
//         buffer_storage_pushConstant8,                          // v12 :: storagePushConstant8
//         buffer_storage_pushConstant16,                         // v11 :: storagePushConstant16
//         buffer_storage_inputOutput16,                          // v11 :: storageInputOutput16
//         buffer_uniformAndStorage_access8Bit,                   // v12 :: uniformAndStorageBuffer8BitAccess
//         buffer_uniformAndStorage_access16Bit,                  // v11 :: uniformAndStorageBuffer16BitAccess
//         buffer_deviceAddress,                                  // v12 :: bufferDeviceAddress
//         buffer_deviceAddress_captureReplay,                    // v12 :: bufferDeviceAddressCaptureReplay
//         buffer_deviceAddress_multiDevice,                      // v12 :: bufferDeviceAddressMultiDevice
//
//         descriptor_indexing,                                   // v12 :: descriptorIndexing
//         descriptor_runtimeArray,                               // v12 :: runtimeDescriptorArray
//         descriptor_binding_updateAfterBind_uniformBuffer,      // v12 :: descriptorBindingUniformBufferUpdateAfterBind
//         descriptor_binding_updateAfterBind_sampledImage,       // v12 :: descriptorBindingSampledImageUpdateAfterBind
//         descriptor_binding_updateAfterBind_storageImage,       // v12 :: descriptorBindingStorageImageUpdateAfterBind
//         descriptor_binding_updateAfterBind_storageBuffer,      // v12 :: descriptorBindingStorageBufferUpdateAfterBind
//         descriptor_binding_updateAfterBind_uniformTexelBuffer, // v12 :: descriptorBindingUniformTexelBufferUpdateAfterBind
//         descriptor_binding_updateAfterBind_storageTexelBuffer, // v12 :: descriptorBindingStorageTexelBufferUpdateAfterBind
//         descriptor_binding_updateAfterBind_inlineUniformBlock, // v13 :: descriptorBindingInlineUniformBlockUpdateAfterBind
//         descriptor_binding_updateUnusedWhilePending,           // v12 :: descriptorBindingUpdateUnusedWhilePending
//         descriptor_binding_partiallyBound,                     // v12 :: descriptorBindingPartiallyBound
//         descriptor_binding_variableDescriptorCount,            // v12 :: descriptorBindingVariableDescriptorCount
//
//         framebuffer_imageless,                                 // v12 :: imagelessFramebuffer
//
//         separateDepthStencilLayouts,                           // v12 :: separateDepthStencilLayouts
//         timelineSemaphore,                                     // v12 :: timelineSemaphore
//
//         query_hostReset,                                       // v12 :: hostQueryReset
//         query_preciseOcclusion,                                // v10 :: occlusionQueryPrecise
//         query_inherited,                                       // v10 :: inheritedQueries
//
//         memory_scalarBlockLayout,                              // v12 :: scalarBlockLayout
//         memory_protected,                                      // v11 :: protectedMemory
//         memory_privateData,                                    // v13 :: privateData
//         memory_vulkanModel,                                    // v12 :: vulkanMemoryModel
//         memory_vulkanModel_deviceScope,                        // v12 :: vulkanMemoryModelDeviceScope
//         memory_vulkanModel_availabilityVisibilityChains,       // v12 :: vulkanMemoryModelAvailabilityVisibilityChains
//
//         draw_indirectCount,                                    // v12 :: drawIndirectCount
//         draw_indirectFirstInstance,                            // v10 :: drawIndirectFirstInstance
//         draw_multiview,                                        // v11 :: multiview
//         draw_multiview_geometryShader,                         // v11 :: multiviewGeometryShader
//         draw_multiview_tessellationShader,                     // v11 :: multiviewTessellationShader
//         draw_multiViewport,                                    // v10 :: multiViewport
//         draw_multiDrawIndirect,                                // v10 :: multiDrawIndirect
//         draw_fullDrawIndexUint32,                              // v10 :: fullDrawIndexUint32
//         draw_fillModeNonSolid,                                 // v10 :: fillModeNonSolid
//         draw_wideLines,                                        // v10 :: wideLines
//         draw_largePoints,                                      // v10 :: largePoints
//
//         variablePointers_storageBuffer,                        // v11 :: variablePointersStorageBuffer
//         variablePointers,                                      // v11 :: variablePointers
//         variableMultisampleRate,                               // v10 :: variableMultisampleRate
//
//         blend_independent,                                     // v10 :: independentBlend
//         blend_dualSrc,                                         // v10 :: dualSrcBlend
//
//         depth_clamp,                                           // v10 :: depthClamp
//         depth_biasClamp,                                       // v10 :: depthBiasClamp
//         depth_bounds,                                          // v10 :: depthBounds
//
//         alphaToOne,                                            // v10 :: alphaToOne
//         sampleRateShading,                                     // v10 :: sampleRateShading
//         logicOp,                                               // v10 :: logicOp
//
//         sparse_binding,                                        // v10 :: sparseBinding
//         sparse_residencyBuffer,                                // v10 :: sparseResidencyBuffer
//         sparse_residencyImage2D,                               // v10 :: sparseResidencyImage2D
//         sparse_residencyImage3D,                               // v10 :: sparseResidencyImage3D
//         sparse_residency2Samples,                              // v10 :: sparseResidency2Samples
//         sparse_residency4Samples,                              // v10 :: sparseResidency4Samples
//         sparse_residency8Samples,                              // v10 :: sparseResidency8Samples
//         sparse_residency16Samples,                             // v10 :: sparseResidency16Samples
//         sparse_residencyAliased,                               // v10 :: sparseResidencyAliased
//       }; //:: zvk.features.Flag
//
//       pub fn defaults () zvk.features.List {
//         var result = zvk.features.List.create();
//         // Modern Vulkan
//         result.incl(.dynamicRendering);                                      // 1.3 core
//         result.incl(.synchronization2);                                      // 1.3 core
//         result.incl(.maintenance4);                                          // 1.3 core
//         // Modern Vulkan: Bindless Resources
//         result.incl(.descriptor_binding_updateAfterBind_sampledImage);       // 1.2 core. Bindless Images
//         result.incl(.descriptor_binding_updateAfterBind_storageImage);       // 1.2 core. Bindless SS.Images
//         result.incl(.descriptor_binding_updateAfterBind_storageBuffer);      // 1.2 core. Bindless SS.Buffers
//         result.incl(.descriptor_binding_updateAfterBind_storageTexelBuffer); // 1.2 core. Bindless Texel SS.Buffers
//         result.incl(.descriptor_binding_partiallyBound);                     // 1.2 core. Support binding invalid resources, as long as they are not accessed on shaders
//         // HCC Requirements: Core
//         result.incl(.memory_vulkanModel);                                    // 1.2 core : https://docs.vulkan.org/spec/latest/appendices/memorymodel.html#memory-model
//         result.incl(.memory_vulkanModel_deviceScope);                        // 1.2 core : https://docs.vulkan.org/spec/latest/appendices/memorymodel.html#memory-model
//         result.incl(.memory_scalarBlockLayout);                              // 1.2 core. For CPU interop. Allow block resources to use scalar alignment (C-like).
//         result.incl(.shader_invocation_demoteToHelper);                      // 1.3 core
//         // HCC Requirements: Extras
//         result.incl(.pipeline_fragment_storesAndAtomics);                    // Allow write access to SSBO/Images in fragment shaders
//         result.incl(.shader_nonUniformIndexing_sampledImageArray);           // Non-uniform indexing for Images
//         result.incl(.shader_nonUniformIndexing_storageBufferArray);          // Non-uniform indexing for SS.Buffers
//         result.incl(.shader_nonUniformIndexing_storageImageArray);           // Non-uniform indexing for SS.Images
//         result.incl(.shader_nonUniformIndexing_storageTexelBufferArray);     // Non-uniform indexing for Texel SS.Buffers
//         return result;
//       } //:: zvk.features.List.defaults
//
//       pub fn toVulkan (L :*const zvk.Features, A :zvk.Allocator) !zvk.features.Vulkan {
//         // Allocate the objects
//         var result = try zvk.features.Vulkan.create(A);
//         result.v13.descriptorBindingInlineUniformBlockUpdateAfterBind = L.hasVk(.descriptor_binding_updateAfterBind_inlineUniformBlock);
//         result.v13.privateData                                        = L.hasVk(.memory_privateData);
//         result.v13.shaderDemoteToHelperInvocation                     = L.hasVk(.shader_invocation_demoteToHelper);
//         result.v13.shaderTerminateInvocation                          = L.hasVk(.shader_invocation_terminate);
//         result.v13.shaderZeroInitializeWorkgroupMemory                = L.hasVk(.shader_workgroup_zeroInitializeMemory);
//         result.v13.shaderIntegerDotProduct                            = L.hasVk(.shader_integerDotProduct);
//         result.v13.robustImageAccess                                  = L.hasVk(.image_robustAccess);
//         result.v13.textureCompressionASTC_HDR                         = L.hasVk(.texture_compressionASTC_HDR);
//         result.v13.pipelineCreationCacheControl                       = L.hasVk(.pipeline_creationCacheControl);
//         result.v13.subgroupSizeControl                                = L.hasVk(.compute_subgroupSizeControl);
//         result.v13.computeFullSubgroups                               = L.hasVk(.compute_subgroupsFull);
//         result.v13.dynamicRendering                                   = L.hasVk(.dynamicRendering);
//         result.v13.synchronization2                                   = L.hasVk(.synchronization2);
//         result.v13.maintenance4                                       = L.hasVk(.maintenance4);
//         result.v13.inlineUniformBlock                                 = L.hasVk(.buffer_uniform_inlineBlock);
//
//         result.v12.shaderBufferInt64Atomics                           = L.hasVk(.shader_atomics_int64_buffer);
//         result.v12.shaderSharedInt64Atomics                           = L.hasVk(.shader_atomics_int64_shared);
//         result.v12.shaderInputAttachmentArrayDynamicIndexing          = L.hasVk(.shader_dynamicIndexing_InputAttachmentArray);
//         result.v12.shaderUniformTexelBufferArrayDynamicIndexing       = L.hasVk(.shader_dynamicIndexing_UniformTexelBufferArray);
//         result.v12.shaderStorageTexelBufferArrayDynamicIndexing       = L.hasVk(.shader_dynamicIndexing_storageTexelBufferArray);
//         result.v12.shaderUniformBufferArrayNonUniformIndexing         = L.hasVk(.shader_nonUniformIndexing_UniformBufferArray);
//         result.v12.shaderSampledImageArrayNonUniformIndexing          = L.hasVk(.shader_nonUniformIndexing_sampledImageArray);
//         result.v12.shaderStorageBufferArrayNonUniformIndexing         = L.hasVk(.shader_nonUniformIndexing_storageBufferArray);
//         result.v12.shaderStorageImageArrayNonUniformIndexing          = L.hasVk(.shader_nonUniformIndexing_storageImageArray);
//         result.v12.shaderInputAttachmentArrayNonUniformIndexing       = L.hasVk(.shader_nonUniformIndexing_InputAttachmentArray);
//         result.v12.shaderUniformTexelBufferArrayNonUniformIndexing    = L.hasVk(.shader_nonUniformIndexing_UniformTexelBufferArray);
//         result.v12.shaderStorageTexelBufferArrayNonUniformIndexing    = L.hasVk(.shader_nonUniformIndexing_storageTexelBufferArray);
//         result.v12.shaderOutputViewportIndex                          = L.hasVk(.shader_output_viewportIndex);
//         result.v12.shaderOutputLayer                                  = L.hasVk(.shader_output_layer);
//         result.v12.samplerMirrorClampToEdge                           = L.hasVk(.sampler_mirrorClampToEdge);
//         result.v12.samplerFilterMinmax                                = L.hasVk(.sampler_filterMinmax);
//         result.v12.subgroupBroadcastDynamicId                         = L.hasVk(.compute_subgroupBroadcastDynamicId);
//         result.v12.drawIndirectCount                                  = L.hasVk(.draw_indirectCount);
//         result.v12.shaderFloat16                                      = L.hasVk(.shader_float16);
//         result.v12.shaderInt8                                         = L.hasVk(.shader_int8);
//         result.v12.shaderSubgroupExtendedTypes                        = L.hasVk(.shader_subgroup_extendedTypes);
//         result.v12.uniformBufferStandardLayout                        = L.hasVk(.buffer_uniform_standardLayout);
//         result.v12.storageBuffer8BitAccess                            = L.hasVk(.buffer_storage_access8Bit);
//         result.v12.storagePushConstant8                               = L.hasVk(.buffer_storage_pushConstant8);
//         result.v12.uniformAndStorageBuffer8BitAccess                  = L.hasVk(.buffer_uniformAndStorage_access8Bit);
//         result.v12.bufferDeviceAddress                                = L.hasVk(.buffer_deviceAddress);
//         result.v12.bufferDeviceAddressCaptureReplay                   = L.hasVk(.buffer_deviceAddress_captureReplay);
//         result.v12.bufferDeviceAddressMultiDevice                     = L.hasVk(.buffer_deviceAddress_multiDevice);
//         result.v12.descriptorIndexing                                 = L.hasVk(.descriptor_indexing);
//         result.v12.runtimeDescriptorArray                             = L.hasVk(.descriptor_runtimeArray);
//         result.v12.descriptorBindingUniformBufferUpdateAfterBind      = L.hasVk(.descriptor_binding_updateAfterBind_uniformBuffer);
//         result.v12.descriptorBindingSampledImageUpdateAfterBind       = L.hasVk(.descriptor_binding_updateAfterBind_sampledImage);
//         result.v12.descriptorBindingStorageImageUpdateAfterBind       = L.hasVk(.descriptor_binding_updateAfterBind_storageImage);
//         result.v12.descriptorBindingStorageBufferUpdateAfterBind      = L.hasVk(.descriptor_binding_updateAfterBind_storageBuffer);
//         result.v12.descriptorBindingUniformTexelBufferUpdateAfterBind = L.hasVk(.descriptor_binding_updateAfterBind_uniformTexelBuffer);
//         result.v12.descriptorBindingStorageTexelBufferUpdateAfterBind = L.hasVk(.descriptor_binding_updateAfterBind_storageTexelBuffer);
//         result.v12.descriptorBindingUpdateUnusedWhilePending          = L.hasVk(.descriptor_binding_updateUnusedWhilePending);
//         result.v12.descriptorBindingPartiallyBound                    = L.hasVk(.descriptor_binding_partiallyBound);
//         result.v12.descriptorBindingVariableDescriptorCount           = L.hasVk(.descriptor_binding_variableDescriptorCount);
//         result.v12.imagelessFramebuffer                               = L.hasVk(.framebuffer_imageless);
//         result.v12.separateDepthStencilLayouts                        = L.hasVk(.separateDepthStencilLayouts);
//         result.v12.timelineSemaphore                                  = L.hasVk(.timelineSemaphore);
//         result.v12.hostQueryReset                                     = L.hasVk(.query_hostReset);
//         result.v12.scalarBlockLayout                                  = L.hasVk(.memory_scalarBlockLayout);
//         result.v12.vulkanMemoryModel                                  = L.hasVk(.memory_vulkanModel);
//         result.v12.vulkanMemoryModelDeviceScope                       = L.hasVk(.memory_vulkanModel_deviceScope);
//         result.v12.vulkanMemoryModelAvailabilityVisibilityChains      = L.hasVk(.memory_vulkanModel_availabilityVisibilityChains);
//
//         result.v11.shaderDrawParameters                               = L.hasVk(.shader_drawParameters);
//         result.v11.samplerYcbcrConversion                             = L.hasVk(.sampler_YCBCRConversion);
//         result.v11.storageBuffer16BitAccess                           = L.hasVk(.buffer_storage_access16Bit);
//         result.v11.storagePushConstant16                              = L.hasVk(.buffer_storage_pushConstant16);
//         result.v11.storageInputOutput16                               = L.hasVk(.buffer_storage_inputOutput16);
//         result.v11.uniformAndStorageBuffer16BitAccess                 = L.hasVk(.buffer_uniformAndStorage_access16Bit);
//         result.v11.protectedMemory                                    = L.hasVk(.memory_protected);
//         result.v11.multiview                                          = L.hasVk(.draw_multiview);
//         result.v11.multiviewGeometryShader                            = L.hasVk(.draw_multiview_geometryShader);
//         result.v11.multiviewTessellationShader                        = L.hasVk(.draw_multiview_tessellationShader);
//         result.v11.variablePointersStorageBuffer                      = L.hasVk(.variablePointers_storageBuffer);
//         result.v11.variablePointers                                   = L.hasVk(.variablePointers);
//
//         result.v10.shaderUniformBufferArrayDynamicIndexing            = L.hasVk(.shader_dynamicIndexing_UniformBufferArray);
//         result.v10.shaderSampledImageArrayDynamicIndexing             = L.hasVk(.shader_dynamicIndexing_sampledImageArray);
//         result.v10.shaderStorageBufferArrayDynamicIndexing            = L.hasVk(.shader_dynamicIndexing_storageBufferArray);
//         result.v10.shaderStorageImageArrayDynamicIndexing             = L.hasVk(.shader_dynamicIndexing_storageImageArray);
//         result.v10.shaderImageGatherExtended                          = L.hasVk(.shader_image_gatherExtended);
//         result.v10.shaderStorageImageExtendedFormats                  = L.hasVk(.shader_storageImage_extendedFormats);
//         result.v10.shaderStorageImageMultisample                      = L.hasVk(.shader_storageImage_multisample);
//         result.v10.shaderStorageImageReadWithoutFormat                = L.hasVk(.shader_storageImage_readWithoutFormat);
//         result.v10.shaderStorageImageWriteWithoutFormat               = L.hasVk(.shader_storageImage_writeWithoutFormat);
//         result.v10.shaderClipDistance                                 = L.hasVk(.shader_clipDistance);
//         result.v10.shaderCullDistance                                 = L.hasVk(.shader_cullDistance);
//         result.v10.shaderInt16                                        = L.hasVk(.shader_int16);
//         result.v10.shaderInt64                                        = L.hasVk(.shader_int64);
//         result.v10.shaderFloat64                                      = L.hasVk(.shader_float64);
//         result.v10.shaderResourceResidency                            = L.hasVk(.shader_resource_residency);
//         result.v10.shaderResourceMinLod                               = L.hasVk(.shader_resource_minLoD);
//         result.v10.geometryShader                                     = L.hasVk(.shader_geometry);
//         result.v10.tessellationShader                                 = L.hasVk(.shader_tessellation);
//         result.v10.shaderTessellationAndGeometryPointSize             = L.hasVk(.shader_tessellationAndGeometry_pointSize);
//         result.v10.imageCubeArray                                     = L.hasVk(.image_cubeArray);
//         result.v10.samplerAnisotropy                                  = L.hasVk(.sampler_anisotropy);
//         result.v10.textureCompressionETC2                             = L.hasVk(.texture_compressionETC2);
//         result.v10.textureCompressionASTC_LDR                         = L.hasVk(.texture_compressionASTC_LDR);
//         result.v10.textureCompressionBC                               = L.hasVk(.texture_compressionBC);
//         result.v10.pipelineStatisticsQuery                            = L.hasVk(.pipeline_statisticsQuery);
//         result.v10.vertexPipelineStoresAndAtomics                     = L.hasVk(.pipeline_vertex_storesAndAtomics);
//         result.v10.fragmentStoresAndAtomics                           = L.hasVk(.pipeline_fragment_storesAndAtomics);
//         result.v10.robustBufferAccess                                 = L.hasVk(.buffer_robustAccess);
//         result.v10.occlusionQueryPrecise                              = L.hasVk(.query_preciseOcclusion);
//         result.v10.inheritedQueries                                   = L.hasVk(.query_inherited);
//         result.v10.multiViewport                                      = L.hasVk(.draw_multiViewport);
//         result.v10.drawIndirectFirstInstance                          = L.hasVk(.draw_indirectFirstInstance);
//         result.v10.multiDrawIndirect                                  = L.hasVk(.draw_multiDrawIndirect);
//         result.v10.fullDrawIndexUint32                                = L.hasVk(.draw_fullDrawIndexUint32);
//         result.v10.fillModeNonSolid                                   = L.hasVk(.draw_fillModeNonSolid);
//         result.v10.wideLines                                          = L.hasVk(.draw_wideLines);
//         result.v10.largePoints                                        = L.hasVk(.draw_largePoints);
//         result.v10.variableMultisampleRate                            = L.hasVk(.variableMultisampleRate);
//         result.v10.independentBlend                                   = L.hasVk(.blend_independent);
//         result.v10.dualSrcBlend                                       = L.hasVk(.blend_dualSrc);
//         result.v10.depthClamp                                         = L.hasVk(.depth_clamp);
//         result.v10.depthBiasClamp                                     = L.hasVk(.depth_biasClamp);
//         result.v10.depthBounds                                        = L.hasVk(.depth_bounds);
//         result.v10.alphaToOne                                         = L.hasVk(.alphaToOne);
//         result.v10.sampleRateShading                                  = L.hasVk(.sampleRateShading);
//         result.v10.logicOp                                            = L.hasVk(.logicOp);
//         result.v10.sparseBinding                                      = L.hasVk(.sparse_binding);
//         result.v10.sparseResidencyBuffer                              = L.hasVk(.sparse_residencyBuffer);
//         result.v10.sparseResidencyImage2D                             = L.hasVk(.sparse_residencyImage2D);
//         result.v10.sparseResidencyImage3D                             = L.hasVk(.sparse_residencyImage3D);
//         result.v10.sparseResidency2Samples                            = L.hasVk(.sparse_residency2Samples);
//         result.v10.sparseResidency4Samples                            = L.hasVk(.sparse_residency4Samples);
//         result.v10.sparseResidency8Samples                            = L.hasVk(.sparse_residency8Samples);
//         result.v10.sparseResidency16Samples                           = L.hasVk(.sparse_residency16Samples);
//         result.v10.sparseResidencyAliased                             = L.hasVk(.sparse_residencyAliased);
//         return result;
//       } //:: zvk.features.List.toVulkan
//     }; //:: zvk.features.List
//
//     pub const Vulkan = struct {
//       A    : zvk.Allocator,
//       root : *vk.features.Root,
//       v10  : *vk.features.V10,
//       v11  : *vk.features.V11,
//       v12  : *vk.features.V12,
//       v13  : *vk.features.V13,
//
//       pub fn destroy (L :*zvk.features.Vulkan) void {
//         L.A.zig.destroy(L.v13);
//         L.A.zig.destroy(L.v12);
//         L.A.zig.destroy(L.v11);
//         L.A.zig.destroy(L.v10);
//         L.A.zig.destroy(L.root);
//         L.v10 = undefined;
//       } //:: zvk.features.Vulkan.destroy
//
//       pub fn create (A :zvk.Allocator) !zvk.features.Vulkan {
//         var result  :zvk.features.Vulkan= undefined;
//         result.A          = A;
//         result.root       = try result.A.zig.create(vk.features.Root);
//         result.v11        = try result.A.zig.create(vk.features.V11);
//         result.v12        = try result.A.zig.create(vk.features.V12);
//         result.v13        = try result.A.zig.create(vk.features.V13);
//         // Structure Types
//         result.root.sType = vk.stype.device.Features10;
//         result.v11.sType  = vk.stype.device.Features11;
//         result.v12.sType  = vk.stype.device.Features12;
//         result.v13.sType  = vk.stype.device.Features13;
//         // Create the chain
//         result.v10        = &result.root.features;
//         result.root.pNext = result.v11;
//         result.v11.pNext  = result.v12;
//         result.v12.pNext  = result.v13;
//         result.v13.pNext  = null;
//         return result;
//       } //:: zvk.features.Vulkan.create
//     }; //:: zvk.features.Vulkan
//   }; //:: zvk.features
//
//   //______________________________________
//   // @section Device
//   //____________________________
//   pub const Device = struct {
//     A         :zvk.Allocator,
//     physical  :vk.device.Physical,
//     logical   :vk.device.Logical,
//     queue     :zvk.Device.Queue,
//
//     pub fn create (
//        I : zvk.Instance,
//        S : vk.Surface,
//        A : zvk.Allocator,
//       ) !zvk.Device {
//       const feats = zvk.Features.defaults();
//       const exts :[]const zvk.Device.extensions.Name= zvk.cfg.device.extensions;
//       var result = zvk.Device{.A=A, .physical=undefined, .logical=undefined, .queue= undefined, };
//       result.physical = try zvk.Device.physical.create(I, S, exts, feats, A);
//       result.logical  = try zvk.Device.logical.create(result.physical, S, exts, feats, A);
//       result.queue    = try zvk.Device.Queue.create(result.physical, result.logical, S, A);
//       return result;
//     } //:: zvk.Device.create
//
//     pub fn destroy (D :*zvk.Device) void { vk.device.logical.destroy(D.logical, D.A.vk); }
//
//     pub const Extensions = zvk.Device.extensions.CList;
//     pub const extensions = struct {
//       pub const Name       = vk.String;
//       pub const List       = []zvk.Device.extensions.Name;
//       pub const CList      = []const zvk.Device.extensions.Name;
//       pub const Properties = []vk.extensions.Properties;
//
//       /// Returns the list of all available device extension names
//       pub fn getProperties (
//           D : vk.Device.Physical,
//           A : zvk.Allocator,
//         ) !zvk.Device.extensions.Properties {
//         // Get the list of extension properties
//         var count :u32= 0;
//         try vk.ok(vk.device.extensions.getProperties(D, null, &count, null));
//         const result = try A.zig.alloc(vk.device.extensions.Properties, count);
//         try vk.ok(vk.device.extensions.getProperties(D, null, &count, result.ptr));
//         return result;
//       } //:: zvk.Device.extensions.getProperties
//
//       /// Returns whether or not the {@arg L} list of extension properties constains the {@arg N} extension name
//       pub fn contains (
//           L : zvk.Device.extensions.Properties,
//           N : zvk.Device.extensions.Name,
//         ) bool {
//         for (L) |P| {
//           const last = std.mem.indexOfScalar(u8, &P.extensionName, 0) orelse 0;
//           if (std.mem.eql(u8, P.extensionName[0..last], N)) return true;
//         }
//         return false;
//       } //:: zvk.Device.extensions.contains
//
//       /// Returns whether or not the {@arg D} device supports all extensions in the {@arg L} list.
//       pub fn supportsAll (
//           D : vk.Device.Physical,
//           L : zvk.Device.Extensions,
//           A : zvk.Allocator,
//         ) !bool {
//         const available = try zvk.Device.extensions.getProperties(D, A);
//         defer A.zig.free(available);
//         for (L) |ext| if (!zvk.Device.extensions.contains(available, ext)) return false;
//         return true;
//       } //:: zvk.Device.extensions.supportsAll
//     }; //:: zvk.Device.extensions
//
//     pub const features = struct {
//       pub fn getList (
//           D : vk.Device.Physical,
//         ) vk.device.physical.Features {
//         var result = vk.device.physical.Features{};
//         vk.device.physical.getFeatures(D, &result);
//         return result;
//       } //:: zvk.Device.features.getList
//
//       pub fn supportsAll (
//           D : vk.Device.Physical,
//           F : zvk.Features,
//         ) bool {
//         // FIX: Check that all of the desired features are supported
//         _ = zvk.Device.features.getList(D); // Available
//         _ = F;
//       } //:: zvk.Device.features.supportsAll
//     }; //:: zvk.Device.features
//
//
//     pub const physical = struct {
//       pub const SwapchainSupport = struct {
//         A        :zvk.Allocator,
//         caps     :vk.surface.Capabilities,
//         formats  :[]vk.surface.Format,
//         modes    :[]vk.device.present.Mode,
//
//         pub fn getCapabilities (
//             D : vk.Device.Physical,
//             S : vk.Surface,
//           ) !vk.surface.Capabilities {
//           var result = vk.surface.Capabilities{};
//           try vk.ok(vk.device.physical.surface.getCapabilities(D, S, &result));
//           return result;
//         }
//
//         pub fn getFormats (
//             D : vk.Device.Physical,
//             S : vk.Surface,
//             A : zvk.Allocator,
//           ) ![]vk.surface.Format {
//           var result :[]vk.surface.Format= &.{};
//           var count :u32= 0;
//           try vk.ok(vk.device.physical.surface.getFormats(D, S, &count, null));
//           if (count > 0) {
//             result = try A.zig.alloc(vk.surface.Format, count);
//             try vk.ok(vk.device.physical.surface.getFormats(D, S, &count, result.ptr));
//           } else return error.device_NoSurfaceFormats;
//           return result;
//         }
//
//         pub fn getPresentModes (
//             D : vk.Device.Physical,
//             S : vk.Surface,
//             A : zvk.Allocator,
//           ) ![]vk.device.present.Mode {
//           var result :[]vk.device.present.Mode= &.{};
//           var count :u32= 0;
//           try vk.ok(vk.device.physical.surface.getPresentModes(D, S, &count, null));
//           if (count > 0) {
//             result = try A.zig.alloc(vk.device.present.Mode, count);
//             try vk.ok(vk.device.physical.surface.getPresentModes(D, S, &count, result.ptr));
//           } else return error.device_NoPresentModes;
//           return result;
//         }
//
//         pub fn hasSwapchain (S :*const SwapchainSupport) bool {
//           return S.formats.len > 0 and S.modes.len > 0;
//         }
//         /// Returns the Swapchain support information for the given Device+Surface
//         /// Allocates memory for its formats and modes lists
//         pub fn create (
//             D : vk.Device.Physical,
//             S : vk.Surface,
//             A : zvk.Allocator,
//           ) !SwapchainSupport {
//           return zvk.Device.physical.SwapchainSupport{
//             .A       = A,
//             .caps    = try SwapchainSupport.getCapabilities(D, S),    // Surface Capabilities
//             .formats = try SwapchainSupport.getFormats(D, S, A),      // Surface Formats
//             .modes   = try SwapchainSupport.getPresentModes(D, S, A), // Present Modes
//              };
//         } //:: zvk.Device.physical.SwapchainSupport.create
//
//         pub fn destroy (
//             S : *zvk.Device.physical.SwapchainSupport,
//           ) void {
//           S.caps = .{};
//           S.A.zig.free(S.formats);
//           S.A.zig.free(S.modes);
//         } //:: zvk.Device.physical.SwapchainSupport.destroy
//       }; //:: zvk.Device.physical.SwapchainSupport
//
//       pub fn getProperties (
//           D : vk.Device.Physical,
//         ) vk.device.physical.Properties {
//         var result = vk.device.physical.Properties{};
//         vk.device.physical.getProperties(D, &result);
//         return result;
//       } //:: zvk.Device.physical.getProperties
//
//       /// Returns true if the {@arg D} device supports the default configuration of this library
//       pub fn isSuitable (
//           D : vk.Device.Physical,
//           S : vk.Surface,
//           E : zvk.Device.Extensions,
//           F : zvk.Features,
//           A : zvk.Allocator,
//         ) !bool {
//         var fam = try zvk.Device.Queue.Family.create(D, S, A);
//         defer fam.destroy();
//         var supp = try zvk.Device.physical.SwapchainSupport.create(D, S, A);
//         defer supp.destroy();
//         const props = zvk.Device.physical.getProperties(D);
//         return props.deviceType == vk.device.physical.types.Discrete
//            and fam.graphics     != null
//            and fam.present      != null
//            and try zvk.Device.extensions.supportsAll(D, E, A)
//            and zvk.Device.features.supportsAll(D, F)
//            and supp.hasSwapchain()
//            ; //:: suitability checks
//       } //:: zvk.Device.physical.isSuitable
//
//       pub fn findSuitable (
//           L : []const vk.Device.Physical,
//           S : vk.Surface,
//           E : zvk.Device.Extensions,
//           F : zvk.Features,
//           A : zvk.Allocator,
//         ) !vk.Device.Physical {
//         // Return early: First device when configured to do so
//         if (zvk.cfg.device.forceFirst) { return L[0]; }
//         // Search for a suitable device
//         for (L) |D| if (try zvk.Device.physical.isSuitable(D, S, E, F, A)) return D;
//         return error.device_NoSuitableGPU;
//       } //:: zvk.Device.physical.findSuitable
//
//       pub fn getList (
//           I : zvk.Instance,
//           A : zvk.Allocator,
//         ) ![]vk.device.Physical {
//         var count :u32= 0;
//         try vk.ok(vk.device.physical.getList(I.ct, &count, null));
//         if (count == 0) return error.device_NoVulkanSupport;
//         const result = try A.zig.alloc(vk.Device.Physical, count);
//         try vk.ok(vk.device.physical.getList(I.ct, &count, result.ptr));
//         return result;
//       } //:: zvk.Device.physical.getList
//
//       pub fn create (
//           I : zvk.Instance,
//           S : vk.Surface,
//           E : zvk.Device.Extensions,
//           F : zvk.Features,
//           A : zvk.Allocator,
//         ) !vk.Device.Physical {
//         // Get all devices
//         const devices = try zvk.Device.physical.getList(I, A);
//         defer A.zig.free(devices);
//         // Select the device that we want
//         return zvk.Device.physical.findSuitable(devices, S, E, F, A);
//       } //:: zvk.Device.physical.create
//     }; //:: zvk.Device.physical
//
//     pub const logical = struct {
//       pub fn setup (
//           queueCfgs : []const vk.device.queue.Cfg,
//           exts      : []const vk.String,
//           feats     : *vk.features.Root,
//         ) !vk.device.logical.Cfg {
//         // Specify validation layers for older implementations. Not needed in modern Vulkan.
//         const layerCount :u32= zvk.validation.layers.len;
//         const layers = if (zvk.validation.active) zvk.validation.layers[0].ptr else null;
//         // Return the result
//         return vk.device.logical.Cfg{
//           .sType                   = vk.stype.device.Cfg,     // : VkStructureType = @import("std").mem.zeroes(VkStructureType),
//           .pNext                   = feats,                // : ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
//           .flags                   = 0,                       // : VkDeviceCreateFlags = @import("std").mem.zeroes(VkDeviceCreateFlags),
//           .queueCreateInfoCount    = @intCast(queueCfgs.len), // : u32 = @import("std").mem.zeroes(u32),
//           .pQueueCreateInfos       = queueCfgs.ptr,           // : [*c]const VkDeviceQueueCreateInfo = @import("std").mem.zeroes([*c]const VkDeviceQueueCreateInfo),
//           .enabledLayerCount       = layerCount,              // : u32 = @import("std").mem.zeroes(u32),
//           .ppEnabledLayerNames     = &layers,                 // : [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
//           .enabledExtensionCount   = @intCast(exts.len),      // : u32 = @import("std").mem.zeroes(u32),
//           .ppEnabledExtensionNames = @ptrCast(exts.ptr),      // : [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
//           .pEnabledFeatures        = null,                   // : [*c]const VkPhysicalDeviceFeatures = @import("std").mem.zeroes([*c]const VkPhysicalDeviceFeatures),
//           }; //:: vk.device.logical.Cfg{ ... }
//       } //:: zvk.Device.logical.setup
//
//       pub fn create (
//          D : vk.Device.Physical,
//          S : vk.Surface,
//          E : zvk.Device.Extensions,
//          F : zvk.Features,
//          A : zvk.Allocator,
//         ) !vk.Device.Logical {
//         // Create the List of features
//         var feats = try F.toVulkan(A);
//         defer feats.destroy();
//         // Create the Queue Family information
//         var fam = try zvk.Device.Queue.Family.create(D, S, A);
//         defer fam.destroy();
//         // Create the config for each Queue
//         const queueCfgCount :u32= if (fam.graphics == fam.present) 1 else 2;
//         var queueCfgs = try A.zig.alloc(vk.device.queue.Cfg, queueCfgCount);
//         defer A.zig.free(queueCfgs);
//         queueCfgs[0] = try zvk.Device.Queue.setup(fam.graphics.?, 1.0);
//         if (fam.graphics != fam.present) queueCfgs[1] = try zvk.Device.Queue.setup(fam.present.?, 1.0);
//         // Create the Logical Device and return it
//         var result :vk.Device.Logical= null;
//         try vk.ok(vk.device.logical.create(D, &(try zvk.Device.logical.setup(
//           queueCfgs, E, feats.root)), A.vk, &result));
//         return result;
//       } //:: zvk.Device.logical.create
//     }; //:: zvk.Device.logical
//
//     pub const Queue = struct {
//       A         :zvk.Allocator,
//       graphics  :?Device.Queue.Entry= null,
//       present   :?Device.Queue.Entry= null,
//
//       pub fn setup (
//           famID    : u32,
//           priority : f32,  // Must be [0.0f .. 1.0f]
//         ) !vk.device.queue.Cfg {
//         // TODO: Assert priority is [0.0f .. 1.0f]
//         return vk.device.queue.Cfg{
//           .sType            = vk.stype.queue.Cfg, // : VkStructureType = @import("std").mem.zeroes(VkStructureType),
//           .pNext            = null,               // : ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
//           .flags            = 0,                  // : VkDeviceQueueCreateFlags = @import("std").mem.zeroes(VkDeviceQueueCreateFlags),
//           .queueFamilyIndex = famID,              // : u32 = @import("std").mem.zeroes(u32),
//           .queueCount       = 1,                  // : u32 = @import("std").mem.zeroes(u32),
//           .pQueuePriorities = &priority,          // : [*c]const f32 = @import("std").mem.zeroes([*c]const f32),
//           }; //:: vk.device.queue.Cfg{ ... }
//       } //:: zvk.Device.Queue.setup
//
//       pub fn create (
//          P : vk.Device.Physical,
//          L : vk.Device.Logical,
//          S : vk.Surface,
//          A : zvk.Allocator,
//         ) !zvk.Device.Queue {
//         var fam = try zvk.Device.Queue.Family.create(P, S, A);
//         defer fam.destroy();
//         const result = zvk.Device.Queue{
//           .A        = A,
//           .graphics = zvk.Device.Queue.Entry.create(L, fam.graphics),
//           .present  = zvk.Device.Queue.Entry.create(L, fam.present),
//           }; //:: zvk.Device.Queue{ ... }
//         return result;
//       } //:: zvk.Device.Queue.create
//
//       pub const Entry = struct {
//         id  :u32,
//         ct  :vk.device.Queue,
//
//         pub fn create (
//            L  : vk.Device.Logical,
//            id : ?u32,
//           ) ?zvk.Device.Queue.Entry {
//           if (id == null) return null;
//           var result = zvk.Device.Queue.Entry{.id= id.?, .ct= null};
//           vk.device.queue.get(L, result.id, 0, &result.ct);
//           return result;
//         } //:: zvk.Device.Queue.Entry.create
//       }; //:: zvk.Device.Queue.Entry
//
//       pub const Family = struct {
//         A         :zvk.Allocator,
//         props     :[]vk.device.queue.family.Properties,
//         graphics  :?u32= null,
//         present   :?u32= null,
//
//         /// Frees the Family Properties list, and sets every other value to empty
//         pub fn destroy (
//             F : *zvk.Device.Queue.Family,
//           ) void {
//           F.A.zig.free(F.props);
//           F.graphics = null;
//           F.present  = null;
//         } //:: zvk.Device.Queue.Family.destroy
//
//         /// Returns the Queue Families of the given device.
//         pub fn create (
//             D : vk.Device.Physical,
//             S : vk.Surface,
//             A : zvk.Allocator,
//           ) !zvk.Device.Queue.Family {
//           var result = zvk.Device.Queue.Family{
//             .A     = A,
//             .props = try zvk.Device.Queue.Family.getProperties(D, A)
//             };
//           for (result.props, 0..) |prop, id| {
//             if (vk.flags.Queue.fromInt(prop.queueFlags).hasAll(.{.graphics=true})) result.graphics = @intCast(id);
//             if (try zvk.Device.Queue.Family.canPresent(D, S, @intCast(id))) result.present = @intCast(id);
//             if (result.graphics != null and result.present != null) break; // Found both, so stop searching
//           }
//           return result;
//         } //:: zvk.Device.Queue.Family.create
//
//         pub fn canPresent (
//             D  : vk.Device.Physical,
//             S  : vk.Surface,
//             id : u32,
//           ) !bool {
//           var result :vk.Bool= vk.False;
//           try vk.ok(vk.device.physical.surface.getSupport(D, id, S, &result));
//           return result == vk.True;
//         } //:: zvk.Device.Queue.Family.canPresent
//
//         pub fn getProperties (
//             D : vk.Device.Physical,
//             A : zvk.Allocator,
//           ) ![]vk.device.queue.family.Properties {
//           var count :u32= 0;
//           vk.device.queue.family.getProperties(D, &count, null);
//           const result = try A.zig.alloc(vk.device.queue.family.Properties, count);
//           vk.device.queue.family.getProperties(D, &count, result.ptr);
//           return result;
//         } //:: zvk.Device.Queue.Family.getProperties
//       }; //:: zvk.Device.Queue.Family
//     }; //:: zvk.Device.Queue
//
//     pub const sync = struct {
//       pub fn waitIdle (D :*const Device) !void { try vk.ok(vk.sync.waitIdle(D.logical)); }
//     }; //:: zvk.Device.sync
//     pub const waitIdle = zvk.Device.sync.waitIdle;
//   }; //:: zvk.Device
//
//   //______________________________________
//   // @section Swapchain
//   //____________________________
//   pub const Swapchain = struct {
//     A           : zvk.Allocator,
//     ct          : vk.Swapchain,
//     cfg         : zvk.Swapchain.Cfg,
//     format      : vk.surface.Format,
//     mode        : vk.device.present.Mode,
//     size        : vk.Size,
//     imgMin      : u32,
//     imgs        : zvk.Swapchain.Images,
//     views       : zvk.Swapchain.ImageViews,
//     sync        : zvk.Swapchain.Sync,
//
//     //____________________________________
//     // Subtype aliases
//     pub const Image      = vk.Image;
//     pub const Images     = []zvk.Swapchain.Image;
//     pub const ImageView  = vk.ImageView;
//     pub const ImageViews = []zvk.Swapchain.ImageView;
//     pub const Cfg        = vk.swapchain.Cfg;
//     pub const SyncData   = struct { semaphore : zvk.sync.Semaphore };
//     pub const Sync       = []zvk.Swapchain.SyncData;
//     //____________________________________
//
//     pub const select = struct {
//       /// @descr Returns the preferred color format for the Swapchain Surface
//       /// @note
//       ///  Searches for {@link zvk.cfg.swapchain.color.*} support first.
//       ///  Returns the first supported color format found otherwise.
//       pub fn format (
//           S : *const zvk.Device.physical.SwapchainSupport,
//         ) vk.surface.Format {
//         for (S.formats) |sc| {
//           if (sc.format     == zvk.cfg.swapchain.color.format
//           and sc.colorSpace == zvk.cfg.swapchain.color.space)
//           { return sc; }
//         }
//         return S.formats[0];  // Otherwise return the first format
//       } //:: zvk.Swapchain.select.format
//
//       /// @descr Returns the preferred present mode for the Swapchain Surface
//       /// @note
//       ///  Searches for {@link zvk.cfg.device.present} support first.
//       ///  Returns FIFO if not found. _(guaranteed to exist by spec)_
//       pub fn mode (
//           S : *const zvk.Device.physical.SwapchainSupport,
//         ) vk.device.present.Mode {
//         for (S.modes) |m| if (m == zvk.cfg.device.present) return m;
//         return vk.device.present.Fifo; // Default to FiFo when Mailbox is not supported
//       } //:: zvk.Swapchain.select.mode
//
//       /// @descr Returns the size of the Swapchain Surface
//       pub fn size (
//           S  : *const zvk.Device.physical.SwapchainSupport,
//           sz : zvk.Size,
//         ) vk.Size {
//         // Exit early when the extents haven't changed
//         if (S.caps.currentExtent.width < std.math.maxInt(u32)) return S.caps.currentExtent;
//         // TODO: Compare measurements in pixels/units first, in case they don't match
//         return vk.Size{
//           .width = std.math.clamp(sz.width,
//             S.caps.minImageExtent.width,
//             S.caps.maxImageExtent.width, ),
//           .height = std.math.clamp(sz.height,
//             S.caps.minImageExtent.height,
//             S.caps.maxImageExtent.height, ),
//         };
//       } //:: zvk.Swapchain.select.size
//
//       /// @descr Returns the minimum number of images that the Swapchain will contain
//       pub fn imgMin (
//           S : *const zvk.Device.physical.SwapchainSupport,
//         ) u32 {
//         return std.math.clamp(
//           S.caps.minImageCount + 1,
//           S.caps.minImageCount,
//           S.caps.maxImageCount);
//       } //:: zvk.Swapchain.select.imgMin
//     }; //:: zvk.Swapchain.select
//
//     pub fn setup (
//         D      : zvk.Device,
//         S      : zvk.Surface,
//         imgMin : u32,
//         format : vk.surface.Format,
//         caps   : vk.surface.Capabilities,
//         mode   : vk.device.present.Mode,
//         A      : zvk.Allocator,
//       ) !vk.swapchain.Cfg {
//       var fam = try zvk.Device.Queue.Family.create(D.physical, S, A);
//       defer fam.destroy();
//       if (fam.graphics == null or fam.present == null) return error.swapchain_IncorrectGraphicsQueueFamily;
//       const exclusive = fam.graphics == fam.present;
//       const shareMode :vk.share.Mode= if (exclusive) vk.share.exclusive else vk.share.concurrent;
//       const famCount :u32= if (exclusive) 0 else 2;
//       var famIDs = try A.zig.alloc(u32, famCount);
//       defer A.zig.free(famIDs);
//       if (famIDs.len > 0) { famIDs[0] = fam.graphics.?; famIDs[1] = fam.present.?; }
//       // Create the Cfg object and return it
//       return vk.swapchain.Cfg{
//         .sType                 = vk.stype.swapchain.Cfg,               // VkStructureType = @import("std").mem.zeroes(VkStructureType),
//         .pNext                 = null,                                 // ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
//         .flags                 = zvk.cfg.swapchain.flags.toInt(),      // VkSwapchainCreateFlagsKHR = @import("std").mem.zeroes(VkSwapchainCreateFlagsKHR),
//         .surface               = S,                                    // VkSurfaceKHR = @import("std").mem.zeroes(VkSurfaceKHR),
//         .minImageCount         = imgMin,                               // u32 = @import("std").mem.zeroes(u32),
//         .imageFormat           = format.format,                        // VkFormat = @import("std").mem.zeroes(VkFormat),
//         .imageColorSpace       = format.colorSpace,                    // VkColorSpaceKHR = @import("std").mem.zeroes(VkColorSpaceKHR),
//         .imageExtent           = size,                                 // VkExtent2D = @import("std").mem.zeroes(VkExtent2D),
//         .imageArrayLayers      = 1, // Always 1, unless Stereoscopic   // u32 = @import("std").mem.zeroes(u32),
//         .imageUsage            = vk.flags.image.Usage.toInt(.{         // VkImageUsageFlags = @import("std").mem.zeroes(VkImageUsageFlags),
//           .colorAttachment     = true,
//           // TODO: transferDst
//           }), //:: .imageUsage
//         .imageSharingMode      = shareMode,                            // VkSharingMode = @import("std").mem.zeroes(VkSharingMode),
//         .queueFamilyIndexCount = @intCast(famIDs.len),                 // u32 = @import("std").mem.zeroes(u32),
//         .pQueueFamilyIndices   = famIDs.ptr,                           // [*c]const u32 = @import("std").mem.zeroes([*c]const u32),
//         .preTransform          = caps.currentTransform,                // VkSurfaceTransformFlagBitsKHR = @import("std").mem.zeroes(VkSurfaceTransformFlagBitsKHR),
//         .compositeAlpha        = zvk.cfg.swapchain.alpha.toInt(),      // VkCompositeAlphaFlagBitsKHR = @import("std").mem.zeroes(VkCompositeAlphaFlagBitsKHR),
//         .presentMode           = mode,                                 // VkPresentModeKHR = @import("std").mem.zeroes(VkPresentModeKHR),
//         .clipped               = vk.toBool(zvk.cfg.swapchain.clipped), // VkBool32 = @import("std").mem.zeroes(VkBool32),
//         .oldSwapchain          = null,                                 // VkSwapchainKHR = @import("std").mem.zeroes(VkSwapchainKHR),
//         };
//     } //:: zvk.Swapchain.setup
//
//     pub const images = struct {
//       pub fn getList (
//           D  : zvk.Device,
//           S  : vk.Swapchain,
//           A  : zvk.Allocator,
//         ) !zvk.Swapchain.Images {
//         var count :u32= 0;
//         try vk.ok(vk.swapchain.images.getList(D.logical, S, &count, null));
//         const result = try A.zig.alloc(zvk.Swapchain.Image, count);
//         try vk.ok(vk.swapchain.images.getList(D.logical, S, &count, result.ptr));
//         return result;
//       } //:: zvk.Swapchain.images.getList
//
//       pub fn getViews (
//           D : zvk.Device,
//           L : zvk.Swapchain.Images,
//           C : vk.color.Format,
//           A : zvk.Allocator,
//         ) !zvk.Swapchain.ImageViews {
//         var result = try A.zig.alloc(zvk.Swapchain.ImageView, L.len);
//         for (L, 0..) |img, id| {
//           try vk.ok(vk.image.view.create(D.logical, &vk.image.view.Cfg{
//             .sType            = vk.stype.image.view.Cfg,
//             .pNext            = null,
//             .flags            = 0,
//             .image            = img,
//             .viewType         = vk.image.view.types.dim2D,
//             .format           = C,
//             .components       = vk.color.component.Mapping{
//               .r              = vk.color.component.Identity,
//               .g              = vk.color.component.Identity,
//               .b              = vk.color.component.Identity,
//               .a              = vk.color.component.Identity
//               }, //:: .components
//             .subresourceRange = vk.image.Subresource{
//               .aspectMask     = vk.flags.image.Aspect.toInt(.{
//                 .color        = true,
//                 }), //:: .aspectMask
//               .baseMipLevel   = 0,
//               .levelCount     = 1,
//               .baseArrayLayer = 0,
//               .layerCount     = 1,
//               }, //:: .subresourceRange
//             }, A.vk, &result[id]));
//         }
//         return result;
//       } //:: zvk.Swapchain.images.getViews
//
//       pub fn nextID (
//           S  : *zvk.Swapchain,
//           D  : zvk.Device,
//           Sd : zvk.Swapchain.SyncData,
//         ) !u32 {
//         var result :u32= 0;
//         const fence :vk.sync.Fence= null;
//         try vk.ok(vk.swapchain.images.getNext(D.logical, S.ct, 1_000_000_000, Sd.semaphore.ct, fence, &result));
//         return result;
//       } //:: zvk.Swapchain.images.nextID
//
//       pub fn next (
//           S  : *const zvk.Swapchain,
//           D  : zvk.Device,
//           Sd : zvk.Swapchain.SyncData,
//         ) !zvk.Swapchain.Image {
//         return S.imgs[try zvk.Swapchain.images.nextID(S, D, Sd)];
//       } //:: zvk.Swapchain.images.next
//     }; //:: zvk.Swapchain.images
//     pub const nextImage = zvk.Swapchain.images.next;
//
//     pub const sync = struct {
//       pub fn getList (
//           D : zvk.Device,
//           N : usize,
//           A : zvk.Allocator,
//         ) !zvk.Swapchain.Sync {
//         var result = try A.zig.alloc(zvk.Swapchain.SyncData, N);
//         for (0..N) |id| result[id].semaphore = try zvk.sync.Semaphore.create(D, A);
//         return result;
//       } //:: zvk.Swapchain.sync.getList
//
//       pub fn destroy (
//           S : *zvk.Swapchain.Sync,
//           D : zvk.Device,
//           A : zvk.Allocator,
//         ) void {
//         for (0..S.len) |id| S.*[id].semaphore.destroy(D);
//         A.zig.free(S.*);
//       } //:: zvk.Swapchain.sync.destroy
//     }; //:: zvk.Swapchain.sync
//
//     pub fn create (
//         D  : zvk.Device,
//         S  : zvk.Surface,
//         sz : zvk.Size,
//         A  : zvk.Allocator,
//       ) !zvk.Swapchain {
//       var supp = try zvk.Device.physical.SwapchainSupport.create(D.physical, S, A);
//       defer supp.destroy();
//       // Create the Configuration
//       var result = zvk.Swapchain{
//         .A      = A,
//         .format = zvk.Swapchain.select.format(&supp),
//         .mode   = zvk.Swapchain.select.mode(&supp),
//         .size   = zvk.Swapchain.select.size(&supp, sz),
//         .imgMin = zvk.Swapchain.select.imgMin(&supp),
//         .ct     = null,
//         .cfg    = undefined,
//         .imgs   = undefined,
//         .views  = undefined,
//         .sync   = undefined,
//         };
//       result.cfg = try zvk.Swapchain.setup(D, S,
//         result.imgMin, result.format, supp.caps, result.mode,
//         result.A); //:: result.cfg
//       // Create the handle
//       try vk.ok(vk.swapchain.create(D.logical, &result.cfg, result.A.vk, &result.ct));
//       // Create the Images
//       result.imgs  = try zvk.Swapchain.images.getList(D, result.ct, result.A);
//       result.views = try zvk.Swapchain.images.getViews(D, result.imgs, result.format.format, result.A);
//       result.sync  = try zvk.Swapchain.sync.getList(D, result.views.len, result.A);
//       return result;
//     } //:: zvk.Swapchain.create
//
//     pub fn destroy (
//         S : *zvk.Swapchain,
//         D : zvk.Device,
//       ) void {
//       zvk.Swapchain.sync.destroy(&S.sync, D, S.A);
//       for (S.views) |view| vk.image.view.destroy(D.logical, view, S.A.vk);
//       vk.swapchain.destroy(D.logical, S.ct, S.A.vk);
//     } //:: zvk.Swapchain.destroy
//   }; //:: zvk.Swapchain
//
//   pub const CommandBatch = zvk.command.Batch;
//   pub const command = struct {
//     pub const Batch = struct {
//       A       :zvk.Allocator,
//       pool    :vk.command.Pool,
//       buffer  :[]vk.command.Buffer,
//
//       pub const CreateOptions = struct {
//         transient : bool  = zvk.cfg.command.transient,
//         reset     : bool  = zvk.cfg.command.reset,
//         protected : bool  = zvk.cfg.command.protected,
//         primary   : bool  = zvk.cfg.command.primary,
//         buffers   : usize = 1,
//         }; //:: zvk.command.Batch.CreateOptions
//
//       pub fn create (
//           D  : zvk.Device,
//           in : zvk.command.Batch.CreateOptions,
//           A  : zvk.Allocator,
//         ) !zvk.command.Batch {
//         // FIX: Non-Graphics Commands
//         if (D.queue.graphics == null) return error.command_InvalidGraphicsQueue;
//         var result = zvk.command.Batch{.A= A, .pool=undefined, .buffer=undefined};
//         // Create the Command Pool
//         try vk.ok(vk.command.pool.create(D.logical, &vk.command.pool.Cfg{
//           .sType            = vk.stype.command.pool.Cfg,      // VkStructureType = @import("std").mem.zeroes(VkStructureType),
//           .pNext            = null,                           // ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
//           .flags            = vk.flags.command.Pool.toInt(.{  // VkCommandPoolCreateFlags = @import("std").mem.zeroes(VkCommandPoolCreateFlags),
//             .transient      = in.transient,
//             .reset          = in.reset,
//             .protected      = in.protected,
//             }),
//           .queueFamilyIndex = D.queue.graphics.?.id,          // u32 = @import("std").mem.zeroes(u32),
//           }, result.A.vk, &result.pool));
//         // Create the Command Buffer
//         result.buffer = try result.A.zig.alloc(vk.command.Buffer, in.buffers);
//         try vk.ok(vk.command.buffer.create(D.logical, &vk.command.buffer.Cfg{
//           .sType              = vk.stype.command.buffer.Cfg,      // VkStructureType = @import("std").mem.zeroes(VkStructureType),
//           .pNext              = null,                             // ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
//           .commandPool        = result.pool,                      // VkCommandPool = @import("std").mem.zeroes(VkCommandPool),
//           .level              =                                   // VkCommandBufferLevel = @import("std").mem.zeroes(VkCommandBufferLevel),
//             if (in.primary)   vk.command.buffer.level.Primary
//             else              vk.command.buffer.level.Secondary,
//           .commandBufferCount = @intCast(result.buffer.len),      // u32 = @import("std").mem.zeroes(u32),
//           }, result.buffer.ptr));
//         return result;
//       } //:: zvk.command.Batch.create
//
//       pub fn destroy (
//           C : *zvk.command.Batch,
//           D : zvk.Device,
//         ) void {
//         // vk.command.buffer.destroy(D.logical, C.pool, C.buffer.len, C.buffer.ptr);  // Freed by destroying the pool
//         vk.command.pool.destroy(D.logical, C.pool, C.A.vk);
//         C.A.zig.free(C.buffer);
//       } //:: zvk.command.Batch.destroy
//     }; //:: zvk.command.Batch
//   }; //:: zvk.command
//
//   pub const sync = struct {
//     pub const Fence = struct {
//       A    :zvk.Allocator,
//       ct   :vk.sync.Fence,
//       cfg  :vk.sync.fence.Cfg= .{.sType= vk.stype.sync.fence.Cfg, .pNext= null},
//
//       pub fn create (
//         D  : zvk.Device,
//         in : struct {
//           signaled :bool= true, },
//         A  : zvk.Allocator,
//         ) !zvk.sync.Fence {
//         var result = zvk.sync.Fence{.A=A, .ct=undefined};
//         result.cfg.flags = vk.flags.sync.Fence.toInt(.{
//           .signaled = in.signaled
//           }); //:: result.cfg.flags
//         try vk.ok(vk.sync.fence.create(D.logical, &result.cfg, result.A.vk, &result.ct));
//         return result;
//       } //:: zvk.sync.Fence.create
//
//       pub fn destroy (
//           F : *zvk.sync.Fence,
//           D : zvk.Device,
//         ) void {
//         vk.sync.fence.destroy(D.logical, F.ct, F.A.vk);
//       } //:: zvk.sync.Fence.destroy
//     }; //:: zvk.sync.Fence
//
//     pub const Semaphore = struct {
//       A    :zvk.Allocator,
//       ct   :vk.sync.Semaphore,
//       cfg  :vk.sync.semaphore.Cfg= .{.sType= vk.stype.sync.semaphore.Cfg, .pNext= null, .flags= 0},
//
//       pub fn create (
//         D  : zvk.Device,
//         A  : zvk.Allocator,
//         ) !zvk.sync.Semaphore {
//         var result = zvk.sync.Semaphore{.A=A, .ct=undefined};
//         try vk.ok(vk.sync.semaphore.create(D.logical, &result.cfg, result.A.vk, &result.ct));
//         return result;
//       } //:: zvk.sync.Semaphore.create
//
//       pub fn destroy (
//           F : *zvk.sync.Semaphore,
//           D : zvk.Device,
//         ) void {
//         vk.sync.semaphore.destroy(D.logical, F.ct, F.A.vk);
//       } //:: zvk.sync.Semaphore.destroy
//     }; //:: zvk.sync.Semaphore
//   }; //:: zvk.sync
// }; //:: zvk
//

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//______________________________________
// TODO: External zvk_thing_fn API for C
const C_ = struct {
  export fn zvk_tmp_add  (a :c_int, b :c_int) c_int { return a + b; }
  export fn zvk_tmp_add2 (a :  u32, b :  u32)   u32 { return a + b; }
}; comptime { _ = &C_; } // Force exports to be analyzed
//______________________________________

