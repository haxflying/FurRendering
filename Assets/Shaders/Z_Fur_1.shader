Shader "Unlit/Z_Fur_1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "black" {}
		_BaseColor("baseColor",Color) = (1,1,1,1)
		_FurLength("Fur Length",Range(0,0.1)) = 0.1
		_CutOff("Alpha CutOff",Range(0,1)) = 0.0
	}
	CGINCLUDE
	#include "UnityCG.cginc"	

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : normal;
		float4 color : color;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		float4 screenPos  : TEXCOORD1;		
		float3 WorldNormal : TEXCOORD2;
		float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	sampler2D _NoiseTex;
	float4 _MainTex_ST;
	fixed4 _BaseColor;
	half _FurLength;
	half _CutOff;

	half GetLayer();
	void Stipped(v2f i);
			
	v2f vert (appdata v)
	{
		v2f o;
		half3 direction = v.color.xyz * 2.0 - 1.0;
		half length = v.color.a;
		half3 dir = v.normal.xyz + (direction * GetLayer());
		dir = normalize(dir);
		v.vertex.xyz += GetLayer() * dir * _FurLength * length;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		o.WorldNormal = UnityObjectToWorldNormal(v.normal);
		o.screenPos = ComputeScreenPos(o.vertex);
		return o;
	}
	
	void frag (v2f i,
		out half4 outGBuffer0 : SV_Target0,
	    out half4 outGBuffer1 : SV_Target1,
	    out half4 outGBuffer2 : SV_Target2,
	    out half4 outEmission : SV_Target3)
	{
		_CutOff *= GetLayer();
		Stipped(i);
		
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
			void Stipped(v2f i){}
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
				return 0.1;
			}	
			void Stipped(v2f i)
			{
				/*
				half2 screenCoord = (i.screenPos.xy / i.screenPos.w + 1.0) * 0.5;
				half2 sample = screenCoord.xy * _ScreenParams.xy;
				half2 tileIndices = half2((int)sample.x % 2, (int)sample.y % 2);
				if((tileIndices.x != 0 || tileIndices.y != 0))
					discard;*/
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_2"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.2;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_3"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.3;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_4"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.4;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_5"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.5;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_6"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.6;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_7"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.7;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_8"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.8;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_9"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.9;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}

		Pass
		{
			Name "DEFERRED_10"
			Tags { "LightMode" = "Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 1.0;
			}	
			void Stipped(v2f i)
			{
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
			}	
			ENDCG
		}
	}
}
