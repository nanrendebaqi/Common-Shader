Shader "ShaderZ/HotAir"//热空气主要利用uv的扭曲进行实现
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _GrabTex("Grab Texture", 2D) = "white" {}
    }
    SubShader
    {
        ZWrite off
        Cull off
        Tags { "RenderType"="Transparent" }
        GrabPass//捕获当前画面
        {
            "_GrabTex"
        }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            // Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members GrabPos)
            #pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _GrabTex;
            float4 _GrabTex_Tex;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 GrabPos: TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.GrabPos = ComputeGrabScreenPos(o.pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2Dproj(_GrabTex i.GrabPos);
                return col;
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
