package props;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import util.MathUtil;
import states.PlayState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Stamp extends FlxSprite implements IDraggable
{
    public var dragAllowed:Bool = true;
    public var pickupSound:Null<String> = null;

    public var initialX:Float;
    public var initialY:Float;

    var stampGraphic:String;

    public function new(x:Float = 0, y:Float = 0, accept:Bool)
    {
        super(x, y);
        initialX = x;
        initialY = y;

        loadGraphic('assets/images/stamp/stamp-${accept ? 'accept' : 'deny'}.png');
        stampGraphic = 'assets/images/stamp/stamp-${accept ? "good" : "bad"}.png';
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (PlayState.instance.curHolding == this && FlxG.mouse.justPressedRight)
        {
            var sound = FlxG.sound.play("assets/sounds/stamp");
            sound.pitch = MathUtil.eerp(0.95, 1.05);

            // var stamp:FlxSprite = new FlxSprite(this.x, this.y, stampGraphic);
            // PlayState.instance.stamps.add(stamp);

            var mat:Matrix = new Matrix();
            mat.identity();
            mat.tx = this.x - PlayState.instance.curFish.x;
            mat.ty = this.y - PlayState.instance.curFish.y;

            var bitmap:BitmapData = FlxGraphic.fromAssetKey(stampGraphic).bitmap;

            @:privateAccess
            PlayState.instance.curFish.stampBitmap.draw(bitmap, mat);
            PlayState.instance.curFish.applyMask();
        }
    }
}
