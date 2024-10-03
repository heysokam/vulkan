//:___________________________________________________________________
//  zsys  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
const c = @cImport({
  @cDefine("GLFW_INCLUDE_VULKAN", {});
  @cInclude("GLFW/glfw3.h");
  });
const glfw = @This();

pub const Window                 = c.GLFWwindow;
pub const KeyFunc                = c.GLFWkeyfun;
pub fn    init                   () bool {return c.glfwInit() == glfw.True; }
pub const term                   = c.glfwTerminate;
pub const window                 = struct {
  pub const hint                 = c.glfwWindowHint;
  pub const create               = c.glfwCreateWindow;
  pub const destroy              = c.glfwDestroyWindow;
  pub fn    close                (W :?*glfw.Window) bool {return c.glfwWindowShouldClose(W) == glfw.True; }
  pub const setClose             = c.glfwSetWindowShouldClose;
  pub const size                 = c.glfwGetWindowSize;
}; //:: window
pub const framebuffer            = struct {
  pub const size                 = c.glfwGetFramebufferSize;
}; //:: framebuffer
pub const cb                     = struct {
  pub const setResize            = c.glfwSetFramebufferSizeCallback;
  pub const setKey               = c.glfwSetKeyCallback;
  pub const setMousePos          = c.glfwSetCursorPosCallback;
  pub const setMouseBtn          = c.glfwSetMouseButtonCallback;
  pub const setMouseScroll       = c.glfwSetScrollCallback;
}; //:: cb

pub const sync                   = c.glfwPollEvents;
pub const getTime                = c.glfwGetTime;
pub const version                = struct {
  pub const M                    = c.GLFW_VERSION_MAJOR;
  pub const m                    = c.GLFW_VERSION_MINOR;
  pub const p                    = c.GLFW_VERSION_REVISION;
};

// Booleans
pub const True                   = c.GLFW_TRUE;
pub const False                  = c.GLFW_FALSE;

// Errors
pub const Ok                     = c.GLFW_NO_ERROR;
pub const NotInitialized         = c.GLFW_NOT_INITIALIZED;
pub const NoCurrentContext       = c.GLFW_NO_CURRENT_CONTEXT;
pub const InvalidEnum            = c.GLFW_INVALID_ENUM;
pub const InvalidValue           = c.GLFW_INVALID_VALUE;
pub const OutOfMemory            = c.GLFW_OUT_OF_MEMORY;
pub const ApiUnavailable         = c.GLFW_API_UNAVAILABLE;
pub const VersionUnavailable     = c.GLFW_VERSION_UNAVAILABLE;
pub const PlatformError          = c.GLFW_PLATFORM_ERROR;
pub const FormatUnavailable      = c.GLFW_FORMAT_UNAVAILABLE;
pub const NoWindowContext        = c.GLFW_NO_WINDOW_CONTEXT;

pub const Focused                = c.GLFW_FOCUSED;
pub const Iconified              = c.GLFW_ICONIFIED;
pub const Resizable              = c.GLFW_RESIZABLE;

pub const Visible                = c.GLFW_VISIBLE;
pub const Decorated              = c.GLFW_DECORATED;
pub const IconifyAuto            = c.GLFW_AUTO_ICONIFY;
pub const Floating               = c.GLFW_FLOATING;
pub const Maximized              = c.GLFW_MAXIMIZED;
pub const CursorCenter           = c.GLFW_CENTER_CURSOR;
pub const FramebufferTransparent = c.GLFW_TRANSPARENT_FRAMEBUFFER;
pub const Hovered                = c.GLFW_HOVERED;
pub const FocustOnShow           = c.GLFW_FOCUS_ON_SHOW;
pub const bits = struct {
  pub const Red                  = c.GLFW_RED_BITS;
  pub const Green                = c.GLFW_GREEN_BITS;
  pub const Blue                 = c.GLFW_BLUE_BITS;
  pub const Alpha                = c.GLFW_ALPHA_BITS;
  pub const Depth                = c.GLFW_DEPTH_BITS;
  pub const Stencil              = c.GLFW_STENCIL_BITS;
  pub const accum = struct {
    pub const Red                = c.GLFW_ACCUM_RED_BITS;
    pub const Green              = c.GLFW_ACCUM_GREEN_BITS;
    pub const Blue               = c.GLFW_ACCUM_BLUE_BITS;
    pub const Alpha              = c.GLFW_ACCUM_ALPHA_BITS;
  }; //:: accum
}; //:: bits
pub const BuffersAux             = c.GLFW_AUX_BUFFERS;
pub const Stereo                 = c.GLFW_STEREO;
pub const Samples                = c.GLFW_SAMPLES;
pub const SRGBCapable            = c.GLFW_SRGB_CAPABLE;
pub const RefreshRate            = c.GLFW_REFRESH_RATE;
pub const DoubleBuffer           = c.GLFW_DOUBLEBUFFER;

pub const Cursor                 = c.GLFW_CURSOR;
pub const sticky                 = struct {
  pub const Keys                 = c.GLFW_STICKY_KEYS;
  pub const MouseBtn             = c.GLFW_STICKY_MOUSE_BUTTONS;
}; //:: sticky
pub const LockKeyMods            = c.GLFW_LOCK_KEY_MODS;
pub const RawMouseMotion         = c.GLFW_RAW_MOUSE_MOTION;
pub const cursor                 = struct {
  pub const Normal               = c.GLFW_CURSOR_NORMAL;
  pub const Hidden               = c.GLFW_CURSOR_HIDDEN;
  pub const Disabled             = c.GLFW_CURSOR_DISABLED;
  pub const Arror                = c.GLFW_ARROW_CURSOR;
  pub const IBeam                = c.GLFW_IBEAM_CURSOR;
  pub const Crosshair            = c.GLFW_CROSSHAIR_CURSOR;
  pub const Hand                 = c.GLFW_HAND_CURSOR;
  pub const resize               = struct {
    pub const H                  = c.GLFW_HRESIZE_CURSOR;
    pub const V                  = c.GLFW_VRESIZE_CURSOR;
  }; //:: cursor.resize
}; //:: cursor
pub const Connected              = c.GLFW_CONNECTED;
pub const Disconnected           = c.GLFW_DISCONNECTED;
pub const DontCare               = c.GLFW_DONT_CARE;

// Input Actions
pub const Release                = c.GLFW_RELEASE;
pub const Press                  = c.GLFW_PRESS;
pub const Repeat                 = c.GLFW_REPEAT;

// Input Mappings
pub const hat                    = struct {
  pub const Centered             = c.GLFW_HAT_CENTERED;
  pub const Up                   = c.GLFW_HAT_UP;
  pub const Right                = c.GLFW_HAT_RIGHT;
  pub const Down                 = c.GLFW_HAT_DOWN;
  pub const Left                 = c.GLFW_HAT_LEFT;
  pub const RightUp              = c.GLFW_HAT_RIGHT_UP;
  pub const RightDown            = c.GLFW_HAT_RIGHT_DOWN;
  pub const LeftUp               = c.GLFW_HAT_LEFT_UP;
  pub const LeftDown             = c.GLFW_HAT_LEFT_DOWN;
}; //:: hat
pub const key                    = struct {
  pub const Unkn                 = c.GLFW_KEY_UNKNOWN;
  pub const Space                = c.GLFW_KEY_SPACE;
  pub const Apostrophe           = c.GLFW_KEY_APOSTROPHE;
  pub const Comma                = c.GLFW_KEY_COMMA;
  pub const Minus                = c.GLFW_KEY_MINUS;
  pub const Period               = c.GLFW_KEY_PERIOD;
  pub const Slash                = c.GLFW_KEY_SLASH;
  pub const k0                   = c.GLFW_KEY_0;
  pub const k1                   = c.GLFW_KEY_1;
  pub const k2                   = c.GLFW_KEY_2;
  pub const k3                   = c.GLFW_KEY_3;
  pub const k4                   = c.GLFW_KEY_4;
  pub const k5                   = c.GLFW_KEY_5;
  pub const k6                   = c.GLFW_KEY_6;
  pub const k7                   = c.GLFW_KEY_7;
  pub const k8                   = c.GLFW_KEY_8;
  pub const k9                   = c.GLFW_KEY_9;
  pub const SemiColon            = c.GLFW_KEY_SEMICOLON;
  pub const Equal                = c.GLFW_KEY_EQUAL;
  pub const A                    = c.GLFW_KEY_A;
  pub const B                    = c.GLFW_KEY_B;
  pub const C                    = c.GLFW_KEY_C;
  pub const D                    = c.GLFW_KEY_D;
  pub const E                    = c.GLFW_KEY_E;
  pub const F                    = c.GLFW_KEY_F;
  pub const G                    = c.GLFW_KEY_G;
  pub const H                    = c.GLFW_KEY_H;
  pub const I                    = c.GLFW_KEY_I;
  pub const J                    = c.GLFW_KEY_J;
  pub const K                    = c.GLFW_KEY_K;
  pub const L                    = c.GLFW_KEY_L;
  pub const M                    = c.GLFW_KEY_M;
  pub const N                    = c.GLFW_KEY_N;
  pub const O                    = c.GLFW_KEY_O;
  pub const P                    = c.GLFW_KEY_P;
  pub const Q                    = c.GLFW_KEY_Q;
  pub const R                    = c.GLFW_KEY_R;
  pub const S                    = c.GLFW_KEY_S;
  pub const T                    = c.GLFW_KEY_T;
  pub const U                    = c.GLFW_KEY_U;
  pub const V                    = c.GLFW_KEY_V;
  pub const W                    = c.GLFW_KEY_W;
  pub const X                    = c.GLFW_KEY_X;
  pub const Y                    = c.GLFW_KEY_Y;
  pub const Z                    = c.GLFW_KEY_Z;
  pub const LeftBracket          = c.GLFW_KEY_LEFT_BRACKET;
  pub const Backslash            = c.GLFW_KEY_BACKSLASH;
  pub const RightBracked         = c.GLFW_KEY_RIGHT_BRACKET;
  pub const Grave                = c.GLFW_KEY_GRAVE_ACCENT;
  pub const World1               = c.GLFW_KEY_WORLD_1;
  pub const World2               = c.GLFW_KEY_WORLD_2;

  pub const Escape               = c.GLFW_KEY_ESCAPE;

  pub const Enter                = c.GLFW_KEY_ENTER;
  pub const Tab                  = c.GLFW_KEY_TAB;
  pub const Backspace            = c.GLFW_KEY_BACKSPACE;
  pub const Insert               = c.GLFW_KEY_INSERT;
  pub const Delete               = c.GLFW_KEY_DELETE;
  pub const Right                = c.GLFW_KEY_RIGHT;
  pub const Left                 = c.GLFW_KEY_LEFT;
  pub const Down                 = c.GLFW_KEY_DOWN;
  pub const Up                   = c.GLFW_KEY_UP;
  pub const PageUp               = c.GLFW_KEY_PAGE_UP;
  pub const PageDown             = c.GLFW_KEY_PAGE_DOWN;
  pub const Home                 = c.GLFW_KEY_HOME;
  pub const End                  = c.GLFW_KEY_END;
  pub const CapsLock             = c.GLFW_KEY_CAPS_LOCK;
  pub const ScrollLock           = c.GLFW_KEY_SCROLL_LOCK;
  pub const NumLock              = c.GLFW_KEY_NUM_LOCK;
  pub const PrintScreen          = c.GLFW_KEY_PRINT_SCREEN;
  pub const Pause                = c.GLFW_KEY_PAUSE;
  pub const F1                   = c.GLFW_KEY_F1;
  pub const F2                   = c.GLFW_KEY_F2;
  pub const F3                   = c.GLFW_KEY_F3;
  pub const F4                   = c.GLFW_KEY_F4;
  pub const F5                   = c.GLFW_KEY_F5;
  pub const F6                   = c.GLFW_KEY_F6;
  pub const F7                   = c.GLFW_KEY_F7;
  pub const F8                   = c.GLFW_KEY_F8;
  pub const F9                   = c.GLFW_KEY_F9;
  pub const F10                  = c.GLFW_KEY_F10;
  pub const F11                  = c.GLFW_KEY_F11;
  pub const F12                  = c.GLFW_KEY_F12;
  pub const F13                  = c.GLFW_KEY_F13;
  pub const F14                  = c.GLFW_KEY_F14;
  pub const F15                  = c.GLFW_KEY_F15;
  pub const F16                  = c.GLFW_KEY_F16;
  pub const F17                  = c.GLFW_KEY_F17;
  pub const F18                  = c.GLFW_KEY_F18;
  pub const F19                  = c.GLFW_KEY_F19;
  pub const F20                  = c.GLFW_KEY_F20;
  pub const F21                  = c.GLFW_KEY_F21;
  pub const F22                  = c.GLFW_KEY_F22;
  pub const F23                  = c.GLFW_KEY_F23;
  pub const F24                  = c.GLFW_KEY_F24;
  pub const F25                  = c.GLFW_KEY_F25;
  pub const KP0                  = c.GLFW_KEY_KP_0;
  pub const KP1                  = c.GLFW_KEY_KP_1;
  pub const KP2                  = c.GLFW_KEY_KP_2;
  pub const KP3                  = c.GLFW_KEY_KP_3;
  pub const KP4                  = c.GLFW_KEY_KP_4;
  pub const KP5                  = c.GLFW_KEY_KP_5;
  pub const KP6                  = c.GLFW_KEY_KP_6;
  pub const KP7                  = c.GLFW_KEY_KP_7;
  pub const KP8                  = c.GLFW_KEY_KP_8;
  pub const KP9                  = c.GLFW_KEY_KP_9;
  pub const KPDecimal            = c.GLFW_KEY_KP_DECIMAL;
  pub const KPDivide             = c.GLFW_KEY_KP_DIVIDE;
  pub const KPMultiply           = c.GLFW_KEY_KP_MULTIPLY;
  pub const KPSubtract           = c.GLFW_KEY_KP_SUBTRACT;
  pub const KPAdd                = c.GLFW_KEY_KP_ADD;
  pub const KPEnter              = c.GLFW_KEY_KP_ENTER;
  pub const KPEqual              = c.GLFW_KEY_KP_EQUAL;
  pub const LeftShift            = c.GLFW_KEY_LEFT_SHIFT;
  pub const LeftControl          = c.GLFW_KEY_LEFT_CONTROL;
  pub const LeftAlt              = c.GLFW_KEY_LEFT_ALT;
  pub const LeftSuper            = c.GLFW_KEY_LEFT_SUPER;
  pub const RightShift           = c.GLFW_KEY_RIGHT_SHIFT;
  pub const RightControl         = c.GLFW_KEY_RIGHT_CONTROL;
  pub const RightAlt             = c.GLFW_KEY_RIGHT_ALT;
  pub const RightSuper           = c.GLFW_KEY_RIGHT_SUPER;
  pub const Menu                 = c.GLFW_KEY_MENU;
  pub const Last                 = c.GLFW_KEY_LAST;
}; //:: key
pub const mod                    = struct {
  pub const Shift                = c.GLFW_MOD_SHIFT;
  pub const Control              = c.GLFW_MOD_CONTROL;
  pub const Alt                  = c.GLFW_MOD_ALT;
  pub const Super                = c.GLFW_MOD_SUPER;
  pub const CapsLock             = c.GLFW_MOD_CAPS_LOCK;
  pub const NumLock              = c.GLFW_MOD_NUM_LOCK;
}; //:: mod
pub const btn                    = struct {
  pub const b1                   = c.GLFW_MOUSE_BUTTON_1;
  pub const b2                   = c.GLFW_MOUSE_BUTTON_2;
  pub const b3                   = c.GLFW_MOUSE_BUTTON_3;
  pub const b4                   = c.GLFW_MOUSE_BUTTON_4;
  pub const b5                   = c.GLFW_MOUSE_BUTTON_5;
  pub const b6                   = c.GLFW_MOUSE_BUTTON_6;
  pub const b7                   = c.GLFW_MOUSE_BUTTON_7;
  pub const b8                   = c.GLFW_MOUSE_BUTTON_8;
  pub const Last                 = c.GLFW_MOUSE_BUTTON_LAST;
  pub const Left                 = c.GLFW_MOUSE_BUTTON_LEFT;
  pub const Right                = c.GLFW_MOUSE_BUTTON_RIGHT;
  pub const Middle               = c.GLFW_MOUSE_BUTTON_MIDDLE;
}; //:: btn
pub const joy                    = struct {
  pub const hatBtns              = c.GLFW_JOYSTICK_HAT_BUTTONS;
  pub const j1                   = c.GLFW_JOYSTICK_1;
  pub const j2                   = c.GLFW_JOYSTICK_2;
  pub const j3                   = c.GLFW_JOYSTICK_3;
  pub const j4                   = c.GLFW_JOYSTICK_4;
  pub const j5                   = c.GLFW_JOYSTICK_5;
  pub const j6                   = c.GLFW_JOYSTICK_6;
  pub const j7                   = c.GLFW_JOYSTICK_7;
  pub const j8                   = c.GLFW_JOYSTICK_8;
  pub const j9                   = c.GLFW_JOYSTICK_9;
  pub const j10                  = c.GLFW_JOYSTICK_10;
  pub const j11                  = c.GLFW_JOYSTICK_11;
  pub const j12                  = c.GLFW_JOYSTICK_12;
  pub const j13                  = c.GLFW_JOYSTICK_13;
  pub const j14                  = c.GLFW_JOYSTICK_14;
  pub const j15                  = c.GLFW_JOYSTICK_15;
  pub const j16                  = c.GLFW_JOYSTICK_16;
  pub const Last                 = c.GLFW_JOYSTICK_LAST;
}; //:: joy
pub const pad                    = struct {
  pub const btn                  = struct {
    pub const A                  = c.GLFW_GAMEPAD_BUTTON_A;
    pub const B                  = c.GLFW_GAMEPAD_BUTTON_B;
    pub const X                  = c.GLFW_GAMEPAD_BUTTON_X;
    pub const Y                  = c.GLFW_GAMEPAD_BUTTON_Y;
    pub const bump               = struct {
      pub const Left             = c.GLFW_GAMEPAD_BUTTON_LEFT_BUMPER;
      pub const Right            = c.GLFW_GAMEPAD_BUTTON_RIGHT_BUMPER;
    }; //:: bump
    pub const Back               = c.GLFW_GAMEPAD_BUTTON_BACK;
    pub const Start              = c.GLFW_GAMEPAD_BUTTON_START;
    pub const Guide              = c.GLFW_GAMEPAD_BUTTON_GUIDE;
    pub const thumb              = struct {
      pub const LeftThumb        = c.GLFW_GAMEPAD_BUTTON_LEFT_THUMB;
      pub const RightThumb       = c.GLFW_GAMEPAD_BUTTON_RIGHT_THUMB;
    }; //:: thumb
    pub const dpad               = struct {
      pub const Up               = c.GLFW_GAMEPAD_BUTTON_DPAD_UP;
      pub const Right            = c.GLFW_GAMEPAD_BUTTON_DPAD_RIGHT;
      pub const Down             = c.GLFW_GAMEPAD_BUTTON_DPAD_DOWN;
      pub const Left             = c.GLFW_GAMEPAD_BUTTON_DPAD_LEFT;
    }; //:: dpad
    pub const Last               = c.GLFW_GAMEPAD_BUTTON_LAST;
    pub const Cross              = c.GLFW_GAMEPAD_BUTTON_CROSS;
    pub const Circle             = c.GLFW_GAMEPAD_BUTTON_CIRCLE;
    pub const Square             = c.GLFW_GAMEPAD_BUTTON_SQUARE;
    pub const Triangle           = c.GLFW_GAMEPAD_BUTTON_TRIANGLE;
  }; //:: btn
  pub const axis                 = struct {
    pub const X                  = struct {
      pub const Left             = c.GLFW_GAMEPAD_AXIS_LEFT_X;
      pub const Right            = c.GLFW_GAMEPAD_AXIS_RIGHT_X;
    }; //:: X
    pub const Y                  = struct {
      pub const Left             = c.GLFW_GAMEPAD_AXIS_LEFT_Y;
      pub const Right            = c.GLFW_GAMEPAD_AXIS_RIGHT_Y;
    }; //:: Y
    pub const trigger            = struct {
      pub const Left             = c.GLFW_GAMEPAD_AXIS_LEFT_TRIGGER;
      pub const Right            = c.GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER;
    }; //:: trigger
    pub const Last               = c.GLFW_GAMEPAD_AXIS_LAST;
  }; //:: axis
}; //:: pad

pub const Api                    = c.GLFWAPI;
pub const ClientApi              = c.GLFW_CLIENT_API;
pub const NoApi                  = c.GLFW_NO_API;
pub const context                = struct {
  pub const version              = struct {
    pub const M                  = c.GLFW_CONTEXT_VERSION_MAJOR;
    pub const m                  = c.GLFW_CONTEXT_VERSION_MINOR;
    pub const p                  = c.GLFW_CONTEXT_REVISION;
  }; //:: context.version
  pub const Robustness           = c.GLFW_CONTEXT_ROBUSTNESS;
}; //:: context

pub const opengl                 = struct {
  pub const Api                  = c.GLFW_OPENGL_API;
  pub const ESApi                = c.GLFW_OPENGL_ES_API;
  pub const Any                  = c.GLFW_OPENGL_ANY_PROFILE;
  pub const Core                 = c.GLFW_OPENGL_CORE_PROFILE;
  pub const Compat               = c.GLFW_OPENGL_COMPAT_PROFILE;
  pub const ForwardCompat        = c.GLFW_OPENGL_FORWARD_COMPAT;
  pub const DebugContext         = c.GLFW_OPENGL_DEBUG_CONTEXT;
  pub const Profile              = c.GLFW_OPENGL_PROFILE;
};

pub const vk                     = struct {
  const vulkan                   = @import("./vulkan/vk.zig");
  pub fn supported               () bool { return c.glfwVulkanSupported() == glfw.True; }
  pub const getProc              = c.glfwGetProcAddress;
  pub const instance             = struct {
    pub const getExts            = c.glfwGetRequiredInstanceExtensions;
    pub const getProc            :vk.instance.GetProcFunc= @ptrCast(&c.glfwGetInstanceProcAddress);  // pub const getProc = c.glfwGetInstanceProcAddress;
    const GetProcFunc            = *const fn (
                                     instance : vulkan.Instance,
                                     procname : [*:0]const u8
                                   ) vulkan.PfnVoidFunction;
  }; //:: vk.instance
  pub const surface              = struct {
    pub const create             :vk.surface.CreateFunc= @ptrCast(&c.glfwCreateWindowSurface);  // pub const create = c.glfwCreateWindowSurface;
    const CreateFunc             = *const fn (
                                     instance  : vulkan.Instance,
                                     window    : ?*glfw.Window,
                                     allocator : ?*const vulkan.AllocationCallbacks,
                                     surface   : *const vulkan.SurfaceKHR
                                   ) vulkan.Result;
  }; //:: vk.surface
}; //:: vk

