Shader "Unphook/Vertex/Vertex Shade Alpha" {
Properties {
	_MainTex("Texture (RGBA)",2D) = "white" {}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha
	
	Pass {
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			
			struct appdata_t {
				float4 vertex:POSITION;
				float4 color:COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f {
				float4 vertex:SV_POSITION;
				float4 color:COLOR;
				UNITY_FOG_COORDS(0)
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert(appdata_t v) {
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				o.color = v.color;
				return o;
			}
			
			fixed4 frag(v2f i):COLOR {
				fixed4 tex = tex2D(_MainTex,i.texcoord);
				fixed4 col = 1-(1-tex)*(1-i.color);
				col.a = tex.a*i.color.a;
				UNITY_APPLY_FOG(i.fogCoord,col);
				return col;
			}
		ENDCG
	}
}
}