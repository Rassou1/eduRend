/**
 * @file buffers.h
 * @brief Contains constant buffers
*/

#pragma once

#include "vec/mat.h"

/**
 * @brief Contains transformation matrices.
*/
struct TransformationBuffer
{
	linalg::mat4f ModelToWorldMatrix; //!< Matrix for converting from object space to world space.
	linalg::mat4f WorldToViewMatrix; //!< Matrix for converting from world space to view space.
	linalg::mat4f ProjectionMatrix; //!< Matrix for converting from view space to clip cpace.
};

struct LightCamBuffer
{
	linalg::vec4f lightPos;
	linalg::vec4f cameraPos;
	int isSkybox;
	linalg::vec3f lightingPadding;
};

struct MaterialBuffer {
	linalg::vec4f diffuse;
	linalg::vec4f ambient;
	linalg::vec4f specular;
	float shininess;
	linalg::vec3f padding;
};