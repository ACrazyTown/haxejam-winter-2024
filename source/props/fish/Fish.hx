package props.fish;

import vfx.MaskShader;
import openfl.geom.Rectangle;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;
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

    // stamp
    var stampBitmap:BitmapData;
    var mask:BitmapData;
    var stampSprite:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, data:FishData)
    {
        super(x, y);

        fish = new FlxSprite();
        add(fish);

        // fishShader = new FishColorShader(FlxColor.BLUE);
        // fish.shader = fishShader;
        fishShader = new FishColorShader();
        fish.shader = fishShader;

        stampSprite = new FlxSprite();
        // ughhhhhhhhhhh
        // maybe im just not doing it right but the alpha mask
        // leaves black pixels behind instead of making them transparent
        // so we have to resort to erasing them with a shader
        // fml
        stampSprite.shader = new MaskShader();
        add(stampSprite);

        loadFromData(data);
    }

    public function loadFromData(data:FishData)
    {
        this.data = data;

        // fish.loadGraphic("assets/images/fish/tempfish.png");
        var path = 'assets/images/fish/${data.kind}.png';
        if (data.bomb)
            path = 'assets/images/fish/bomb.png';
        if (data.evil)
            path = 'assets/images/fish/evil.png';

        if (!FlxG.assets.exists(path))
            fish.loadGraphic("assets/images/fish/tempfish.png");
        else
            fish.loadGraphic(path);

        if (stampBitmap != null)
        {
            stampBitmap.dispose();
            stampBitmap = null;
        }

        stampBitmap = new BitmapData(fish.frameWidth, fish.frameHeight, true, 0);
        // stampBitmap.fillRect(new Rectangle(0, 0, stampBitmap.width, stampBitmap.height), 0);
        // stampBitmap.fillRect(new Rectangle(0, 0, FlxG.width, FlxG.height), 0);
        createMask();
        applyMask();

        if (data.color == null)
            fishShader.enabled = false;
        else
        {
            fishShader.enabled = true;
            // Always force hue 0 (red) on evil fish
            fishShader.hue = data.evil ? 0 : data.color.hue;
        }
        
        pickupSound = "assets/sounds/fish";
        if (!data.evil && !data.bomb)
        {
            if (data.kind == CAT)
                pickupSound = "assets/sounds/meow";
            if (data.kind == DOG)
                pickupSound = "assets/sounds/bark";
        }

        recalcOffset();
    }

    function createMask():Void
    {
        if (mask != null)
        {
            mask.dispose();
            mask = null;
        }

        mask = fish.pixels.clone();
        for (x in 0...mask.width)
        {
            for (y in 0...mask.height)
            {
                if (mask.getPixel32(x, y) != 0)
                    mask.setPixel32(x, y, FlxColor.RED);
            }
        }
    }

    public function applyMask():Void
    {
        FlxSpriteUtil.alphaMask(stampSprite, stampBitmap, mask);
        recalcOffset();
    }

    function recalcOffset():Void
    {
        // big fish why are you so big and fat
        if (data.kind == BIG)
        {
            var halfW = fish.frameWidth / 2;
            var quartW = halfW / 2;
            var halfH = fish.frameHeight / 2;
            var quartH = halfH / 2;

            // fish.offset.x = -halfW;
            // fish.offset.y = -halfH;

            fish.width = halfW;
            fish.height = halfH;
            fish.offset.set(quartW, quartH);
            stampSprite.width = halfW;
            stampSprite.height = halfH;
            stampSprite.offset.set(quartW, quartH);
        }
        else
        {
            offset.set(0, 0);
            stampSprite.offset.set(0, 0);
        }
    }
}
