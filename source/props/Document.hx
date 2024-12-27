package props;

import ui.Mouse;
import states.PlayState;
import flixel.util.FlxColor;
import states.substate.DocumentViewSubstate;
import flixel.FlxG;
import flixel.FlxSprite;

class Document extends FlxSprite
{
    var type:DocumentType;
    public function new(x:Float, y:Float, type:DocumentType)
    {
        super(x, y);
        this.type = type;

        makeGraphic(140, 210, FlxColor.PURPLE);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (PlayState.instance.curHolding == null && PlayState.instance.interactionsAllowed && FlxG.state.subState == null)
        {
            if (FlxG.mouse.overlaps(this))
            {
                PlayState.instance.mouseState = CLICKABLE;

                if (FlxG.mouse.justPressed)
                {
                    trace("oke oke oke");
                    FlxG.state.openSubState(new DocumentViewSubstate(type, this));
                }
            }
        }
    }
}

enum DocumentType
{
    PAPER;
    CHECKLIST;
    BOOK;
}
