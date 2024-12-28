package states;

import ui.BtnAnim;
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
    var mouseWasDownOnBtn:Map<String, Bool> = ["play" => false, "credits" => false, "settings" => false];
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

        swipe = new FlxSprite(1280, 0);
        swipe.loadGraphic("assets/images/ui/start_screen_swipe.png");
        add(swipe);

        FlxMouseEvent.add(
            playButton,
            (pb:FlxSprite) -> { // down
                mouseWasDownOnBtn.set("play", true);
                BtnAnim.onMouseDown(pb);
            },
            (pb:FlxSprite) -> { // up
                if (mouseWasDownOnBtn.get("play"))
                {
                    FlxTween.tween(swipe, {x: -520}, 1, {
                        ease: FlxEase.cubeOut,
                        onComplete:
                        (_) -> FlxG.switchState(PlayState.new)
                    });
                }
                BtnAnim.onMouseUp(pb);
            },
            (pb:FlxSprite) -> { // over
                Mouse.setState(CLICKABLE);
                BtnAnim.onMouseOver(pb);
            },
            (pb:FlxSprite) -> { // out
                Mouse.setState(NORMAL);
                mouseWasDownOnBtn.set("play", false);
                BtnAnim.onMouseOut(pb);
            }
        );

        FlxTween.tween(fg, {x: 0}, 1, {ease: FlxEase.cubeOut});
        FlxTween.tween(playButton, {x: 650}, 1, {ease: FlxEase.cubeOut});
    }
}
