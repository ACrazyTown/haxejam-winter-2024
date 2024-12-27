package states;

import ui.Mouse;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEvent;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MenuState extends FlxState
{
    var playButton:FlxSprite;
    var mouseWasDownOnPlayBtn:Bool = false;
    var bg:FlxSprite;
    var fg:FlxSprite;
    var swipe:FlxSprite;

    override public function create()
    {
        super.create();

        bg = new FlxSprite(0, 0);
        bg.loadGraphic("assets/images/ui/menu_bg.png");
        add(bg);

        fg = new FlxSprite(-1280, 0);
        fg.loadGraphic("assets/images/ui/menu_fg.png");
        add(fg);

        playButton = new FlxSprite(1280, 400);
        playButton.loadGraphic("assets/images/ui/play_btn.png");
        add(playButton);

        FlxMouseEvent.add(playButton, playBtnOnMouseDown, playBtnOnMouseUp, playBtnOnMouseOver, playBtnOnMouseOut);

        swipe = new FlxSprite(1280, 0);
        swipe.loadGraphic("assets/images/ui/start_screen_swipe.png");
        add(swipe);

        FlxTween.tween(fg, {x: 0}, 1, {ease: FlxEase.cubeOut});
        FlxTween.tween(playButton, {x: 650}, 1, {ease: FlxEase.cubeOut});
    }

    function playBtnOnMouseDown(playButton:FlxSprite)
    {
        mouseWasDownOnPlayBtn = true;
		FlxTween.tween(playButton, {"scale.x": 0.85, "scale.y": 0.85}, 0.25, {ease: FlxEase.cubeOut});
    }

    function playBtnOnMouseUp(playButton:FlxSprite)
    {
        if (mouseWasDownOnPlayBtn)
        {
			FlxTween.tween(swipe, {x: -520}, 1, {
				ease: FlxEase.cubeOut,
				onComplete:
                (_) -> FlxG.switchState(PlayState.new)
            });
        }
		FlxTween.tween(playButton, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
    }

    function playBtnOnMouseOver(playButton:FlxSprite)
    {
        Mouse.setState(CLICKABLE);
        FlxTween.angle(playButton, 0, -10, 0.25, {ease: FlxEase.cubeOut});
        FlxTween.tween(playButton, {"scale.x": 1.2, "scale.y": 1.2}, 0.25, {ease: FlxEase.cubeOut});
    }

    function playBtnOnMouseOut(playButton:FlxSprite)
    {
        Mouse.setState(NORMAL);
        mouseWasDownOnPlayBtn = false;
        FlxTween.angle(playButton, -10, 0, 0.25, {ease: FlxEase.cubeOut});
        FlxTween.tween(playButton, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
    }
}
