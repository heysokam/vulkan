//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Framebuffer & Renderpass/Subpass Tools
//_______________________________________________________|
// @deps vulkan
const c      = @import("../lib/vulkan.zig");
const vk     = @import("./types.zig");
const flags  = @import("./flags.zig").flags;
const FlagsT = flags.T;


pub const Framebuffer = framebuffer.T;
pub const framebuffer = struct {
  pub const T      = c.VkFramebuffer;
  pub const Cfg    = c.VkFramebufferCreateInfo;
  pub const Flags  = packed struct {
    imageless  :bool = false, // 00 :: VK_FRAMEBUFFER_CREATE_IMAGELESS_BIT :c_int=  1;
    __reserved_bits_01_31 :u31=0,
    pub usingnamespace FlagsT(@This(), vk.Flags);
  }; //:: vk.pipeline.graphics.viewport.Flags
}; //:: vk.framebuffer


pub const RenderPass = render.pass.T;
pub const render     = struct {
  pub const Pass     = render.pass.T;
  pub const pass     = struct {
    pub const T      = c.VkRenderPass;
    pub const Cfg    = c.VkRenderPassCreateInfo;
    pub const Flags  = packed struct {
      __reserved_bit_00 :u1=0,
      QCOM_transform  :bool = false,  // 01 :: VK_RENDER_PASS_CREATE_TRANSFORM_BIT_QCOM :c_int=  2;
      __reserved_bits_02_31 :u30=0,
      pub usingnamespace FlagsT(@This(), vk.Flags);
    }; //:: vk.render.pass.Flags
    pub const create   = c.vkCreateRenderPass;
    pub const destroy  = c.vkDestroyRenderPass;
    pub const attachment= struct {
      pub const Samples = flags.Samples;
      pub const LoadOp  = enum(c_int) {
        load     =          0,  // VK_ATTACHMENT_LOAD_OP_LOAD      :c_int=           0;
        clear    =          1,  // VK_ATTACHMENT_LOAD_OP_CLEAR     :c_int=           1;
        dontCare =          2,  // VK_ATTACHMENT_LOAD_OP_DONT_CARE :c_int=           2;
        none     = 1000400000,  // VK_ATTACHMENT_LOAD_OP_NONE_KHR  :c_int=  1000400000;
      }; //:: vk.renderpass.attachment.LoadOp
      pub const StoreOp = enum(c_int) {
        store    =          0,  // VK_ATTACHMENT_STORE_OP_STORE     :c_int=  0;
        dontCare =          1,  // VK_ATTACHMENT_STORE_OP_DONT_CARE :c_int=  1;
        none     = 1000301000,  // VK_ATTACHMENT_STORE_OP_NONE      :c_int=  1000301000;
      }; //:: vk.render.pass.attachment.StoreOp
    }; //:: vk.render.pass.attachment

    pub const Description = render.pass.description.T;
    pub const description = struct {
      pub const T = c.VkAttachmentDescription;
      pub const Flags  = packed struct {
        mayAlias  :bool = false,  // 00 :: VK_ATTACHMENT_DESCRIPTION_MAY_ALIAS_BIT :c_int=  1;
        __reserved_bits_01_31 :u31=0,
        pub usingnamespace FlagsT(@This(), vk.Flags);
      }; //:: vk.render.pass.attachment.Flags
    }; //:: vk.render.pass.attachment.description
  }; //:: vk.render.pass

  pub const subpass  = struct {
    pub const Description = render.subpass.description.T;
    pub const description = struct {
      pub const T         = c.VkSubpassDescription;
      pub const Flags     = packed struct {
        NVX_perView_attributes      :bool = false,  // 00 :: VK_SUBPASS_DESCRIPTION_PER_VIEW_ATTRIBUTES_BIT_NVX                           :c_int=    1;
        NVX_perView_positionX_only  :bool = false,  // 01 :: VK_SUBPASS_DESCRIPTION_PER_VIEW_POSITION_X_ONLY_BIT_NVX                      :c_int=    2;
        QCOM_fragmentRegion         :bool = false,  // 02 :: VK_SUBPASS_DESCRIPTION_FRAGMENT_REGION_BIT_QCOM                              :c_int=    4;
        QCOM_shaderResolve          :bool = false,  // 03 :: VK_SUBPASS_DESCRIPTION_SHADER_RESOLVE_BIT_QCOM                               :c_int=    8;
        attachment_colorAccess      :bool = false,  // 04 :: VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_COLOR_ACCESS_BIT_EXT   :c_int=   16;
        attachment_depthAccess      :bool = false,  // 05 :: VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_DEPTH_ACCESS_BIT_EXT   :c_int=   32;
        attachment_stencilAccess    :bool = false,  // 06 :: VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_STENCIL_ACCESS_BIT_EXT :c_int=   64;
        legacyDithering             :bool = false,  // 07 :: VK_SUBPASS_DESCRIPTION_ENABLE_LEGACY_DITHERING_BIT_EXT                       :c_int=  128;
        __reserved_bits_08_31 :u24=0,
        pub usingnamespace FlagsT(@This(), vk.Flags);
      }; //:: vk.render.subpass.description.Flags
    }; //:: vk.render.subpass.description
    pub const Reference   = c.VkAttachmentReference;
  }; //:: vk.render.subpass
}; //:: vk.render

