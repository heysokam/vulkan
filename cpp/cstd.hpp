//:___________________________________________________________________
//  cdk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// stdlib dependencies and Non-standard extensions  |
//__________________________________________________|
#pragma once

// Aliases
#include <iostream>
typedef std::string str;
typedef const char* cstr;
#include <cstdint>
typedef int64_t  i64;
typedef int32_t  i32;
typedef int16_t  i16;
typedef int8_t   i8;
typedef uint64_t u64;
typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t  u8;
typedef uint8_t  byte;
typedef float    f32;
typedef double   f64;

// Arrays / lists
#include <vector>
template<typename T>
using vec = std::vector<T>;


// Math
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

//___________________________________________________________________
// Functions
//____________________________
// std dependencies
#include <fstream>


// clang-format off
//____________________________

/// Discards the given input.
#define unused(it) (void)(it)
/// Discards the given list of inputs.
template<class... Args> inline void discard(__attribute__((unused)) Args... args) {}
/// Prints the given msg to console.
inline void echo(str msg) { std::cout << msg << std::endl; }
/// Echoes the given list of messages to console.
template<class... Args> void prnt(Args... args);
/// Prints the given list of messages to console, without a `\n` at the end.
template<class... Args> void echo(Args... args);
/// Formats the given varargs into a string.
template<class... Args> str f(Args... args);
/// Reports the given error code and message.
void err(i32 code, str msg);

//____________________________
// clang-format on

enum class Error { fail, warn };
#define fn __PRETTY_FUNCTION__  // Function name

