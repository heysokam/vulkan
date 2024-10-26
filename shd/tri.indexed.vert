#version 450
layout(location = 0) out vec3 vColor;

vec2 aPos [3]= vec2[](
  vec2( 0.0, -0.5),
  vec2( 0.5,  0.5),
  vec2(-0.5,  0.5)
  ); //:: aPos
vec3 aColor [3]= vec3[](
  vec3(1.0, 0.0, 0.0),
  vec3(0.0, 1.0, 0.0),
  vec3(0.0, 0.0, 1.0)
  ); //:: aColor


void main() {
  gl_Position = vec4(aPos[gl_VertexIndex], 0.0, 1.0);
  vColor      = aColor[gl_VertexIndex];
}

