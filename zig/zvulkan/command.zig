//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Command Tools
//______________________________|
// @deps vulkan
const c  = @import("../lib/vulkan.zig");
const vk = @This();

pub const command       = struct {

pub const Pool          = vk.command.pool.T;
pub const pool          = struct {
  pub const T           = c.VkCommandPool;
  pub const Cfg         = c.VkCommandPoolCreateInfo;
  pub const create      = c.vkCreateCommandPool;
  pub const destroy     = c.vkDestroyCommandPool;
}; //:: vk.command.pool

pub const Buffer        = vk.command.buffer.T;
pub const buffer        = struct {
  pub const T           = c.VkCommandBuffer;
  pub const Cfg         = c.VkCommandBufferAllocateInfo;
  pub const create      = c.vkAllocateCommandBuffers;
  pub const destroy     = c.vkFreeCommandBuffers;
  pub const level       = struct {
    pub const Primary   = c.VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    pub const Secondary = c.VK_COMMAND_BUFFER_LEVEL_SECONDARY;
  }; //:: vk.command.buffer.level
}; //:: vk.command.buffer

}; //:: vk.command


pub const clear = struct {
  pub const Attachment       = c.VkClearAttachment;
  pub const Color            = c.VkClearColorValue;
  pub const DepthStencil     = c.VkClearDepthStencilValue;
  pub const Rect             = c.VkClearRect;
  pub const Value            = c.VkClearValue;
}; //:: zvk.clear


pub const action             = struct {
  pub const buffer           = struct {
    pub const fill           = c.vkCmdFillBuffer;
    pub const update         = c.vkCmdUpdateBuffer;
    pub const copy           = c.vkCmdCopyBuffer2;         // pub const copy1        = c.vkCmdCopyBuffer;
    pub const copyToImage    = c.vkCmdCopyBufferToImage2;  // pub const copyToImage1 = c.vkCmdCopyBufferToImage;
  }; //:: vk.action.buffer

  pub const image            = struct {
    pub const blit           = c.vkCmdBlitImage2;          // pub const blit1         = c.vkCmdBlitImage;
    pub const copy           = c.vkCmdCopyImage2;          // pub const copy1         = c.vkCmdCopyImage;
    pub const copyToBuffer   = c.vkCmdCopyImageToBuffer2;  // pub const copyToBuffer1 = c.vkCmdCopyImageToBuffer;
    pub const copyToMemory   = c.vkCopyImageToMemoryEXT;   // VK_EXT_host_image_copy
    pub const clear          = struct {
      pub const color        = c.vkCmdClearColorImage;
      pub const depthStencil = c.vkCmdClearDepthStencilImage;
    }; //:: vk.action.image.clear
    pub const resolve        = c.vkCmdResolveImage2;       // pub const resolve1 = c.vkCmdResolveImage;
  }; //:: vk.action.image

  pub const attachments      = struct {
    pub const clear          = c.vkCmdClearAttachments;
  }; //:: vk.action.attachments

  pub const memory           = struct {
    pub const copyToImage    = c.vkCopyMemoryToImageEXT;   // VK_EXT_host_image_copy
  }; //:: vk.action.memory

  /// @note nid = Non-Indexed (aka standard)
  pub const draw              = struct {
    pub const nid             = c.vkCmdDraw;
    pub const indexed         = c.vkCmdDrawIndexed;
    pub const indirect        = struct {
      pub const nid           = c.vkCmdDrawIndirect;
      pub const count         = c.vkCmdDrawIndirectCount;
      pub const indexed       = c.vkCmdDrawIndexedIndirect;
      pub const indexedCount  = c.vkCmdDrawIndexedIndirectCount;
    }; //:: vk.action.draw.indirect
    pub const multi           = struct {
      pub const nid           = c.vkCmdDrawMultiEXT;         // VK_EXT_multi_draw
      pub const indexed       = c.vkCmdDrawMultiIndexedEXT;  // VK_EXT_multi_draw
    }; //:: vk.action.draw.multi
    pub const mesh            = struct {
      pub const nid           = c.vkCmdDrawMeshTasksEXT;               // VK_EXT_mesh_shader
      pub const indirect      = c.vkCmdDrawMeshTasksIndirectEXT;       // VK_EXT_mesh_shader
      pub const indirectCount = c.vkCmdDrawMeshTasksIndirectCountEXT;  // VK_EXT_mesh_shader
    };
  }; //:: vk.action.draw
}; //:: vk.action


pub const state                = struct {
  pub const set                = struct {
    pub const primitive        = struct {
      pub const restart        = c.vkCmdSetPrimitiveRestartEnable;
      pub const topology       = c.vkCmdSetPrimitiveTopologyEXT; // VK_EXT_shader_object | VK_EXT_extended_dynamic_state
    }; //:: vk.state.set.primitive
  }; //:: vk.state.set

  pub const bind               = struct {
    pub const indexBuffer      = c.vkCmdBindIndexBuffer;
  }; //:: vk.state.bind
}; //:: vk.state

