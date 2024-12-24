package vfx;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxShader;

class FishColorShader extends FlxShader
{
    public var fromColor(default, set):FlxColor;
    public var toColor(default, set):FlxColor;

    @:glFragmentSource("
    #pragma header

    uniform vec4 _fromColor;
    uniform vec4 _toColor;

    void main()
    {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        gl_FragColor = color;
    }
    ")

    public function new(toColor:Null<FlxColor>, ?fromColor:Null<FlxColor>) 
    {
        super();

        this.toColor = toColor;
        this.fromColor = fromColor ?? FlxColor.GREEN;
        trace(this.fromColor);
    }

    // this allocs array probably bad but oh well lol
    private inline function colorToVec4(color:FlxColor):Array<Float>
    {
        return [color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat];
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
