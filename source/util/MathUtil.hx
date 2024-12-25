package util;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxAxes;
import flixel.FlxObject;

class MathUtil
{
    public static function centerToArea(source:FlxRect, area:FlxRect, axes:FlxAxes):FlxPoint
    {
        var point = FlxPoint.get();
        if (axes.x)
            point.x = area.x + ((area.width - source.width) / 2);
        if (axes.y)
            point.y = area.y + ((area.height - source.height) / 2);

        source.put();
        area.put();

        return point;
    }

    /**
     * Exponential interpolation
     * @see https://twitter.com/FreyaHolmer/status/1813629237187817600
     *
     * @param a Minimum value of the range
     * @param b Maximum value of the range
     * @param t A value from 0.0 to 1.0, optional, by default will be a random value.
     */
    public static inline function eerp(a:Float, b:Float, ?t:Null<Float> = null):Float
    {
        if (t == null)
            t = FlxG.random.float();

        return a * Math.exp(t * Math.log(b / a));
    }
}
