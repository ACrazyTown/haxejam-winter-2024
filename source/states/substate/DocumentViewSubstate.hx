package states.substate;

import util.MathUtil;
import props.Document;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;
import props.Document.DocumentType;

class DocumentViewSubstate extends FlxSubState
{
    var overlay:FlxSprite;
    var bg:FlxSprite;
    var type:DocumentType;

    var parent:Document;

    public function new(type:DocumentType, parent:Document)
    {
        super();
        this.type = type;
        this.parent = parent;
    }

    override function create():Void
    {
        PlayState.instance.interactionsAllowed = false;
        parent.visible = false;
        var sound = FlxG.sound.play("assets/sounds/paper_grab");
        sound.pitch = MathUtil.eerp(0.9, 1.1);

        overlay = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
        overlay.alpha = 0.5;
        add(overlay);

        bg = new FlxSprite();
        add(bg);

        switch (type)
        {
            case Paper, Checklist:
                // TODO: Replace with asset
                bg.makeGraphic(500, 700);
                bg.screenCenter();

            case Book:
        }
    }

    // ewwwwwwwww
    var firstFrame:Bool = true;
    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE || (!FlxG.mouse.overlaps(bg) && FlxG.mouse.justPressed) && !firstFrame)
        {
            PlayState.instance.interactionsAllowed = true;
            parent.visible = true;
            close();
        }

        firstFrame = false;
    }
}
