Shader "Unlit/Z_Fur_1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BaseColor("baseColor",Color) = (1,1,1,1)
		_FurLength("Fur Length",Range(0,1)) = 0.1
	}
	CGINCLUDE
	#include "UnityCG.cginc"	

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : normal;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		float3 WorldNormal : TEXCOORD1;
		float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;
	fixed4 _BaseColor;
	half _FurLength;

	half GetLayer();
			
	v2f vert (appdata v)
	{
		v2f o;
		v.vertex.xyz += GetLayer() * v.normal * _FurLength;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		o.WorldNormal = UnityObjectToWorldNormal(v.normal);
		return o;
	}
	
	void frag (v2f i,
		out half4 outGBuffer0 : SV_Target0,
	    out half4 outGBuffer1 : SV_Target1,
	    out half4 outGBuffer2 : SV_Target2,
	    out half4 outEmission : SV_Target3)
	{
		half3 diffuse = _BaseColor.rgb * tex2D(_MainTex, i.uv);
		outGBuffer0 = half4(diffuse, 1);
		//fur has no specular and smoothness
		outGBuffer1 = 0;
		outGBuffer2 = half4(i.WorldNormal * 0.5 + 0.5, 1.0);
		outEmission = 0;
	}
	ENDCG
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Name "DEFERRED_0"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.0;
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_1"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 1.0;
			}		
			ENDCG
		}
	}
}
