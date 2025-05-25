#include "Camera.h"


using namespace linalg;

void Camera::MoveTo(const vec3f& position) noexcept
{
	m_position = position;
}

void Camera::Move(const vec3f& direction) noexcept
{	
    forward = { sin(m_yaw), 0, cos(m_yaw)
    };
	vec3f right = {cos(m_yaw), 0, -sin(m_yaw) };

    forward = normalize(forward);
    right = normalize(right);

    vec3f moveVector = right * direction.x +
         vec3f(0, 1, 0) * direction.y + 
         forward * direction.z;

    m_position += moveVector;
}

mat4f Camera::WorldToViewMatrix() const noexcept
{
	// Assuming a camera's position and rotation is defined by matrices T(p) and R,
	// the View-to-World transform is T(p)*R (for a first-person style camera).
	//
	// World-to-View then is the inverse of T(p)*R;
	//		inverse(T(p)*R) = inverse(R)*inverse(T(p)) = transpose(R)*T(-p)
	// Since now there is no rotation, this matrix is simply T(-p)

	mat4f rotation = mat4f::rotation(0, m_yaw, m_pitch);
	rotation.transpose();
	mat4f position = mat4f::translation(-m_position);

	return rotation * position;
}

mat4f Camera::ProjectionMatrix() const noexcept
{
	return mat4f::projection(m_vertical_fov, m_aspect_ratio, m_near_plane, m_far_plane);
}

void Camera::UpdateRotation(long dx, long dy) 
{

	float maxPitch = fPI / 2;
	float minPitch = -fPI / 2;
	m_yaw -= dx * 0.001;
	m_pitch -= dy * 0.001;

	if (m_pitch < minPitch) {
		m_pitch = minPitch;
	}

	if (m_pitch > maxPitch) {
		m_pitch = maxPitch;
	}

}