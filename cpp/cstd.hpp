//:___________________________________________________________________
//  cdk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
//! @fileoverview stdlib dependencies and Non-standard extensions  |
//_________________________________________________________________|
#pragma once

//______________________________________
// @section Aliases
//____________________________
#include <cstdint>
#include <cstddef>
using byte = uint8_t;
using u8   = uint8_t;
using u16  = uint16_t;
using u32  = uint32_t;
using u64  = uint64_t;
using uP   = uintptr_t;
using Sz   = std::size_t;
using i8   = int8_t;
using i16  = int16_t;
using i32  = int32_t;
using i64  = int64_t;
using iP   = intptr_t;
using f32  = float;
using f64  = double;
using TODO = uint8_t;
#include <iostream>
using str  = std::string;
using cstr = char const*;
using cstr_List = cstr*;

//______________________________________
// @section Arrays / Lists
//____________________________
#include <vector>
template<typename T> using vec = std::vector<T>;
template<typename T> using seq = vec<T>;


//______________________________________
// @section Math
//____________________________
#define GLM_FORCE_RADIANS
#define GLM_FORCE_DEPTH_ZERO_TO_ONE
#include <glm/vec2.hpp>  // glm::vec2
using UVec2 = glm::uvec2;
using IVec2 = glm::ivec2;
using DVec2 = glm::dvec2;
using Vec2  = glm::vec2;
#include <glm/vec3.hpp>  // glm::vec3
using UVec3 = glm::uvec3;
using IVec3 = glm::ivec3;
using DVec3 = glm::dvec3;
using Vec3  = glm::vec3;
#include <glm/vec4.hpp>  // glm::vec4
using UVec4 = glm::uvec4;
using IVec4 = glm::ivec4;
using DVec4 = glm::dvec4;
using Vec4  = glm::vec4;

// #include <glm/mat2x2.hpp>             // mat2, dmat2
// #include <glm/mat2x3.hpp>             // mat2x3, dmat2x3
// #include <glm/mat2x4.hpp>             // mat2x4, dmat2x4
// #include <glm/mat3x2.hpp>             // mat3x2, dmat3x2
// #include <glm/mat3x3.hpp>             // mat3, dmat3
// #include <glm/mat3x4.hpp>             // mat3x4, dmat2
// #include <glm/mat4x2.hpp>             // mat4x2, dmat4x2
// #include <glm/mat4x3.hpp>             // mat4x3, dmat4x3
#include <glm/mat4x4.hpp>  // mat4, dmat4
using Mat4  = glm::mat4;
using DMat4 = glm::dmat4;
#include <glm/matrix.hpp>        // all the GLSL matrix functions: transpose, inverse, etc.
#include <glm/gtc/type_ptr.hpp>  // For passing the matrix pointer to OpenGL
// #include <glm/trigonometric.hpp>      // all the GLSL trigonometric functions: radians, cos, asin, etc.
// #include <glm/vector_relational.hpp>  // all the GLSL vector relational functions: equal, less, etc.
// #include <glm/common.hpp>             // all the GLSL common functions: abs, min, mix, isnan, fma, etc.
// #include <glm/exponential.hpp>        // all the GLSL exponential functions: pow, log, exp2, sqrt, etc.
// #include <glm/geometric.hpp>          // all the GLSL geometry functions: dot, cross, reflect, etc.
// #include <glm/integer.hpp>            // all the GLSL integer functions: findMSB, bitfieldExtract, etc.
// #include <glm/packing.hpp>            // all the GLSL packing functions: packUnorm4x8, unpackHalf2x16, etc.

//______________________________________
// @section Functions
//____________________________
// std dependencies
#include <fstream>
#include <utility>

// clang-format off
//____________________________

/// @descr Discards the given input.
#define unused(it) (void)(it)
/// @descr Discards the given list of inputs.
template<class... Args> inline void discard(__attribute__((unused)) Args... args) {}
/// @descr Prints the given msg to console.
inline void echo(str msg) { std::cout << msg << std::endl; }
/// @descr Echoes the given list of messages to console.
template<class... Args> void prnt(Args... args);
/// @descr Prints the given list of messages to console, without a `\n` at the end.
template<class... Args> void echo(Args... args);
/// @descr Formats the given varargs into a string.
template<class... Args> str f(Args... args);
namespace cdk {
  /// @descr Reports the given error code and message.
  template <typename T> inline void err (T code, cstr msg) {
    fprintf(stderr, "Error: %i ->%s\n", static_cast<i32>(code), msg);
  }
  /// @descr Reports the given error code and message and calls `exit()` afterwards
  template <typename T> [[noreturn]] inline void fail(T E, cstr msg) {
    cdk::err(E, msg);
    exit(static_cast<i32>(E));
  }
}


//____________________________
// clang-format on

enum class Error { fail, warn };
#define fn __PRETTY_FUNCTION__  // Function name


//______________________________________
// @section Version
//____________________________
namespace cdk {
  namespace version {
    using T = u32;
  }; // namespace version
  using Version = cdk::version::T;

  namespace version {
    template <typename T> constexpr uint32_t make_api (T const V, T const M, T const m, T const p) {
      return ( ( ( (uint32_t)( V ) ) << 29U ) | ( ( (uint32_t)( M ) ) << 22U ) | ( ( (uint32_t)( m ) ) << 12U ) | ( (uint32_t)( p ) ) );
    } // cdk.version.make_api

    template <typename T> constexpr uint32_t make (T const M, T const m, T const p) {
      return cdk::version::make_api(0, M,m,p);
    } // cdk.version.make
  } // namespace version

  //______________________________________
  // @section Systems aliasing
  //____________________________
  #if defined __WIN32
  #  define windows
  constexpr bool Windows = true;
  constexpr bool Linux   = false;
  constexpr bool Mac     = false;
  #endif
  #if defined __linux__
  // #define linux
  constexpr bool Windows = false;
  constexpr bool Linux   = true;
  constexpr bool Mac     = false;
  #endif
  #if defined __APPLE__
  #  define macosx
  constexpr bool Windows = false;
  constexpr bool Linux   = false;
  constexpr bool Mac     = true;
  #endif

  //______________________________________
  // @section Build Mode aliasing
  //____________________________
  #if defined NDEBUG || !defined DEBUG
  constexpr bool release = true;
  constexpr bool debug   = false;
  #elif defined DEBUG
  constexpr bool release = false;
  constexpr bool debug   = true;
  #endif
} // namespace cdk

