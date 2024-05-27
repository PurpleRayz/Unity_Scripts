Shader "lit/CubeDiffTextureEachFace"
{
    Properties {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _Face1 ("Face 1", 2D) = "black" {}
        _Face2 ("Face 2", 2D) = "black" {}
        _Face3 ("Face 3", 2D) = "white" {}
        _Face4 ("Face 4", 2D) = "white" {}
        _Face5 ("Face 5", 2D) = "white" {}   
        _Face6 ("Face 6", 2D) = "white" {}
        _BorderSizeF1 ("Border Size Face 1", Range(0, 0.5)) = 0
        _BorderSizeF2 ("Border Size Face 2", Range(0, 0.5)) = 0
        _BorderSizeF3 ("Border Size Face 3", Range(0, 0.5)) = 0.03
        _BorderSizeF4 ("Border Size Face 4", Range(0, 0.5)) = 0
    }

    SubShader {
        //Tags {"RenderType"="Opaque"}
        LOD 300

        Pass {
            // indicate that our pass is the "base" pass in forward
            // rendering pipeline. It gets ambient and main directional
            // light data set up; light direction in _WorldSpaceLightPos0
            // and color in _LightColor0
            Tags {"LightMode"="ForwardBase"}
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc" // for UnityObjectToWorldNormal
            #include "Lighting.cginc"

            // compile shader into multiple variants, with and without shadows
            // (we don't care about any lightmaps yet, so skip these variants)
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            // shadow helper functions and macros
            #include "AutoLight.cginc"


            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;
            };

            sampler2D _MainTex;
            sampler2D _Face1;
            sampler2D _Face2;
            sampler2D _Face3;
            sampler2D _Face4;
            sampler2D _Face5;
            sampler2D _Face6;
            float _BorderSizeF1;
            float _BorderSizeF2;
            float _BorderSizeF3;
            float _BorderSizeF4;
            half _Glossiness;
            half _Metallic;
            

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0.rgb;
                o.ambient = ShadeSH9(half4(worldNormal,1));
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            float4 _MainTex_ST;

            float4 frag (v2f i) : SV_Target
            {
                float4 col;
                if(i.normal.z > 0.999)
                    {
                         if(i.uv.x > (1.0 - _BorderSizeF1) || i.uv.x < _BorderSizeF1 || i.uv.y > (1.0 - _BorderSizeF1) || i.uv.y < _BorderSizeF1)
                            col = float4(0,0,0,1);
                        else
                            col = tex2D(_Face1, i.uv);
                    }
                else if(i.normal.z < -0.999)
                    {
                        //flipping face 3 texture so that it is orientated the same as sides 1,2&4
                        float2 uv = i.uv; 
                        uv.x = 1.0 - uv.x; //flip texture in the X
                        uv.y = 1.0 - uv.y; //flip texture in the Y
                        if(i.uv.x > (1.0 - _BorderSizeF3) || i.uv.x < _BorderSizeF3 || i.uv.y > (1.0 - _BorderSizeF3) || i.uv.y < _BorderSizeF3)
                            col = float4(0,0,0,1);
                        else
                            col = tex2D(_Face3, uv);
                     }
            else if(i.normal.x > 0.999) {
                if(i.uv.x > (1.0 - _BorderSizeF2) || i.uv.x < _BorderSizeF2 || i.uv.y > (1.0 - _BorderSizeF2) || i.uv.y < _BorderSizeF2)
                    col = float4(0,0,0,1);
                else
                    col = tex2D(_Face2, i.uv);
            }
            else if(i.normal.x < -0.999) {
                if(i.uv.x > (1.0 - _BorderSizeF4) || i.uv.x < _BorderSizeF4 || i.uv.y > (1.0 - _BorderSizeF4) || i.uv.y < _BorderSizeF4)
                    col = float4(0,0,0,1);
                else
                    col = tex2D(_Face4, i.uv);
            }
            else if(i.normal.y > 0.999) col = tex2D(_Face5, i.uv);
            else if(i.normal.y < -0.999) col = tex2D(_Face6, i.uv);
            else col = tex2D(_MainTex, i.uv);

                col.rgb *= i.diff + i.ambient;
                return col;
            }
        ENDCG
        }
    }
    FallBack "Diffuse"
}
