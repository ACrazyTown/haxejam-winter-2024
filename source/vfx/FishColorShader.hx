package vfx;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxShader;

class FishColorShader extends FlxShader
{
    public var threshold(default, set):Float;
    public var softness(default, set):Float;
    public var fromColor(default, set):FlxColor;
    public var toColor(default, set):FlxColor;

    @:glFragmentSource("
    #pragma header

    uniform float _threshold;
    uniform float _softness;
    uniform vec4 _fromColor;
    uniform vec4 _toColor;

    void main()
    {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

        if (color.rgb == vec3(0.0))
        {
            gl_FragColor = color;
            return;
        }

        float diff = distance(color.rgb, _fromColor.rgb) - _threshold;
        float factor = clamp(diff / _softness, 0.0, 1.0);

        gl_FragColor = vec4(mix(_toColor.rgb, color.rgb, factor), color.a);
    }
    ")

    public function new(toColor:Null<FlxColor>, ?fromColor:Null<FlxColor>) 
    {
        super();

        threshold = 0.5;
        softness = 0.3;
        this.toColor = toColor;
        this.fromColor = fromColor ?? FlxColor.GREEN;
        trace(this.fromColor);
    }

    // this allocs array probably bad but oh well lol
    private inline function colorToVec4(color:FlxColor):Array<Float>
    {
        return [color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat];
    }

    @:noCompletion function set_threshold(value:Float):Float
    {
        this._threshold.value = [value];
        return threshold = value;
    }

    @:noCompletion function set_softness(value:Float):Float
    {
        this._softness.value = [value];
        return softness = value;
    }

    @:noCompletion function set_fromColor(value:FlxColor):FlxColor 
    {
        this._fromColor.value = colorToVec4(value);
        return fromColor = value;
    }

    @:noCompletion function set_toColor(value:FlxColor):FlxColor 
    {
        this._toColor.value = colorToVec4(value);
        trace(this._toColor.value);
        return toColor = value;
    }
}
