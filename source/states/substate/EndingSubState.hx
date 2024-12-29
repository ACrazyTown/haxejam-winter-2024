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
    POISONED;
    EVIL;
    EXPLODE;
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
        FlxG.sound.music.stop();

        switch (ending)
        {
            case TOO_MANY_PENALTIES:
                bg = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
                add(bg);

                FlxTimer.wait(3, () ->
                {
                    FlxG.sound.play("assets/sounds/bell");
                    var text = new FlxSprite(0, 0).loadGraphic("assets/images/ending/firedend.png");
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

            case POISONED:
                bg = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
                add(bg);

                FlxTimer.wait(3, () ->
                {
                    FlxG.sound.play("assets/sounds/bell");
                    var text = new FlxSprite(0, 0).loadGraphic("assets/images/ending/poisonend.png");
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

            case EVIL:
                bg = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
                add(bg);

                FlxTimer.wait(3, () ->
                {
                    FlxG.sound.play("assets/sounds/bell");
                    var text = new FlxSprite(0, 0).loadGraphic("assets/images/ending/evilfishend.png");
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
                
            case EXPLODE:
                FlxG.sound.play("assets/sounds/explode", 0.7);
                FlxG.camera.flash(FlxColor.WHITE, 4);

                var img = new FlxSprite().loadGraphic("assets/images/ending/explodedend.png");
                add(img);

                FlxTimer.wait(7, () ->
                {
                    FlxG.camera.fade(FlxColor.BLACK, 1, false, saveAndExit);
                });

        }
    }

    function saveAndExit():Void
    {
        trace("Survived rounds: " + PlayState.instance.survivedRounds);
        trace("Total time: " + PlayState.instance.totalTime);

        FlxG.save.data.survivedRounds = PlayState.instance.survivedRounds;
        FlxG.save.data.survivedTime = PlayState.instance.totalTime;
        FlxG.save.flush();

        FlxG.switchState(MenuState.new);
    }
}
