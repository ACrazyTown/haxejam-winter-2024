package props.fish;

import flixel.FlxG;
import flixel.util.FlxColor;
import vfx.FishColorShader;
import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer;

class Fish extends FlxSpriteContainer implements IDraggable
{
    public var dragAllowed:Bool = true;
    public var pickupSound:Null<String> = null;

    public var data:FishData;

    var fish:FlxSprite;
    var fishShader:FishColorShader;

    public function new(x:Float = 0, y:Float = 0, data:FishData)
    {
        super(x, y);

        fish = new FlxSprite();
        add(fish);

        // fishShader = new FishColorShader(FlxColor.BLUE);
        // fish.shader = fishShader;
        fishShader = new FishColorShader();
        fish.shader = fishShader;

        loadFromData(data);
    }

    public function loadFromData(data:FishData)
    {
        this.data = data;

        fish.loadGraphic("assets/images/fish/tempfish.png");
        // Always force hue 0 (red) on evil fish
        fishShader.hue = data.evil ? 0 : data.color.hue;
        
        pickupSound = data.kind == CAT ? "assets/sounds/meow" : null;
    }
}
