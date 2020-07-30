Shader "Custom/SphericalMaskDissolveAlpha" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [HDR]_Emission("Emission", Color) = (1,1,1,1)
        _NoiseSize("Noise size", float ) = 1
        _Softness("Softness", float ) = 4
    }
    SubShader {
        Tags { "RenderType"="Transparent" }
        Blend One OneMinusSrcAlpha
        Cull Off
 
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        
        sampler2D _MainTex;
 
        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
        };
 
        fixed4 _Color;
 
        fixed4 _Emission;
        float _NoiseSize;
 
        float3 _GLOBALMaskPosition;
        half _GLOBALMaskRadius;
        half _Softness;
 
        float random (float2 input) 
        { 
            return frac(sin(dot(input, float2(12.9898,78.233)))* 43758.5453123);
        }
 
        void surf (Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            half dist = distance(_GLOBALMaskPosition, IN.worldPos);
            half sphere = 1 - saturate((dist - _GLOBALMaskRadius) / _Softness);
            clip(sphere - 0.1);
            float squares = step(0.5, random(floor(IN.uv_MainTex * _NoiseSize)));
            half emissionRing = step(sphere - 0.1, 0.1) * squares;
            
            o.Emission = _Emission * emissionRing;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}