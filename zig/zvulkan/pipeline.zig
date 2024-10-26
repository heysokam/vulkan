//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @fileoverview Pipeline Related Tools
//______________________________________|
// @deps vulkan
const c      = @import("../lib/vulkan.zig");
const vk     = @import("./types.zig");
const flags  = @import("./flags.zig").flags;
const FlagsT = flags.T;

pub const pipeline        = struct {
  pub const destroy       = c.vkDestroyPipeline;
  pub const BindPoint     = enum(c_int) {
    graphics              =           0,  // VK_PIPELINE_BIND_POINT_GRAPHICS               :c_int=  0;
    compute               =           1,  // VK_PIPELINE_BIND_POINT_COMPUTE                :c_int=  1;
    raytracing            =  1000165000,  // VK_PIPELINE_BIND_POINT_RAY_TRACING_KHR        :c_int=  1000165000;
    HUAWEY_subpassShading =  1000369003,  // VK_PIPELINE_BIND_POINT_SUBPASS_SHADING_HUAWEI :c_int=  1000369003;
  }; //:: vk.pipeline.BindPoint

  pub const graphics     = struct {
    pub const T          = c.VkPipeline;
    pub const Cfg        = c.VkGraphicsPipelineCreateInfo;
    pub const create     = c.vkCreateGraphicsPipelines;
    pub const destroy    = pipeline.destroy;

    pub const viewport   = struct {
      pub const T        = c.VkViewport;
      pub const Cfg      = c.VkPipelineViewportStateCreateInfo;
      pub const Flags    = packed struct {
        __reserved_bits_00_31 :u32=0,
        pub usingnamespace FlagsT(@This(), vk.Flags);
      }; //:: vk.pipeline.graphics.viewport.Flags
      pub const Scissor  = c.VkRect2D;
    }; //:: vk.pipeline.graphics.viewport
    pub const vertex     = struct {
      pub const Topology = pipeline.graphics.vertex.topology.Kind;
      pub const topology = struct {
        pub const Kind = enum(c_int) {
          point_list               , // VK_PRIMITIVE_TOPOLOGY_POINT_LIST                    :c_int=   0;
          line_list                , // VK_PRIMITIVE_TOPOLOGY_LINE_LIST                     :c_int=   1;
          line_strip               , // VK_PRIMITIVE_TOPOLOGY_LINE_STRIP                    :c_int=   2;
          triangle_list            , // VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST                 :c_int=   3;
          triangle_strip           , // VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP                :c_int=   4;
          triangle_fan             , // VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN                  :c_int=   5;
          line_list_adjacency      , // VK_PRIMITIVE_TOPOLOGY_LINE_LIST_WITH_ADJACENCY      :c_int=   6;
          line_strip_adjacency     , // VK_PRIMITIVE_TOPOLOGY_LINE_STRIP_WITH_ADJACENCY     :c_int=   7;
          triangle_list_adjacency  , // VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST_WITH_ADJACENCY  :c_int=   8;
          triangle_strip_adjacency , // VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP_WITH_ADJACENCY :c_int=   9;
          patch_list               , // VK_PRIMITIVE_TOPOLOGY_PATCH_LIST                    :c_int=  10;
          }; //:: vk.pipeline.graphics.vertex.topology.Kind
        }; //:: vk.pipeline.graphics.vertex.topology
      pub const input    = struct {
        pub const Cfg    = c.VkPipelineVertexInputStateCreateInfo;
        pub const Flags = packed struct {
          __reserved_bits_00_31 :u32=0,
          pub usingnamespace FlagsT(@This(), vk.Flags);
        }; //:: vk.pipeline.graphics.vertex.input.Flags
      }; //:: vk.pipeline.graphics.vertex.input
      pub const assembly = struct {
        pub const Cfg    = c.VkPipelineInputAssemblyStateCreateInfo;
        pub const Flags  = packed struct {
          __reserved_bits_00_31 :u32=0,
          pub usingnamespace FlagsT(@This(), vk.Flags);
        }; //:: vk.pipeline.graphics.vertex.assembly.Flags
      }; //:: vk.pipeline.graphics.vertex.assembly
    }; //:: vk.pipeline.graphics.vertex
    pub const raster     = struct {
      pub const Cfg      = c.VkPipelineRasterizationStateCreateInfo;
      pub const Flags    = packed struct {
        __reserved_bits_00_31 :u32=0,
        pub usingnamespace FlagsT(@This(), vk.Flags);
      }; //:: vk.pipeline.graphics.raster.Flags
      pub const Polygon  = enum(c_int) {
        fill              =          0, // VK_POLYGON_MODE_FILL              :c_int= 0;
        line              =          1, // VK_POLYGON_MODE_LINE              :c_int= 1;
        point             =          2, // VK_POLYGON_MODE_POINT             :c_int= 2;
        NV_fill_rectangle = 1000153000, // VK_POLYGON_MODE_FILL_RECTANGLE_NV :c_int= 1000153000;
      }; //:: vk.pipeline.graphics.raster.Polygon
      pub const Cull      = packed struct {
        front  :bool = false,  // 00 :: VK_CULL_MODE_FRONT_BIT          : c_int = 1;
        back   :bool = false,  // 01 :: VK_CULL_MODE_BACK_BIT           : c_int = 2;
        __reserved_bits_02_31 :u30=0,
        pub usingnamespace FlagsT(@This(), vk.Flags);
        pub const none         = pipeline.Flags.fromInt(0); // 00 :: VK_CULL_MODE_NONE               : c_int = 0;
        pub const frontAndBack = pipeline.Flags.fromInt(3); // 00 :: VK_CULL_MODE_FRONT_AND_BACK     : c_int = 3;
      }; //:: vk.pipeline.graphics.raster.Cull
      pub const Face  = enum(c_int) {
        ccw = 0, // VK_FRONT_FACE_COUNTER_CLOCKWISE :c_int=  0;
        cw  = 1, // VK_FRONT_FACE_CLOCKWISE         :c_int=  1;
      }; //:: vk.pipeline.graphics.raster.Face
      pub const msaa     = struct {
        pub const Cfg    = c.VkPipelineMultisampleStateCreateInfo;
        pub const Flags  = packed struct {
          __reserved_bits_00_31 :u32=0,
          pub usingnamespace FlagsT(@This(), vk.Flags);
        }; //:: vk.pipeline.graphics.raster.msaa.Flags
        pub const Samples = flags.Samples;
      }; //:: vk.pipeline.graphics.raster.msaa
      pub const blend    = struct {
        pub const T      = c.VkPipelineColorBlendAttachmentState;
        pub const Cfg    = c.VkPipelineColorBlendStateCreateInfo;
        pub const Flags  = packed struct {
          rasterizationOrder_attachmentAccess :bool = false, // 00 :: VK_PIPELINE_COLOR_BLEND_STATE_CREATE_RASTERIZATION_ORDER_ATTACHMENT_ACCESS_BIT_EXT :c_int= 1;
          __reserved_bits_01_31 :u31=0,
          pub usingnamespace FlagsT(@This(), vk.Flags);
        }; //:: vk.pipeline.graphics.raster.blend.Flags
        pub const Factor = enum(c_int) {
          zero                   =  0, // VK_BLEND_FACTOR_ZERO                     :c_int=   0;
          one                    =  1, // VK_BLEND_FACTOR_ONE                      :c_int=   1;
          srcColor               =  2, // VK_BLEND_FACTOR_SRC_COLOR                :c_int=   2;
          oneMinus_srcColor      =  3, // VK_BLEND_FACTOR_ONE_MINUS_SRC_COLOR      :c_int=   3;
          dstColor               =  4, // VK_BLEND_FACTOR_DST_COLOR                :c_int=   4;
          oneMinus_dstColor      =  5, // VK_BLEND_FACTOR_ONE_MINUS_DST_COLOR      :c_int=   5;
          srcAlpha               =  6, // VK_BLEND_FACTOR_SRC_ALPHA                :c_int=   6;
          oneMinus_srcAlpha      =  7, // VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA      :c_int=   7;
          dstAlpha               =  8, // VK_BLEND_FACTOR_DST_ALPHA                :c_int=   8;
          oneMinus_dstAlpha      =  9, // VK_BLEND_FACTOR_ONE_MINUS_DST_ALPHA      :c_int=   9;
          constantColor          = 10, // VK_BLEND_FACTOR_CONSTANT_COLOR           :c_int=  10;
          oneMinus_constantColor = 11, // VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_COLOR :c_int=  11;
          constantAlpha          = 12, // VK_BLEND_FACTOR_CONSTANT_ALPHA           :c_int=  12;
          oneMinus_constantAlpha = 13, // VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_ALPHA :c_int=  13;
          srcAlpha_saturate      = 14, // VK_BLEND_FACTOR_SRC_ALPHA_SATURATE       :c_int=  14;
          src1Color              = 15, // VK_BLEND_FACTOR_SRC1_COLOR               :c_int=  15;
          oneMinus_src1Color     = 16, // VK_BLEND_FACTOR_ONE_MINUS_SRC1_COLOR     :c_int=  16;
          src1Alpha              = 17, // VK_BLEND_FACTOR_SRC1_ALPHA               :c_int=  17;
          oneMinus_src1Alpha     = 18, // VK_BLEND_FACTOR_ONE_MINUS_SRC1_ALPHA     :c_int=  18;
        }; //:: vk.pipeline.graphics.raster.blend.Factor
        pub const Op = enum(c_int) {
          add                    =          0, // VK_BLEND_OP_ADD                    :c_int=  0;
          subtract               =          1, // VK_BLEND_OP_SUBTRACT               :c_int=  1;
          subtract_reverse       =          2, // VK_BLEND_OP_REVERSE_SUBTRACT       :c_int=  2;
          min                    =          3, // VK_BLEND_OP_MIN                    :c_int=  3;
          max                    =          4, // VK_BLEND_OP_MAX                    :c_int=  4;
          zero                   = 1000148000, // VK_BLEND_OP_ZERO_EXT               :c_int=  1000148000;
          src                    = 1000148001, // VK_BLEND_OP_SRC_EXT                :c_int=  1000148001;
          dst                    = 1000148002, // VK_BLEND_OP_DST_EXT                :c_int=  1000148002;
          src_over               = 1000148003, // VK_BLEND_OP_SRC_OVER_EXT           :c_int=  1000148003;
          dst_over               = 1000148004, // VK_BLEND_OP_DST_OVER_EXT           :c_int=  1000148004;
          src_in                 = 1000148005, // VK_BLEND_OP_SRC_IN_EXT             :c_int=  1000148005;
          dst_in                 = 1000148006, // VK_BLEND_OP_DST_IN_EXT             :c_int=  1000148006;
          src_out                = 1000148007, // VK_BLEND_OP_SRC_OUT_EXT            :c_int=  1000148007;
          dst_out                = 1000148008, // VK_BLEND_OP_DST_OUT_EXT            :c_int=  1000148008;
          src_atop               = 1000148009, // VK_BLEND_OP_SRC_ATOP_EXT           :c_int=  1000148009;
          dst_atop               = 1000148010, // VK_BLEND_OP_DST_ATOP_EXT           :c_int=  1000148010;
          xor                    = 1000148011, // VK_BLEND_OP_XOR_EXT                :c_int=  1000148011;
          multiply               = 1000148012, // VK_BLEND_OP_MULTIPLY_EXT           :c_int=  1000148012;
          screen                 = 1000148013, // VK_BLEND_OP_SCREEN_EXT             :c_int=  1000148013;
          overlay                = 1000148014, // VK_BLEND_OP_OVERLAY_EXT            :c_int=  1000148014;
          darken                 = 1000148015, // VK_BLEND_OP_DARKEN_EXT             :c_int=  1000148015;
          lighten                = 1000148016, // VK_BLEND_OP_LIGHTEN_EXT            :c_int=  1000148016;
          dodge_color            = 1000148017, // VK_BLEND_OP_COLORDODGE_EXT         :c_int=  1000148017;
          burn_color             = 1000148018, // VK_BLEND_OP_COLORBURN_EXT          :c_int=  1000148018;
          light_hard             = 1000148019, // VK_BLEND_OP_HARDLIGHT_EXT          :c_int=  1000148019;
          light_soft             = 1000148020, // VK_BLEND_OP_SOFTLIGHT_EXT          :c_int=  1000148020;
          difference             = 1000148021, // VK_BLEND_OP_DIFFERENCE_EXT         :c_int=  1000148021;
          exclusion              = 1000148022, // VK_BLEND_OP_EXCLUSION_EXT          :c_int=  1000148022;
          invert                 = 1000148023, // VK_BLEND_OP_INVERT_EXT             :c_int=  1000148023;
          invert_rgb             = 1000148024, // VK_BLEND_OP_INVERT_RGB_EXT         :c_int=  1000148024;
          dodge_linear           = 1000148025, // VK_BLEND_OP_LINEARDODGE_EXT        :c_int=  1000148025;
          burn_linear            = 1000148026, // VK_BLEND_OP_LINEARBURN_EXT         :c_int=  1000148026;
          light_vivid            = 1000148027, // VK_BLEND_OP_VIVIDLIGHT_EXT         :c_int=  1000148027;
          light_linear           = 1000148028, // VK_BLEND_OP_LINEARLIGHT_EXT        :c_int=  1000148028;
          light_pin              = 1000148029, // VK_BLEND_OP_PINLIGHT_EXT           :c_int=  1000148029;
          mix_hard               = 1000148030, // VK_BLEND_OP_HARDMIX_EXT            :c_int=  1000148030;
          hsl_hue                = 1000148031, // VK_BLEND_OP_HSL_HUE_EXT            :c_int=  1000148031;
          hsl_saturation         = 1000148032, // VK_BLEND_OP_HSL_SATURATION_EXT     :c_int=  1000148032;
          hsl_color              = 1000148033, // VK_BLEND_OP_HSL_COLOR_EXT          :c_int=  1000148033;
          hsl_luminosity         = 1000148034, // VK_BLEND_OP_HSL_LUMINOSITY_EXT     :c_int=  1000148034;
          plus                   = 1000148035, // VK_BLEND_OP_PLUS_EXT               :c_int=  1000148035;
          plus_clamped           = 1000148036, // VK_BLEND_OP_PLUS_CLAMPED_EXT       :c_int=  1000148036;
          plus_clamped_alpha     = 1000148037, // VK_BLEND_OP_PLUS_CLAMPED_ALPHA_EXT :c_int=  1000148037;
          plus_darker            = 1000148038, // VK_BLEND_OP_PLUS_DARKER_EXT        :c_int=  1000148038;
          minus                  = 1000148039, // VK_BLEND_OP_MINUS_EXT              :c_int=  1000148039;
          minus_clamped          = 1000148040, // VK_BLEND_OP_MINUS_CLAMPED_EXT      :c_int=  1000148040;
          contrast               = 1000148041, // VK_BLEND_OP_CONTRAST_EXT           :c_int=  1000148041;
          invert_ovg             = 1000148042, // VK_BLEND_OP_INVERT_OVG_EXT         :c_int=  1000148042;
          red                    = 1000148043, // VK_BLEND_OP_RED_EXT                :c_int=  1000148043;
          green                  = 1000148044, // VK_BLEND_OP_GREEN_EXT              :c_int=  1000148044;
          blue                   = 1000148045, // VK_BLEND_OP_BLUE_EXT               :c_int=  1000148045;
        }; //:: vk.pipeline.graphics.raster.blend.Op
      }; //:: vk.pipeline.graphics.raster.blend

      pub const LogicOp = enum(c_int) {
        clear         =  0,  // VK_LOGIC_OP_CLEAR         :c_int=   0;
        And           =  1,  // VK_LOGIC_OP_AND           :c_int=   1;
        and_reverse   =  2,  // VK_LOGIC_OP_AND_REVERSE   :c_int=   2;
        copy          =  3,  // VK_LOGIC_OP_COPY          :c_int=   3;
        and_inverted  =  4,  // VK_LOGIC_OP_AND_INVERTED  :c_int=   4;
        noOp          =  5,  // VK_LOGIC_OP_NO_OP         :c_int=   5;
        xor           =  6,  // VK_LOGIC_OP_XOR           :c_int=   6;
        Or            =  7,  // VK_LOGIC_OP_OR            :c_int=   7;
        nor           =  8,  // VK_LOGIC_OP_NOR           :c_int=   8;
        equivalent    =  9,  // VK_LOGIC_OP_EQUIVALENT    :c_int=   9;
        invert        = 10,  // VK_LOGIC_OP_INVERT        :c_int=  10;
        or_reverse    = 11,  // VK_LOGIC_OP_OR_REVERSE    :c_int=  11;
        copy_inverted = 12,  // VK_LOGIC_OP_COPY_INVERTED :c_int=  12;
        or_inverted   = 13,  // VK_LOGIC_OP_OR_INVERTED   :c_int=  13;
        nand          = 14,  // VK_LOGIC_OP_NAND          :c_int=  14;
        set           = 15,  // VK_LOGIC_OP_SET           :c_int=  15;
      }; //:: vk.pipeline.graphics.raster.LogicOp
    }; //:: vk.pipeline.graphics.raster
    pub const shape      = struct {
      pub const T        = c.VkPipelineLayout;
      pub const Cfg      = c.VkPipelineLayoutCreateInfo;
      pub const Flags    = packed struct {
        __reserved_bit_00 :u1=0,
        independentSets  :bool = false,  // 01 :: VK_PIPELINE_LAYOUT_CREATE_INDEPENDENT_SETS_BIT_EXT :c_int=  2;
        __reserved_bits_02_31 :u30=0,
        pub usingnamespace FlagsT(@This(), vk.Flags);
      }; //:: vk.pipeline.graphics.shape.Flags
      pub const create   = c.vkCreatePipelineLayout;
      pub const destroy  = c.vkDestroyPipelineLayout;
    }; //:: vk.pipeline.graphics.shape
  }; //:: vk.pipeline.graphics

  pub const compute      = struct {
    pub const T          = c.VkPipeline;
    pub const Cfg        = c.VkComputePipelineCreateInfo;
  }; //:: vk.pipeline.compute

  pub const state        = struct {
    pub const Dynamic    = pipeline.state.dynamic.Kind;
    pub const dynamic    = struct {
      pub const Cfg      = c.VkPipelineDynamicStateCreateInfo;
      pub const Kind     = enum(c.VkDynamicState) {
        viewport                                =           0, // VK_DYNAMIC_STATE_VIEWPORT                                :c_int=  0;
        scissor                                 =           1, // VK_DYNAMIC_STATE_SCISSOR                                 :c_int=  1;
        lineWidth                               =           2, // VK_DYNAMIC_STATE_LINE_WIDTH                              :c_int=  2;
        depth_bias                              =           3, // VK_DYNAMIC_STATE_DEPTH_BIAS                              :c_int=  3;
        blend_constants                         =           4, // VK_DYNAMIC_STATE_BLEND_CONSTANTS                         :c_int=  4;
        depth_bounds                            =           5, // VK_DYNAMIC_STATE_DEPTH_BOUNDS                            :c_int=  5;
        stencil_mask_compare                    =           6, // VK_DYNAMIC_STATE_STENCIL_COMPARE_MASK                    :c_int=  6;
        stencil_mask_write                      =           7, // VK_DYNAMIC_STATE_STENCIL_WRITE_MASK                      :c_int=  7;
        stencil_reference                       =           8, // VK_DYNAMIC_STATE_STENCIL_REFERENCE                       :c_int=  8;

        NV_viewport_WScaling                    =  1000087000, // VK_DYNAMIC_STATE_VIEWPORT_W_SCALING_NV                   :c_int=  1000087000;

        discardRectangle                        =  1000099000, // VK_DYNAMIC_STATE_DISCARD_RECTANGLE_EXT                   :c_int=  1000099000;
        discardRectangle_enable                 =  1000099001, // VK_DYNAMIC_STATE_DISCARD_RECTANGLE_ENABLE_EXT            :c_int=  1000099001;
        discardRectangle_mode                   =  1000099002, // VK_DYNAMIC_STATE_DISCARD_RECTANGLE_MODE_EXT              :c_int=  1000099002;

        sampleLocations                         =  1000143000, // VK_DYNAMIC_STATE_SAMPLE_LOCATIONS_EXT                    :c_int=  1000143000;

        NV_viewport_shadingRatePalette          =  1000164004, // VK_DYNAMIC_STATE_VIEWPORT_SHADING_RATE_PALETTE_NV        :c_int=  1000164004;
        NV_viewport_coarseSampleOrder           =  1000164006, // VK_DYNAMIC_STATE_VIEWPORT_COARSE_SAMPLE_ORDER_NV         :c_int=  1000164006;

        NV_exclusiveScissor_enable              =  1000205000, // VK_DYNAMIC_STATE_EXCLUSIVE_SCISSOR_ENABLE_NV             :c_int=  1000205000;
        NV_exclusiveScissor                     =  1000205001, // VK_DYNAMIC_STATE_EXCLUSIVE_SCISSOR_NV                    :c_int=  1000205001;

        fragment_shadingRate                    =  1000226000, // VK_DYNAMIC_STATE_FRAGMENT_SHADING_RATE_KHR               :c_int=  1000226000;

        lineStipple                             =  1000259000, // VK_DYNAMIC_STATE_LINE_STIPPLE_KHR                        :c_int=  1000259000;

        mode_cull                               =  1000267000, // VK_DYNAMIC_STATE_CULL_MODE                               :c_int=  1000267000;
        frontFace                               =  1000267001, // VK_DYNAMIC_STATE_FRONT_FACE                              :c_int=  1000267001;
        primitiveTopology                       =  1000267002, // VK_DYNAMIC_STATE_PRIMITIVE_TOPOLOGY                      :c_int=  1000267002;
        viewport_withCount                      =  1000267003, // VK_DYNAMIC_STATE_VIEWPORT_WITH_COUNT                     :c_int=  1000267003;
        scissor_withCount                       =  1000267004, // VK_DYNAMIC_STATE_SCISSOR_WITH_COUNT                      :c_int=  1000267004;
        vertex_input_bindingStride              =  1000267005, // VK_DYNAMIC_STATE_VERTEX_INPUT_BINDING_STRIDE             :c_int=  1000267005;
        depth_test_enable                       =  1000267006, // VK_DYNAMIC_STATE_DEPTH_TEST_ENABLE                       :c_int=  1000267006;
        depth_write_enable                      =  1000267007, // VK_DYNAMIC_STATE_DEPTH_WRITE_ENABLE                      :c_int=  1000267007;
        depth_compare_op                        =  1000267008, // VK_DYNAMIC_STATE_DEPTH_COMPARE_OP                        :c_int=  1000267008;
        depth_testBounds_enable                 =  1000267009, // VK_DYNAMIC_STATE_DEPTH_BOUNDS_TEST_ENABLE                :c_int=  1000267009;
        stencil_test_enable                     =  1000267010, // VK_DYNAMIC_STATE_STENCIL_TEST_ENABLE                     :c_int=  1000267010;
        stencil_op                              =  1000267011, // VK_DYNAMIC_STATE_STENCIL_OP                              :c_int=  1000267011;

        raytracing_pipeline_stack_size          =  1000347000, // VK_DYNAMIC_STATE_RAY_TRACING_PIPELINE_STACK_SIZE_KHR     :c_int=  1000347000;

        vertex_input                            =  1000352000, // VK_DYNAMIC_STATE_VERTEX_INPUT_EXT                        :c_int=  1000352000;

        patchControlPoints                      =  1000377000, // VK_DYNAMIC_STATE_PATCH_CONTROL_POINTS_EXT                :c_int=  1000377000;
        rasterizer_discard_enable               =  1000377001, // VK_DYNAMIC_STATE_RASTERIZER_DISCARD_ENABLE               :c_int=  1000377001;
        depth_bias_enable                       =  1000377002, // VK_DYNAMIC_STATE_DEPTH_BIAS_ENABLE                       :c_int=  1000377002;
        logic_op                                =  1000377003, // VK_DYNAMIC_STATE_LOGIC_OP_EXT                            :c_int=  1000377003;
        primitive_restart_enable                =  1000377004, // VK_DYNAMIC_STATE_PRIMITIVE_RESTART_ENABLE                :c_int=  1000377004;

        color_write_enable                      =  1000381000, // VK_DYNAMIC_STATE_COLOR_WRITE_ENABLE_EXT                  :c_int=  1000381000;

        tessellation_domainOrigin               =  1000455002, // VK_DYNAMIC_STATE_TESSELLATION_DOMAIN_ORIGIN_EXT          :c_int=  1000455002;
        depth_clamp_enable                      =  1000455003, // VK_DYNAMIC_STATE_DEPTH_CLAMP_ENABLE_EXT                  :c_int=  1000455003;
        mode_polygon                            =  1000455004, // VK_DYNAMIC_STATE_POLYGON_MODE_EXT                        :c_int=  1000455004;
        rasterization_samples                   =  1000455005, // VK_DYNAMIC_STATE_RASTERIZATION_SAMPLES_EXT               :c_int=  1000455005;
        sample_mask                             =  1000455006, // VK_DYNAMIC_STATE_SAMPLE_MASK_EXT                         :c_int=  1000455006;
        alpha_toCoverage_enable                 =  1000455007, // VK_DYNAMIC_STATE_ALPHA_TO_COVERAGE_ENABLE_EXT            :c_int=  1000455007;
        alpha_toOne_enable                      =  1000455008, // VK_DYNAMIC_STATE_ALPHA_TO_ONE_ENABLE_EXT                 :c_int=  1000455008;
        logic_op_enable                         =  1000455009, // VK_DYNAMIC_STATE_LOGIC_OP_ENABLE_EXT                     :c_int=  1000455009;
        color_blend_enable                      =  1000455010, // VK_DYNAMIC_STATE_COLOR_BLEND_ENABLE_EXT                  :c_int=  1000455010;
        color_blend_equation                    =  1000455011, // VK_DYNAMIC_STATE_COLOR_BLEND_EQUATION_EXT                :c_int=  1000455011;
        color_write_mask                        =  1000455012, // VK_DYNAMIC_STATE_COLOR_WRITE_MASK_EXT                    :c_int=  1000455012;
        rasterization_stream                    =  1000455013, // VK_DYNAMIC_STATE_RASTERIZATION_STREAM_EXT                :c_int=  1000455013;
        mode_rasterization_conservative         =  1000455014, // VK_DYNAMIC_STATE_CONSERVATIVE_RASTERIZATION_MODE_EXT     :c_int=  1000455014;
        primitive_overestimation_extraSize      =  1000455015, // VK_DYNAMIC_STATE_EXTRA_PRIMITIVE_OVERESTIMATION_SIZE_EXT :c_int=  1000455015;
        depth_clip_enable                       =  1000455016, // VK_DYNAMIC_STATE_DEPTH_CLIP_ENABLE_EXT                   :c_int=  1000455016;
        sample_locations_enable                 =  1000455017, // VK_DYNAMIC_STATE_SAMPLE_LOCATIONS_ENABLE_EXT             :c_int=  1000455017;
        color_blend_advanced                    =  1000455018, // VK_DYNAMIC_STATE_COLOR_BLEND_ADVANCED_EXT                :c_int=  1000455018;
        mode_vertex_provoking                   =  1000455019, // VK_DYNAMIC_STATE_PROVOKING_VERTEX_MODE_EXT               :c_int=  1000455019;
        mode_rasterization_line                 =  1000455020, // VK_DYNAMIC_STATE_LINE_RASTERIZATION_MODE_EXT             :c_int=  1000455020;
        lineStipple_enable                      =  1000455021, // VK_DYNAMIC_STATE_LINE_STIPPLE_ENABLE_EXT                 :c_int=  1000455021;
        depth_clip_negativeOneToOne             =  1000455022, // VK_DYNAMIC_STATE_DEPTH_CLIP_NEGATIVE_ONE_TO_ONE_EXT      :c_int=  1000455022;
        viewport_WScaling_enableNV              =  1000455023, // VK_DYNAMIC_STATE_VIEWPORT_W_SCALING_ENABLE_NV            :c_int=  1000455023;
        viewport_swizzleNV                      =  1000455024, // VK_DYNAMIC_STATE_VIEWPORT_SWIZZLE_NV                     :c_int=  1000455024;
        NV_coverage_toColor_enable              =  1000455025, // VK_DYNAMIC_STATE_COVERAGE_TO_COLOR_ENABLE_NV             :c_int=  1000455025;
        NV_coverage_toColor_location            =  1000455026, // VK_DYNAMIC_STATE_COVERAGE_TO_COLOR_LOCATION_NV           :c_int=  1000455026;
        NV_coverage_modulation_mode             =  1000455027, // VK_DYNAMIC_STATE_COVERAGE_MODULATION_MODE_NV             :c_int=  1000455027;
        NV_coverage_modulation_table_enable     =  1000455028, // VK_DYNAMIC_STATE_COVERAGE_MODULATION_TABLE_ENABLE_NV     :c_int=  1000455028;
        NV_coverage_modulation_table            =  1000455029, // VK_DYNAMIC_STATE_COVERAGE_MODULATION_TABLE_NV            :c_int=  1000455029;
        NV_shadingRateImage_enable              =  1000455030, // VK_DYNAMIC_STATE_SHADING_RATE_IMAGE_ENABLE_NV            :c_int=  1000455030;
        NV_representativeFragmentTest_enable    =  1000455031, // VK_DYNAMIC_STATE_REPRESENTATIVE_FRAGMENT_TEST_ENABLE_NV  :c_int=  1000455031;
        NV_coverage_reduction_mode              =  1000455032, // VK_DYNAMIC_STATE_COVERAGE_REDUCTION_MODE_NV              :c_int=  1000455032;

        attachment_feedbackLoop_enable          =  1000524000, // VK_DYNAMIC_STATE_ATTACHMENT_FEEDBACK_LOOP_ENABLE_EXT     :c_int=  1000524000;
      }; //:: vk.pipeline.state.dynamic.Kind
      pub const Flags    = packed struct {
        __reserved_bits_00_31 :u32=0,
        pub usingnamespace FlagsT(@This(), vk.Flags);
      }; //:: vk.pipeline.state.dynamic.Flags
    }; //:: vk.pipeline.state.dynamic
  }; //:: vk.pipeline.state

  pub const Flags     = packed struct {
    disableOptimization                            :bool= false, // 00 :: VK_PIPELINE_CREATE_DISABLE_OPTIMIZATION_BIT                                     :c_int=  1;
    allowDerivatives                               :bool= false, // 01 :: VK_PIPELINE_CREATE_ALLOW_DERIVATIVES_BIT                                        :c_int=  2;
    derivative                                     :bool= false, // 02 :: VK_PIPELINE_CREATE_DERIVATIVE_BIT                                               :c_int=  4;
    viewIndexFromDeviceIndex                       :bool= false, // 03 :: VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT                             :c_int=  8;
    dispatch_base                                  :bool= false, // 04 :: VK_PIPELINE_CREATE_DISPATCH_BASE_BIT                                            :c_int=  16;
    NV_deferCompile                                :bool= false, // 05 :: VK_PIPELINE_CREATE_DEFER_COMPILE_BIT_NV                                         :c_int=  32;
    capture_statistics                             :bool= false, // 06 :: VK_PIPELINE_CREATE_CAPTURE_STATISTICS_BIT_KHR                                   :c_int=  64;
    capture_internalRepresentations                :bool= false, // 07 :: VK_PIPELINE_CREATE_CAPTURE_INTERNAL_REPRESENTATIONS_BIT_KHR                     :c_int=  128;
    failOnPipelineCompile_required                 :bool= false, // 08 :: VK_PIPELINE_CREATE_FAIL_ON_PIPELINE_COMPILE_REQUIRED_BIT                        :c_int=  256;
    earlyReturnOnFailure                           :bool= false, // 09 :: VK_PIPELINE_CREATE_EARLY_RETURN_ON_FAILURE_BIT                                  :c_int=  512;
    LTO_enabled                                    :bool= false, // 10 :: VK_PIPELINE_CREATE_LINK_TIME_OPTIMIZATION_BIT_EXT                               :c_int=  1024;
    library                                        :bool= false, // 11 :: VK_PIPELINE_CREATE_LIBRARY_BIT_KHR                                              :c_int=  2048;
    raytracing_skip_triangles                      :bool= false, // 12 :: VK_PIPELINE_CREATE_RAY_TRACING_SKIP_TRIANGLES_BIT_KHR                           :c_int=  4096;
    raytracing_skip_AABBs                          :bool= false, // 13 :: VK_PIPELINE_CREATE_RAY_TRACING_SKIP_AABBS_BIT_KHR                               :c_int=  8192;
    raytracing_noNullShaders_anyHit                :bool= false, // 14 :: VK_PIPELINE_CREATE_RAY_TRACING_NO_NULL_ANY_HIT_SHADERS_BIT_KHR                  :c_int=  16384;
    raytracing_noNullShaders_closestHit            :bool= false, // 15 :: VK_PIPELINE_CREATE_RAY_TRACING_NO_NULL_CLOSEST_HIT_SHADERS_BIT_KHR              :c_int=  32768;
    raytracing_noNullShaders_miss                  :bool= false, // 16 :: VK_PIPELINE_CREATE_RAY_TRACING_NO_NULL_MISS_SHADERS_BIT_KHR                     :c_int=  65536;
    raytracing_noNullShaders_intersection          :bool= false, // 17 :: VK_PIPELINE_CREATE_RAY_TRACING_NO_NULL_INTERSECTION_SHADERS_BIT_KHR             :c_int=  131072;
    indirectBindableNV                             :bool= false, // 18 :: VK_PIPELINE_CREATE_INDIRECT_BINDABLE_BIT_NV                                     :c_int=  262144;
    raytracing_shaderGroup_handleCaptureReplay     :bool= false, // 19 :: VK_PIPELINE_CREATE_RAY_TRACING_SHADER_GROUP_HANDLE_CAPTURE_REPLAY_BIT_KHR       :c_int=  524288;
    raytracing_allowMotionNV                       :bool= false, // 20 :: VK_PIPELINE_CREATE_RAY_TRACING_ALLOW_MOTION_BIT_NV                              :c_int=  1048576;
    rendering_fragmentAttachment_shadingRate       :bool= false, // 21 :: VK_PIPELINE_CREATE_RENDERING_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR           :c_int=  2097152;
    rendering_fragmentAttachment_densityMap        :bool= false, // 22 :: VK_PIPELINE_CREATE_RENDERING_FRAGMENT_DENSITY_MAP_ATTACHMENT_BIT_EXT            :c_int=  4194304;
    LTO_retainInfo                                 :bool= false, // 23 :: VK_PIPELINE_CREATE_RETAIN_LINK_TIME_OPTIMIZATION_INFO_BIT_EXT                   :c_int=  8388608;
    raytracing_opacityMicromap                     :bool= false, // 24 :: VK_PIPELINE_CREATE_RAY_TRACING_OPACITY_MICROMAP_BIT_EXT                         :c_int=  16777216;
    attachment_color_feedback_loop                 :bool= false, // 25 :: VK_PIPELINE_CREATE_COLOR_ATTACHMENT_FEEDBACK_LOOP_BIT_EXT                       :c_int=  33554432;
    attachment_depthStencil_feedback_loop          :bool= false, // 26 :: VK_PIPELINE_CREATE_DEPTH_STENCIL_ATTACHMENT_FEEDBACK_LOOP_BIT_EXT               :c_int=  67108864;
    protectedAccess_none                           :bool= false, // 27 :: VK_PIPELINE_CREATE_NO_PROTECTED_ACCESS_BIT_EXT                                  :c_int=  134217728;
    __reserved_bit_28 :u1= 0,
    descriptorBuffer                               :bool= false, // 29 :: VK_PIPELINE_CREATE_DESCRIPTOR_BUFFER_BIT_EXT                                    :c_int=  536870912;
    protectedAccess_only                           :bool= false, // 30 :: VK_PIPELINE_CREATE_PROTECTED_ACCESS_ONLY_BIT_EXT                                :c_int=  1073741824;
    __reserved_bit_31 :u1= 0,
    pub usingnamespace FlagsT(@This(), vk.Flags);
    pub const rasterizationStateCreate_fragmentAttachment_shadingRate = pipeline.Flags{.rendering_fragmentAttachment_shadingRate =true}; // 00 :: VK_PIPELINE_RASTERIZATION_STATE_CREATE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR :c_int=  2097152;
    pub const rasterizationStateCreate_fragmentAttachment_densityMap  = pipeline.Flags{.rendering_fragmentAttachment_densityMap  =true}; // 00 :: VK_PIPELINE_RASTERIZATION_STATE_CREATE_FRAGMENT_DENSITY_MAP_ATTACHMENT_BIT_EXT  :c_int=  4194304;
  }; //:: vk.pipeline.Flags

  pub const shader   = struct {
    pub const stage   = struct {
      pub const Flags = packed struct {
        subgroups_allowVaryingSize  :bool= false,  // 00 :: VK_PIPELINE_SHADER_STAGE_CREATE_ALLOW_VARYING_SUBGROUP_SIZE_BIT :c_int=  1;
        subgroups_requireFull       :bool= false,  // 01 :: VK_PIPELINE_SHADER_STAGE_CREATE_REQUIRE_FULL_SUBGROUPS_BIT      :c_int=  2;
        __reserved_bits_02_31 :u30=0,
        pub usingnamespace FlagsT(@This(), vk.Flags);
      }; //:: vk.pipeline.Flags
    }; //:: vk.pipeline.shader.stage
  }; //:: vk.pipeline.shader

  /// @todo Pipeline Specialization Constants
  /// @reference https://registry.khronos.org/vulkan/specs/1.3-extensions/html/vkspec.html#pipelines-specialization-constants
  pub const specialization = struct {
    pub const Cfg   = c.VkSpecializationInfo;
    pub const Entry = c.VkSpecializationMapEntry;
  }; //:: vk.specialization
}; //:: vk.pipeline

