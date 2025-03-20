
Texture2D texDiffuse : register(t0);

cbuffer LightCamBuffer : register(b0)
{
    float4 cameraPosition;
    float4 lightPosition;
};

cbuffer MaterialBuffer : register(b1)
{
    float4 ambientClr;
    float4 diffuseClr;
    float4 specularClr;
}

struct PSIn
{
	float4 Pos  : SV_Position;
    float3 WorldPos : POSITION_WORLD;
    float3 WorldNormal : NORMAL_WORLD;
	float3 Normal : NORMAL;
	float2 TexCoord : TEX;
};

//-----------------------------------------------------------------------------------------
// Pixel Shader
//-----------------------------------------------------------------------------------------

float4 PS_main(PSIn input) : SV_Target
{
	// Debug shading #1: map and return normal as a color, i.e. from [-1,1]->[0,1] per component
	// The 4:th component is opacity and should be = 1
	//return float4(input.Normal*0.5+0.5, 1);
	
	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
//	return float4(input.TexCoord, 0, 1);
	
	//MAYBE EXTEND THE BUFFER TO HAVE LIGHT POSITION AND ANGLE???
   
    //Normal of surface.
    float3 inputNormal = input.WorldNormal;
    
    //Normal of light source.
    float3 lightNormal = (lightPosition.xyz - input.WorldPos);
    
    //Ambient term of surface material.
    float3 ambient = ambientClr.xyz;
    
    //Diffuse term of the surface material.
    //Changed this a bit and it changed how colors look a LOT. maybe it isn't a good idea
    float diffuseIntensity = max(dot(inputNormal, lightNormal), 0.0f);
    float3 diffuse = diffuseClr.xyz * diffuseIntensity;
    
    //Normals to be used in the specular calculation.
    float3 cameraNormal = normalize(cameraPosition.xyz - input.WorldPos);
    float3 reflectedRay = reflect(-lightNormal, cameraNormal);
    
    //Specular term of the surface material.
    //Shininess was stored in the w value of a vec4 earlier. Now it is a float3 and a float.
    float shininess = specularClr.w;
    float specularIntensity = pow(max(0, dot(reflectedRay, cameraNormal)), shininess);
    float3 specular = specularClr.xyz * specularIntensity;	
    
	
    //CALCULATIONS APPLY TO EVERY SINGLE OBJECT. FIGURE OUT HOW TO MAKE THEM ONLY WORK ON ONE (1) THING AT A TIME
    float3 finalColor = diffuse; //+ ambient; + specular;
    return float4(finalColor, 1);
	
}