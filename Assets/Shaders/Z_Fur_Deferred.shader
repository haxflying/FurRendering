Shader "Unlit/Z_Fur_1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "black" {}
		_BaseColor("baseColor",Color) = (1,1,1,1)
		_FurLength("Fur Length",Range(0,0.1)) = 0.1
		_CutOff("Alpha CutOff",Range(0,1)) = 0.0
		_Roughness("Roughness", Range(0,1)) = 0.0
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
	}
	CGINCLUDE
	#include "UnityCG.cginc"	
	#include "Lighting.cginc"
	#include "UnityPBSLighting.cginc"
	#pragma shader_feature  LIGHTMAP_ON  
	#pragma shader_feature  DYNAMICLIGHTMAP_ON
	#pragma shader_feature  UNITY_SHOULD_SAMPLE_SH
	struct v2f
	{
		float2 uv : TEXCOORD0;
		float4 screenPos  : TEXCOORD1;		
		float3 WorldNormal : TEXCOORD2;
		float3 direction : TEXCOORD3;
		float3 worldPos : TEXCOORD4;
		float4 lmap : TEXCOORD5;
		half3 sh : TEXCOORD6;
		float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	sampler2D _NoiseTex;
	float4 _MainTex_ST;
	fixed4 _BaseColor;
	fixed4 _SpecularColor;
	half _FurLength;
	half _CutOff;
	half _Roughness;

	half GetLayer();
	void Stipped(v2f i);
			
	v2f vert (appdata_full v)
	{
		v2f o;
		half3 direction = v.color.xyz * 2.0 - 1.0;
		half length = v.color.a;
		half3 dir = v.normal.xyz + (direction * GetLayer());
		dir = normalize(dir);
		v.vertex.xyz += GetLayer() * dir * _FurLength * length;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.WorldNormal = UnityObjectToWorldNormal(v.normal);
		o.screenPos = ComputeScreenPos(o.vertex);
		o.direction = mul(unity_ObjectToWorld, dir);
		o.worldPos = mul(unity_ObjectToWorld, v.vertex);

		#ifdef DYNAMICLIGHTMAP_ON
		  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
		#else
		  o.lmap.zw = 0;
		#endif

		#ifdef LIGHTMAP_ON
		  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
		#else
		  o.lmap.xy = 0;
		    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
		      o.sh = 0;
		      o.sh = ShadeSHPerVertex (o.WorldNormal, o.sh);
		    #endif
		#endif
		return o;
	}
	
	void frag (v2f i,
		out half4 outGBuffer0 : SV_Target0,
	    out half4 outGBuffer1 : SV_Target1,
	    out half4 outGBuffer2 : SV_Target2,
	    out half4 outEmission : SV_Target3)
	{
		_CutOff *= GetLayer() * GetLayer();
		Stipped(i);		

		half3 diffuse = _BaseColor.rgb * tex2D(_MainTex, i.uv);
		float3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

		//calcu new normal
	    i.direction = i.direction - (dot(i.direction, i.WorldNormal) * i.WorldNormal);
		i.direction = normalize(i.direction);
		half3 binorm = cross(worldViewDir, i.direction);
		half3 grainNorm = cross(binorm, i.direction);
		grainNorm = normalize(grainNorm);

		SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
		o.Albedo = diffuse;
	    o.Specular = _SpecularColor.rgb;
	    o.Smoothness = 1 - _Roughness;
	    o.Normal = i.WorldNormal;

	    UnityGI gi;
    	UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
    	gi.indirect.diffuse = 0.3;
    	gi.light.dir = half3(0,1,0);

    	UnityGIInput giInput;
	    UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
	    giInput.light = gi.light;
	    giInput.worldPos = i.worldPos;
	    giInput.worldViewDir = worldViewDir;
	    giInput.atten = 1;
	    #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
	    	giInput.lightmapUV = i.lmap;
	    #else
	    	giInput.lightmapUV = 0.0;
	    #endif
	   	#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
	    	giInput.ambient = i.sh;
	    #else
	    	giInput.ambient.rgb = 0.0;
	    #endif
	    //LightingStandardSpecular_GI(o, giInput, gi);

    	outEmission = LightingStandardSpecular_Deferred (o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);				
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
			Name "DEFERRED_0"
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
				half a = tex2D(_NoiseTex, i.uv).a;
				clip(a - _CutOff);
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
			Tags { "LightMode" = "Deferred" }
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
			Name "DEFERRED_4"
			Tags { "LightMode" = "Deferred" }
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
			Name "DEFERRED_6"
			Tags { "LightMode" = "Deferred" }
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
			Name "DEFERRED_8"
			Tags { "LightMode" = "Deferred" }
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
			Name "DEFERRED_10"
			Tags { "LightMode" = "Deferred" }
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
			Name "DEFERRED_12"
			Tags { "LightMode" = "Deferred" }
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
			Name "DEFERRED_14"
			Tags { "LightMode" = "Deferred" }
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
			Name "DEFERRED_16"
			Tags { "LightMode" = "Deferred" }
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
			Name "DEFERRED_18"
			Tags { "LightMode" = "Deferred" }
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
