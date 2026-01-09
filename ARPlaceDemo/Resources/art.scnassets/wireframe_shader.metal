#include <metal_stdlib>
using namespace metal;

#pragma arguments
float4 wireframe_color = float4(0.0, 0.0, 0.0, 1.0);

#pragma body
// Simple wireframe-like effect: darken edges using barycentric coordinates if available.
// SceneKit provides _geometry and _surface inputs; this shader is kept minimal for demo.
