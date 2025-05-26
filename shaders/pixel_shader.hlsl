
Texture2D texDiffuse : register(t0);
Texture2D normalTexture : register(t1);
TextureCube Skybox : register(t5);

SamplerState texSampler : register(s0);
SamplerState cubeSampler : register(s1);
SamplerState skyboxSampler : register(s2);

cbuffer LightCamBuffer : register(b0)
{
    float4 lightPos;
    float4 cameraPos;
    int isSkybox;
    float3 lightPadding;
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
    float3 Binormal : BINORMAL;
    float3 Tangent : TANGENT;
};

//-----------------------------------------------------------------------------------------
// Pixel Shader
//-----------------------------------------------------------------------------------------

float4 PS_main(PSIn input) : SV_Target
{
    if (isSkybox == 1)
    {
        float3 viewDir = normalize(input.PosWorld.xyz - cameraPos.xyz);
        float3 skyCOlor = Skybox.Sample(skyboxSampler, viewDir).rgb;
        return float4(skyCOlor, 1.0f);

    }
    
    
    float3x3 TBN = float3x3(normalize(input.Tangent), normalize(input.Binormal), input.Normal);
    
    
    //input.TexCoord *= 1.5;
    float4 textureColor = texDiffuse.Sample(texSampler, input.TexCoord);
   
    float3 normalTS = normalTexture.Sample(texSampler, input.TexCoord).xyz;
    
    //float3 N = normalize(input.Normal);
    float3 N = normalize(mul(TBN, normalTS));
    float3 L = normalize(lightPos.xyz - input.PosWorld);
    float3 V = normalize(cameraPos.xyz - input.PosWorld);
    float3 R = reflect(-L, N);
    
    float3 reflectionDirection = reflect(V, N);
    float3 reflectionColor = Skybox.Sample(skyboxSampler, reflectionDirection).xyz;
    
    float3 ambientTerm = ambient.xyz * textureColor.xyz;
    float diff = max(dot(L, N), 0.0f);
    float3 diffuseTerm = (diffuse.xyz * reflectionColor) * diff;
    float spec = pow(max(dot(R, V), 0.0f), shininess);
    float3 specularTerm = specular.xyz * spec * lightPos.w ;
    
    float3 finalColor = ambientTerm + diffuseTerm + specularTerm;
    return float4(finalColor, 1.0f);
	
	
	// Debug shading #1: map and return normal as a color, i.e. from [-1,1]->[0,1] per component
	// The 4:th component is opacity and should be = 1
	//return float4(input.Normal*0.5+0.5, 1);
	
	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
//	return float4(input.TexCoord, 0, 1);
}