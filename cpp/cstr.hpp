#include "./cstd.hpp"

namespace cstring {
  inline bool eq (cstr const A, cstr const B) { return strcmp(A, B) == 0; }
} //:: cstr

