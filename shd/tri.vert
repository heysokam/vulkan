#version 450

layout(location = 0) in  vec2 aPos;
layout(location = 1) in  vec3 aColor;
layout(location = 0) out vec3 vColor;

void main() {
  vColor      = aColor;
  gl_Position = vec4(aPos, 0.0, 1.0);
}

