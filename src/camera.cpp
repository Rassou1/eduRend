#include "Camera.h"
#include <cstdint>

using namespace linalg;

void Camera::MoveTo(const vec3f& position) noexcept
{
	m_position = position;
}

void Camera::Move(const vec3f& direction) noexcept
{
	m_position += direction;
}

void Camera::MoveForward() noexcept
{
	position4 = (m_position, 0);
	position4 += ViewToWorldMatrix() * fwd;
	m_position = (position4.x, position4.y, position4.z);
}

mat4f Camera::WorldToViewMatrix() const noexcept
{
	// Assuming a camera's position and rotation is defined by matrices T(p) and R,
	// the View-to-World transform is T(p)*R (for a first-person style camera).
	//
	// World-to-View then is the inverse of T(p)*R;
	//		inverse(T(p)*R) = inverse(R)*inverse(T(p)) = transpose(R)*T(-p)
	// Since now there is no rotation, this matrix is simply T(-p)



	//Fixed, now works as intended.
	return  (mat4f::translation(m_position) * m_rotation).inverse();//m_rotation * mat4f::translation(-m_position);
}

linalg::mat4f Camera::ViewToWorldMatrix() const noexcept
{
	return mat4f::translation(m_position) * m_rotation;
}

mat4f Camera::ProjectionMatrix() const noexcept
{
	return mat4f::projection(m_vertical_fov, m_aspect_ratio, m_near_plane, m_far_plane);
}

void Camera::RotationMatrix(long dx, long dy) noexcept
{
	yaw += dx * 0.002f;
	pitch += dy * 0.002f;
	
	m_rotation = mat4f::rotation(0, -yaw, -pitch);
}

