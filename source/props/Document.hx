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

        var graph:String = "assets/images/";
        switch (type)
        {
            case PAPER:
                graph += "infopaper.png";
            case CHECKLIST:
                graph += "checklist.png";
            case BOOK:
                graph += "fishbook.png";
        }
        loadGraphic(graph);

        if (type == BOOK)
        {
            // book graphic is weird so we have to resize it
            width = 194;
            height = 265;
        }
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
