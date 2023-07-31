package;

import flixel.system.FlxAssets.FlxShader;

import openfl.filters.ShaderFilter;

/*  GLOWING EDGE SHADER
    THE ORIGINAL VERSION OF THIS CODE WAS WROTE BY MTM101, ERIZUR AND T5MPLER (BUGFIXES)
    AND EDITED VERSION BY TECHNIKTIL
*/

/*class GlowingEdgeEffect
{
    public var shader(default,null):GlowingEdgeShader = new GlowingEdgeShader();

	public function new():Void
	{
		trace('Glowing Edge Shader ACTIVATED :DDDDD');
	}
    
}

class DesaturationShader extends FlxShader
{
    
    @:glFragmentSource('
    vec4 desaturate(vec3 color, float factor)
    {
        vec3 lum = vec3(0.299, 0.587, 0.114);
        vec3 gray = vec3(dot(lum, color));
        return vec4(mix(color, gray, factor), 1.0);
    }
    
    void main()
    {
        vec2 uv = fragCoord.xy / iResolution.xy;
        
        fragColor = desaturate(texture(iChannel0, uv).rgb, 1.0);
    }
    ')
    

    public function new() {
        super();
        trace('Desaturation Shader Initalized B)');
    }
}*/

class GlowingEdgeShader extends FlxShader
{
    
    @:glFragmentSource('
    #pragma header

    #define iResolution openfl_TextureSize
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    
    void mainImage(out vec4 fragColor, in vec2 fragCoord)
    {
        // Normalized pixel coordinates (from 0 to 1)
        vec2 uv = fragCoord/iResolution.xy;
        vec2 unit = 1./iResolution.xy;
        
        float o = 1.0;
        float p = 3.0;
        float q = 0.0;
        
        
        vec4 col11 = texture(iChannel0, uv + vec2(-unit.x, -unit.y));
        vec4 col12 = texture(iChannel0, uv + vec2( 0., -unit.y));
        vec4 col13 = texture(iChannel0, uv + vec2( unit.x, -unit.y));
        
        vec4 col21 = texture(iChannel0, uv + vec2(-unit.x, 0.));
        vec4 col22 = texture(iChannel0, uv + vec2( 0., 0.));
        vec4 col23 = texture(iChannel0, uv + vec2( unit.x, 0.));
        
        vec4 col31 = texture(iChannel0, uv + vec2(-unit.x, unit.y));
        vec4 col32 = texture(iChannel0, uv + vec2( 0., unit.y));
        vec4 col33 = texture(iChannel0, uv + vec2( unit.x, unit.y));
        
        vec4 x = col11 * -o + col12 * -p + col13 * -o + col31 * o + col32 * p + col33 * o + col22 * q;
        vec4 y = col11 * -o + col21 * -p + col31 * -o + col13 * o + col23 * p + col33 * o + col22 * q;
        
        // Output to screen
        fragColor = vec4(abs(y.rgb) * 0.5 + abs(x.rgb) * 0.5, texture(iChannel0, uv));
    }
    
    void main() {
        mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
    }
    ')
    

    public function new() {
        super();
        trace('Glowing Edge Shader Initalized B)');
    }
}

