
Texture2D texDiffuse : register(t0);

cbuffer LightCamBuffer : register(b0)
{
    float4 lightPos;
    float4 cameraPos;
}

cbuffer MaterialBuffer : register(b1)
{
    float4 diffuse;
    float4 ambient;
    float4 specular;
    float shininess;
    float3 padding;
}

struct PSIn
{
	float4 Pos  : SV_Position;
	float3 Normal : NORMAL;
	float2 TexCoord : TEX;
    float3 PosWorld : POSITION;
};

//-----------------------------------------------------------------------------------------
// Pixel Shader
//-----------------------------------------------------------------------------------------

float4 PS_main(PSIn input) : SV_Target
{
    //float3 N = normalize(input.Normal);
    //float3 L = normalize(lightPos.xyz - input.PosWorld.xyz);
    //float3 V = normalize(cameraPos.xyz - input.PosWorld.xyz);
    //float3 R = reflect(-L, N);
    
    //float3 ambientTerm = ambient.xyz * lightPos.xyz;
    
    //float diff = max(dot(L, N), 0.0f);
    //float3 diffuseTerm = diffuse.xyz * diff * lightPos.xyz;
    //float spec = pow(max(dot(R, V), 0.0f), shininess);
    //float3 specularTerm = specular.xyz * spec * lightPos.xyz;
    
    //float3 finalColor = ambientTerm + diffuseTerm + specularTerm;
    
    float3 N = normalize(input.Normal);
    float3 L = normalize(lightPos.xyz - input.PosWorld);
    float3 V = normalize(cameraPos.xyz - input.PosWorld);
    float3 R = reflect(-L, N);
    
    float3 ambientTerm = ambient.xyz;
    float diff = max(dot(L, N), 0.0f);
    float3 diffuseTerm = diffuse.xyz * diff;
    float spec = pow(max(dot(R, V), 0.0f), shininess);
    float3 specularTerm = specular.xyz * spec * lightPos.xyz;
    
    float3 finalColor = ambientTerm + diffuseTerm + specularTerm;
    return float4(finalColor, 1.0f);
	
	
	// Debug shading #1: map and return normal as a color, i.e. from [-1,1]->[0,1] per component
	// The 4:th component is opacity and should be = 1
	//return float4(input.Normal*0.5+0.5, 1);
	
	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
//	return float4(input.TexCoord, 0, 1);
}