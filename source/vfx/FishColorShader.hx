package vfx;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxShader;

class FishColorShader extends FlxShader
{
    public var hue(default, set):Float;
    public var enabled(default, set):Bool;

    @:glFragmentSource("
    #pragma header

    uniform float _hue;
    uniform bool _enabled;

    // All components are in the range [0…1], including hue.
    vec3 rgb2hsv(vec3 c)
    {
        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }

    // All components are in the range [0…1], including hue.
    vec3 hsv2rgb(vec3 c)
    {
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }

    void main()
    {
        vec4 final;
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        
        if (_enabled)
        {
            vec3 colorHSV = rgb2hsv(color.rgb);
            colorHSV.r = _hue;

            final = vec4(hsv2rgb(colorHSV), color.a);
        }
        else
        {
            final = color;
        }

        gl_FragColor = final;
    }
    ")

    public function new()
    {
        super();
        hue = 0;
        enabled = true;
    }

    @:noCompletion function set_hue(value:Float):Float
    {
        this._hue.value = [value / 359];
        return hue = value;
    }

    @:noCompletion function set_enabled(value:Bool):Bool
    {
        this._enabled.value = [value];
        return enabled = value;
    }
}
