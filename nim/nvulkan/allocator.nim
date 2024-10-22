#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h".}


type Scope *{.importc:"VkSystemAllocationScope", vulkan, pure, size:sizeof(int32).}= enum
  command, Object, cache, device, instance
type InternalType *{.importc:"VkInternalAllocationType", vulkan, pure, size:sizeof(int32).}= enum
  executable

type Fn_vkAlloc *{.importc:"PFN_vkAllocationFunction", vulkan.}= proc (
    userData  : pointer;
    size      : csize_t;
    alignment : csize_t;
    scope     : Scope;
  ) :pointer {.cdecl.}

type Fn_vkRealloc *{.importc:"PFN_vkReallocationFunction", vulkan.}= proc (
    userData  : pointer;
    original  : pointer;
    size      : csize_t;
    alignment : csize_t;
    scope     : Scope;
  ) :pointer {.cdecl.}

type Fn_vkFree *{.importc:"PFN_vkFreeFunction", vulkan.}= proc (
    userData : pointer;
    memory   : pointer;
  ) :void {.cdecl.}

type Fn_vkAllocNotif *{.importc:"PFN_vkInternalAllocationNotification", vulkan.}= proc (
    userData : pointer;
    size     : csize_t;
    typ      : InternalType;
    scope    : Scope;
  ) :void {.cdecl.}

type Fn_vkFreeNotif *{.importc:"PFN_vkInternalFreeNotification", vulkan.}= proc (
    userData : pointer;
    size     : csize_t;
    typ      : InternalType;
    scope    : Scope;
  ) :void {.cdecl.}

type Allocator *{.importc:"VkAllocationCallbacks",  vulkan.}= object
  userData    *{.importc:"pUserData"            .}:pointer
  alloc       *{.importc:"pfnAllocation"        .}:Fn_vkAlloc
  realloc     *{.importc:"pfnReallocation"      .}:Fn_vkRealloc
  free        *{.importc:"pfnFree"              .}:Fn_vkFree
  allocNotif  *{.importc:"pfnInternalAllocation".}:Fn_vkAllocNotif
  freeNotif   *{.importc:"pfnInternalFree"      .}:Fn_vkFreeNotif

