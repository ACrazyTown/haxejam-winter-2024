package states.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class TutorialSubstate extends FlxSubState
{
    static inline var popupPath:String = "assets/images/ui/tutorial/popup-";
    static inline var popupAmt:Int = 11;
    
    var pressPrompt:FlxSprite;
    var popups:FlxSprite;
    var currPopup:Int = 1;
    var inProgress:Bool = false;
    var canSwitchPopup:Bool = false;

    var onComplete:Void->Void;

    var dimOverlay:FlxSprite;

    public function new(onComplete:Void->Void)
    {
        super();
        this.onComplete = onComplete;
    }

    override function create():Void
    {
        trace("ay ay ay");
        dimOverlay = PlayState.instance.dimOverlay;
        startTutorial();
    }
    
    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (canSwitchPopup && FlxG.mouse.justPressed)
            switchTPopup();
    }

    function getCurrPopupPath()
    {
        var middle = Std.string(currPopup);
        if (currPopup < 10)
            middle = "0" + middle;

        return popupPath + middle + ".png";
    }

    function startTutorial()
    {
        inProgress = true;

        pressPrompt = new FlxSprite(-541, 573);
        pressPrompt.loadGraphic("assets/images/ui/tutorial/press.png");
        add(pressPrompt);

        FlxTween.tween(pressPrompt, {x: 0}, 1, {ease: FlxEase.cubeOut});

        popups = new FlxSprite(0, 0);
        popups.loadGraphic(getCurrPopupPath());
        popups.scale.set(0, 0);
        add(popups);

        animatePopup();
    }

    function switchTPopup()
    {
        canSwitchPopup = false;

        if (currPopup == popupAmt)
        {
            inProgress = false;

            FlxTween.tween(popups.scale, {x: 0, y: 0}, 1, 
                {
                    ease: FlxEase.cubeIn,
                    onComplete: (_) -> {
                        FlxTween.color(dimOverlay, 1, FlxColor.fromRGB(0, 0, 0, 100), FlxColor.TRANSPARENT, {
                            ease: FlxEase.cubeOut, 
                            onComplete: onTutorialEnd
                        });
                        FlxTween.tween(pressPrompt, {x: -541}, 1, {ease: FlxEase.cubeOut});
                    }
                }
            );
        }
        else
        {
            if (currPopup == 1)
            {
                FlxTween.color(dimOverlay, 1, FlxColor.fromRGB(0, 0, 0, 100), FlxColor.TRANSPARENT, {ease: FlxEase.cubeOut});
            }
            else if (currPopup == popupAmt - 1)
            {
                FlxTween.color(dimOverlay, 1, FlxColor.TRANSPARENT, FlxColor.fromRGB(0, 0, 0, 100), {ease: FlxEase.cubeOut});
            }

            currPopup++;
            popups.scale.set(0, 0);
            popups.loadGraphic(getCurrPopupPath());
    
            animatePopup();
        }
    }

    function animatePopup()
    {
        FlxTween.tween(popups.scale, {x: 1, y: 1}, 0.5, 
            {
                ease: FlxEase.cubeInOut, 
                onComplete: (_) -> {
                    canSwitchPopup = true;
                }
            }
        );
    }

    function onTutorialEnd(_):Void
    {
        // TODO: Save tutorial as seen
        close();
    }
}
