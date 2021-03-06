// Copyright 2017 Benjamin Glatzel
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
#extension GL_GOOGLE_include_directive : enable

#define ADD_THREADS_X 64
#define ADD_THREADS_Y 2

layout(binding = 0) uniform PerInstance
{
  uvec4 dim;
  ivec4 mipLevel;
}
uboPerInstance;

layout(binding = 1) uniform sampler2D input0Tex;
layout(binding = 2) uniform sampler2D input1Tex;
layout(binding = 3, rgba16f) uniform image2D output0Tex;

layout(local_size_x = ADD_THREADS_X, local_size_y = ADD_THREADS_Y) in;
void main()
{
  imageStore(output0Tex, ivec2(gl_GlobalInvocationID.xy),
             0.5 *
                 (texelFetch(input0Tex, ivec2(gl_GlobalInvocationID.xy),
                             uboPerInstance.mipLevel.x) +
                  textureLod(input1Tex, vec2((gl_GlobalInvocationID.xy + 0.5) /
                                             uboPerInstance.dim.xy),
                             uboPerInstance.mipLevel.y)));
}
