Shader "Fade/WithoutTexture"
{
    Properties
    {
        //_Alpha ("_Alpha", Range(0,1)) = 1
        _Color ("_Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True"}
        LOD 100
        ZWrite off
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            //sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            uniform float _Alpha;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                _Color.w = 0;
                fixed4 col = _Color;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                _Alpha += sin(_Time.y);
                if(_Alpha<0) _Alpha = _Alpha - _Alpha*2;
                col.a = _Alpha;
                return col;
                //UNITY_OPAQUE_ALPHA(col.a);
                //return fixed4(col.rgb, _Alpha);
            }
            ENDCG
        }
    }
}
