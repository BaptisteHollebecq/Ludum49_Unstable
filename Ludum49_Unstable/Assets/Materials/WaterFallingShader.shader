// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterFallingShader"
{
	Properties
	{
		_MainColor("Main Color", Color) = (0,0.6701975,1,0)
		_MainColor2("Main Color 2", Color) = (0,0.6701975,1,0)
		_SecondColorPosition("Second Color Position", Range( -1 , 1)) = -0.73
		_SecondColorContrast("Second Color Contrast", Range( 0 , 1)) = 0
		_Transmission("Transmission", Range( -1 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_NormalMap1("Normal Map 1", 2D) = "bump" {}
		_Normal1Scale("Normal 1 Scale", Float) = 1
		_NormalMap2("Normal Map 2", 2D) = "bump" {}
		_Normal2Scale("Normal 2 Scale", Float) = 1
		_NormalMapSpeed("Normal Map Speed", Vector) = (0,0.5,0,0.1)
		_FoamDiffuse("Foam Diffuse", 2D) = "white" {}
		[HDR]_FoamColor("Foam Color", Color) = (1,1,1,0)
		_FoamNormal("Foam Normal", 2D) = "bump" {}
		_FoamNormalScale("Foam Normal Scale", Float) = 0
		_FoamPosition("Foam Position", Range( -1 , 1)) = -0.73
		_FoamContrast("Foam Contrast", Range( 0 , 1)) = 0
		_VertexDisplacementAmount("Vertex Displacement Amount", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustom alpha:fade keepalpha exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Transmission;
		};

		uniform sampler2D _Texture0;
		uniform float4 _NormalMapSpeed;
		uniform sampler2D _NormalMap1;
		uniform float4 _NormalMap1_ST;
		uniform sampler2D _NormalMap2;
		uniform float4 _NormalMap2_ST;
		uniform float _VertexDisplacementAmount;
		uniform float _FoamPosition;
		uniform float _FoamContrast;
		uniform sampler2D _FoamNormal;
		uniform float4 _FoamNormal_ST;
		uniform float _FoamNormalScale;
		uniform float _Normal1Scale;
		uniform float _Normal2Scale;
		uniform float4 _MainColor2;
		uniform float4 _MainColor;
		uniform float _SecondColorPosition;
		uniform float _SecondColorContrast;
		uniform sampler2D _FoamDiffuse;
		uniform float4 _FoamDiffuse_ST;
		uniform float4 _FoamColor;
		uniform float _Smoothness;
		uniform float _Transmission;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult72 = (float2(_NormalMapSpeed.x , _NormalMapSpeed.y));
			float2 uv_NormalMap1 = v.texcoord.xy * _NormalMap1_ST.xy + _NormalMap1_ST.zw;
			float2 panner54 = ( _Time.y * appendResult72 + uv_NormalMap1);
			float2 appendResult73 = (float2(_NormalMapSpeed.z , _NormalMapSpeed.w));
			float2 uv_NormalMap2 = v.texcoord.xy * _NormalMap2_ST.xy + _NormalMap2_ST.zw;
			float2 panner64 = ( _Time.y * appendResult73 + uv_NormalMap2);
			float temp_output_162_0 = ( tex2Dlod( _Texture0, float4( panner54, 0, 0.0) ).r * tex2Dlod( _Texture0, float4( panner64, 0, 0.0) ).r );
			float smoothstepResult160 = smoothstep( 0.79 , 1.0 , v.texcoord.xy.y);
			float temp_output_152_0 = ( ( (-1.0 + (temp_output_162_0 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * ( 1.0 - smoothstepResult160 ) ) * _VertexDisplacementAmount );
			float3 appendResult149 = (float3(temp_output_152_0 , temp_output_152_0 , 0.0));
			v.vertex.xyz += appendResult149;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + d;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult136 = smoothstep( _FoamPosition , ( _FoamPosition + _FoamContrast ) , ase_vertex3Pos.y);
			float2 uv_FoamNormal = i.uv_texcoord * _FoamNormal_ST.xy + _FoamNormal_ST.zw;
			float2 appendResult72 = (float2(_NormalMapSpeed.x , _NormalMapSpeed.y));
			float2 uv_NormalMap1 = i.uv_texcoord * _NormalMap1_ST.xy + _NormalMap1_ST.zw;
			float2 panner54 = ( _Time.y * appendResult72 + uv_NormalMap1);
			float2 appendResult73 = (float2(_NormalMapSpeed.z , _NormalMapSpeed.w));
			float2 uv_NormalMap2 = i.uv_texcoord * _NormalMap2_ST.xy + _NormalMap2_ST.zw;
			float2 panner64 = ( _Time.y * appendResult73 + uv_NormalMap2);
			o.Normal = BlendNormals( UnpackScaleNormal( float4( ( smoothstepResult136 * UnpackNormal( tex2D( _FoamNormal, uv_FoamNormal ) ) ) , 0.0 ), _FoamNormalScale ) , BlendNormals( UnpackScaleNormal( float4( UnpackNormal( tex2D( _NormalMap1, panner54 ) ) , 0.0 ), _Normal1Scale ) , UnpackScaleNormal( float4( UnpackNormal( tex2D( _NormalMap2, panner64 ) ) , 0.0 ), _Normal2Scale ) ) );
			float smoothstepResult116 = smoothstep( _SecondColorPosition , ( _SecondColorPosition + _SecondColorContrast ) , ase_vertex3Pos.y);
			float4 lerpResult120 = lerp( _MainColor2 , _MainColor , smoothstepResult116);
			float2 uv_FoamDiffuse = i.uv_texcoord * _FoamDiffuse_ST.xy + _FoamDiffuse_ST.zw;
			o.Albedo = ( lerpResult120 + ( ( tex2D( _FoamDiffuse, uv_FoamDiffuse ) * _FoamColor ) * smoothstepResult136 ) ).rgb;
			o.Smoothness = _Smoothness;
			float3 temp_cast_4 = (_Transmission).xxx;
			o.Transmission = temp_cast_4;
			float temp_output_162_0 = ( tex2D( _Texture0, panner54 ).r * tex2D( _Texture0, panner64 ).r );
			o.Alpha = temp_output_162_0;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
371;73;1183;626;-114.2519;612.3563;2.684178;True;False
Node;AmplifyShaderEditor.Vector4Node;71;-1058.748,-368.0922;Inherit;False;Property;_NormalMapSpeed;Normal Map Speed;10;0;Create;True;0;0;0;False;0;False;0,0.5,0,0.1;0,1,0,0.1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;57;-627.2734,-268.5926;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-584.6463,-618.1336;Inherit;False;0;50;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;72;-565.6301,-428.6261;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-620.2689,104.0996;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-604.6957,-87.54294;Inherit;False;0;60;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;62;-647.3228,261.998;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;64;-313.3073,79.93015;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;54;-293.2577,-450.6605;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;165;246.8487,367.354;Inherit;True;Property;_Texture0;Texture 0;18;0;Create;True;0;0;0;False;0;False;None;7d517a701e6cf1f44b4c8ee3b6e57cc6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;134;827.9783,-667.7592;Inherit;False;Property;_FoamPosition;Foam Position;15;0;Create;True;0;0;0;False;0;False;-0.73;-0.73;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;885.7128,-565.4549;Inherit;False;Property;_FoamContrast;Foam Contrast;16;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;150;706.0781,404.8876;Inherit;True;Property;_Noise;Noise;17;0;Create;True;0;0;0;False;0;False;-1;None;7d517a701e6cf1f44b4c8ee3b6e57cc6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;158;762.2703,812.7836;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;163;721.8364,614.7172;Inherit;True;Property;_Noise1;Noise;17;0;Create;True;0;0;0;False;0;False;-1;None;7d517a701e6cf1f44b4c8ee3b6e57cc6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;135;1189.671,-634.4059;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;788.9915,-1097.942;Inherit;False;Property;_SecondColorPosition;Second Color Position;2;0;Create;True;0;0;0;False;0;False;-0.73;-0.73;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;893.4166,-1001.025;Inherit;False;Property;_SecondColorContrast;Second Color Contrast;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;113;1006.9,-1286.861;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;160;992.0544,816.4235;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.79;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;1038.935,490.818;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;118;1143.501,-1096.913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;130;1582.092,-1025.28;Inherit;True;Property;_FoamDiffuse;Foam Diffuse;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;348.7267,-320.0456;Inherit;False;Property;_Normal1Scale;Normal 1 Scale;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;136;1359.918,-758.0966;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;5.12175,35.72705;Inherit;True;Property;_NormalMap2;Normal Map 2;8;0;Create;True;0;0;0;False;0;False;-1;2025b00838fb01443876acd51f9f1221;2025b00838fb01443876acd51f9f1221;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;129;1099.436,-448.9963;Inherit;True;Property;_FoamNormal;Foam Normal;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;413.886,183.9491;Inherit;False;Property;_Normal2Scale;Normal 2 Scale;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;5.161118,-455.5782;Inherit;True;Property;_NormalMap1;Normal Map 1;6;0;Create;True;0;0;0;False;0;False;-1;8662d55792e936443b636333a73cbcbd;8662d55792e936443b636333a73cbcbd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;161;1237.063,819.8957;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;156;1306.866,582.0876;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;143;1684.377,-720.5938;Inherit;False;Property;_FoamColor;Foam Color;12;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;4,4,4,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;1672.008,582.4456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;52;585.4966,-424.9038;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;116;1311.952,-1227.787;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;110;680.0429,46.24661;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;74;1238.093,-1442.501;Inherit;False;Property;_MainColor;Main Color;0;0;Create;True;0;0;0;False;0;False;0,0.6701975,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;139;1465.408,-246.4066;Inherit;False;Property;_FoamNormalScale;Foam Normal Scale;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;1554.04,-444.9465;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;1912.743,-980.8652;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;112;1236.267,-1704.653;Inherit;False;Property;_MainColor2;Main Color 2;1;0;Create;True;0;0;0;False;0;False;0,0.6701975,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;153;1504.884,927.7815;Inherit;False;Property;_VertexDisplacementAmount;Vertex Displacement Amount;17;0;Create;True;0;0;0;False;0;False;0;1500;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;138;1730.428,-343.0612;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;2091.132,-949.022;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;109;952.3999,-39.6256;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;1880.945,563.9735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;120;1681.559,-1309.047;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;137;1716.444,-72.31484;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;95;1817.724,68.07449;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;149;2220.6,204.7775;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;144;2233.928,-995.4056;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;105;1450.963,312.2426;Inherit;False;Property;_Transmission;Transmission;4;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2509.968,-65.6683;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WaterFallingShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;72;0;71;1
WireConnection;72;1;71;2
WireConnection;73;0;71;3
WireConnection;73;1;71;4
WireConnection;64;0;61;0
WireConnection;64;2;73;0
WireConnection;64;1;62;2
WireConnection;54;0;55;0
WireConnection;54;2;72;0
WireConnection;54;1;57;2
WireConnection;150;0;165;0
WireConnection;150;1;54;0
WireConnection;163;0;165;0
WireConnection;163;1;64;0
WireConnection;135;0;134;0
WireConnection;135;1;133;0
WireConnection;160;0;158;2
WireConnection;162;0;150;1
WireConnection;162;1;163;1
WireConnection;118;0;117;0
WireConnection;118;1;119;0
WireConnection;136;0;113;2
WireConnection;136;1;134;0
WireConnection;136;2;135;0
WireConnection;60;1;64;0
WireConnection;50;1;54;0
WireConnection;161;0;160;0
WireConnection;156;0;162;0
WireConnection;157;0;156;0
WireConnection;157;1;161;0
WireConnection;52;0;50;0
WireConnection;52;1;53;0
WireConnection;116;0;113;2
WireConnection;116;1;117;0
WireConnection;116;2;118;0
WireConnection;110;0;60;0
WireConnection;110;1;111;0
WireConnection;131;0;136;0
WireConnection;131;1;129;0
WireConnection;140;0;130;0
WireConnection;140;1;143;0
WireConnection;138;0;131;0
WireConnection;138;1;139;0
WireConnection;147;0;140;0
WireConnection;147;1;136;0
WireConnection;109;0;52;0
WireConnection;109;1;110;0
WireConnection;152;0;157;0
WireConnection;152;1;153;0
WireConnection;120;0;112;0
WireConnection;120;1;74;0
WireConnection;120;2;116;0
WireConnection;137;0;138;0
WireConnection;137;1;109;0
WireConnection;149;0;152;0
WireConnection;149;1;152;0
WireConnection;144;0;120;0
WireConnection;144;1;147;0
WireConnection;0;0;144;0
WireConnection;0;1;137;0
WireConnection;0;4;95;0
WireConnection;0;6;105;0
WireConnection;0;9;162;0
WireConnection;0;11;149;0
ASEEND*/
//CHKSM=C0F7FE59BAA037D06E760101390CBF24CCDD2224