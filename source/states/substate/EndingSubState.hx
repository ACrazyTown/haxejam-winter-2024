package states.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

enum Ending
{
    TOO_MANY_PENALTIES;
    EVIL;
}

class EndingSubState extends FlxSubState
{
    var bg:FlxSprite;
    var ending:Ending;
    public function new(ending:Ending)
    {
        super();
        this.ending = ending;
    }

    override function create():Void
    {
        PlayState.instance.persistentUpdate = false;

        switch (ending)
        {
            case TOO_MANY_PENALTIES:

            case EVIL:
                bg = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
                add(bg);

                FlxTimer.wait(3, () ->
                {
                    FlxG.sound.play("assets/sounds/bell");
                    var text = new FlxSprite(0, 0).loadGraphic("assets/images/ending/evil.png");
                    text.screenCenter();
                    add(text);

                    FlxTimer.wait(5, () ->
                    {
                        FlxTween.tween(text, {alpha: 0}, 2, {
                            onComplete: (_) -> 
                            {
                                FlxTimer.wait(1, saveAndExit);
                            }
                        });
                    });
                });
        }
    }

    function saveAndExit():Void
    {
        // TODO: SAVE DATA
        FlxG.switchState(MenuState.new);
    }
}
