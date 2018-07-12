Shader "Unlit/Z_Fur_Forward"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "black" {}
		_BaseColor("baseColor",Color) = (1,1,1,1)
		_FurLength("Fur Length",Range(0,0.1)) = 0.1
		_CutOff("Alpha CutOff",Range(0,1)) = 0.0
		_Smoothness("Smoothness", Range(0,20)) = 0.0
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
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
		float3 direction : TEXCOORD3;
		float3 worldPos : TEXCOORD4;
		float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	sampler2D _NoiseTex;
	float4 _MainTex_ST;
	fixed4 _BaseColor;
	fixed4 _SpecularColor;
	half _FurLength;
	half _CutOff;
	half _Smoothness;

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
		o.direction = dir;
		o.worldPos = mul(unity_ObjectToWorld, v.vertex);
		return o;
	}
	
	fixed4 frag (v2f i) : SV_Target
	{
		_CutOff *= GetLayer() * GetLayer();
		Stipped(i);
		
		float diffuse = saturate(dot(i.WorldNormal, _WorldSpaceLightPos0));
		diffuse = max(0.15, diffuse);
		half3 diffuseCol = _BaseColor.rgb * tex2D(_MainTex, i.uv) * diffuse;
		
		//calcu new normal
		float3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));		
		float LdotT = dot(_WorldSpaceLightPos0, i.direction);
		float LdotT2 = LdotT * LdotT;
		float VdotT = dot(worldViewDir, i.direction);
		float VdotT2 = VdotT * VdotT;
	    float specular = sqrt(1 - LdotT2) * sqrt(1 - VdotT2) - LdotT * VdotT;
	    float3 specularCol = pow(specular, _Smoothness) * _SpecularColor.rgb * diffuse;
	    float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

		return fixed4(diffuseCol + saturate(specularCol), 1);
	}
	ENDCG
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		
		Pass
		{
			Name "FWD_0"
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_0"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.1;
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
			Name "DEFERRED_1"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.05;
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
			Name "DEFERRED_2"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.15;
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
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_4"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.25;
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
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_6"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.35;
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
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_8"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.45;
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
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_10"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.55;
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
			Name "DEFERRED_11"
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_12"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.65;
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
			Name "DEFERRED_13"
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_14"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.75;
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
			Name "DEFERRED_15"
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_16"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.85;
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
			Name "DEFERRED_17"
			Tags { "LightMode" = "ForwardBase" }
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
			Name "DEFERRED_18"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag		
			half GetLayer()
			{
				return 0.95;
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
			Name "DEFERRED_19"
			Tags { "LightMode" = "ForwardBase" }
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
