package vfx;

import flixel.system.FlxAssets.FlxShader;

class MaskShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header

    void main()
    {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        
        if (color.rgb == vec3(0.0, 0.0, 0.0))
        {
            color = vec4(0.0, 0.0, 0.0, 0.0);
        }
        
        gl_FragColor = color;
    }
    
    ')

    public function new()
    {
        super();
    }
}
