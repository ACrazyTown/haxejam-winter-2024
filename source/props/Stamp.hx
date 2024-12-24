package props;

import states.PlayState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Stamp extends FlxSprite
{
    var stampGraphic:String;
    public function new(x:Float = 0, y:Float = 0, accept:Bool)
    {
        super(x, y);

        makeGraphic(132, 83, accept ? FlxColor.GREEN : FlxColor.RED);
        stampGraphic = 'assets/images/stamp/stamp-${accept ? "good" : "bad"}.png';
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (PlayState.instance.curHolding == this && FlxG.mouse.justPressedRight)
        {
            var stamp:FlxSprite = new FlxSprite(this.x, this.y, stampGraphic);
            PlayState.instance.stamps.add(stamp);
        }
    }
}
