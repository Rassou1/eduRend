
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
   
    
    float3 ambient = ambientClr.xyz;
    
    float shininess = specularClr.w;
    float3 specular = specularClr.xyz * shininess;
    
	
    float3 omniLight = float3(lightPosition.x, lightPosition.y, lightPosition.z);
	
    //Changed this a bit and it changed how colors look a LOT. maybe it isn't a good idea
    float diffuseIntensity = max(0, dot(input.Normal, omniLight));
    float3 diffuse = diffuseClr.xyz * diffuseIntensity;
	
    //CALCULATIONS APPLY TO EVERY SINGLE OBJECT. FIGURE OUT HOW TO MAKE THEM ONLY WORK ON ONE (1) THING AT A TIME
    float3 finalColor = diffuse + ambient; //+ specular;
    return float4(finalColor, 1);
	
}