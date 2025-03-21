#pragma once
#include "Model.h"

class Cube : public Model
{
	unsigned m_number_of_indices = 0;

public:
	Cube(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_Context);

	virtual void Render() const;

	~Cube() { };

	Material cube_material;

	float material_Shininess = 0.5;

	
	
};

