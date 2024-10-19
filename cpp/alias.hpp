//:____________________________________________________________________
//  Cendk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:____________________________________________________________________
#pragma once
// std dependencies
#include <type_traits>

/// Alias function f2 to f1
#define alias(f1, f2) constexpr auto(f1) = (f2)

/// Alias function f2 to f1, when the function is overloaded
#define aliasf(f1, f2)                                                         \
  template <typename... Args>                                                  \
  auto f1(Args &&...args)->decltype(f2(std::forward<Args>(args)...)) {         \
    return f2(std::forward<Args>(args)...);                                    \
  }

/// Access integer value of any enum. Same as (c++23)std::to_underlying
template <typename T>
constexpr auto val(T const value) -> typename std::underlying_type<T>::type {
  static_assert(std::is_enum<T>::value,
                "Input value for val(...) is not of an enum or enum class");
  return static_cast<typename std::underlying_type<T>::type>(value);
}
