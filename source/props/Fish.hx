package props;

import flixel.util.FlxColor;
import vfx.FishColorShader;
import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer;

class Fish extends FlxSpriteContainer
{
    var fish:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, id:Int = 0)
    {
        super(x, y);

        fish = new FlxSprite().loadGraphic("assets/images/fish/tempfish.png");
        add(fish);

        var fs = new FishColorShader(FlxColor.BLUE);
        fish.shader = fs;
    }
}
