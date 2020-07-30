Shader "Custom/SphericalDissolveGround" {

    Properties {
        _Color ("Primary Color", Color) = (1,1,1,1)
        _MainTex ("Primary (RGB)", 2D) = "white" {}
		_Color2 ("Secondary Color", Color) = (1,1,1,1)
		_SecondTex ("Secondary (RGB)", 2D) = "white" {}
        _DissolveNoise("Dissolve Noise", 2D) = "white"{} 
        _Radius("Radius", float) = 0 
        _LineColor("Line Tint", Color) = (1,1,1,1)   
    }
 
    SubShader{
    
        Tags { "RenderType" = "Transparent" }         
 
        CGPROGRAM
        #pragma surface surf Lambert
         
        float3 _Position; 
         
        sampler2D _MainTex, _SecondTex;
        float4 _Color, _Color2;
        sampler2D _DissolveNoise;
        float4 _LineColor;
        half _GLOBALRadius;
         
         
        struct Input {
            float2 uv_MainTex : TEXCOORD0;
            float3 worldPos;
        	float3 worldNormal; 
         
        };
         
        void surf (Input IN, inout SurfaceOutput o) {
        
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
        	half4 c2 = tex2D(_SecondTex, IN.uv_MainTex) * _Color2;
         
        	
        	float3 blendNormal = saturate(pow(IN.worldNormal * 1.4,4));
            half4 nSide1 = tex2D(_DissolveNoise, (IN.worldPos.xy + _Time.x) * 0.2); 
        	half4 nSide2 = tex2D(_DissolveNoise, (IN.worldPos.xz + _Time.x) * 0.2);
        	half4 nTop = tex2D(_DissolveNoise, (IN.worldPos.yz + _Time.x) * 0.2);
         
        	float3 noisetexture = nSide1;
            noisetexture = lerp(noisetexture, nTop, blendNormal.x);
            noisetexture = lerp(noisetexture, nSide2, blendNormal.y);
         
        	
        	float3 dis = distance(_Position, IN.worldPos);
        	float3 sphere = 1 - saturate(dis / _GLOBALRadius);
         
        	float3 sphereNoise = noisetexture.r * sphere;
         
        	float3 DissolveLine = step(sphereNoise - 0.02, 0.01) * step(0.01, sphereNoise) ;
        	DissolveLine *= _LineColor; 
         
        	float3 primaryTex = (step(sphereNoise - 0.02, 0.01) * c.rgb);
        	float3 secondaryTex = (step(0.01, sphereNoise) * c2.rgb);
        	float3 resultTex = primaryTex + secondaryTex + DissolveLine;
        	
            o.Albedo = resultTex;
        	o.Emission = DissolveLine;
        	o.Alpha = c.a;
         
        }
        ENDCG
     
    }
        Fallback "Diffuse"
}