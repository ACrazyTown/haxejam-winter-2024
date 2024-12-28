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
    var settingsButton:FlxSprite;
    var creditsButton:FlxSprite;

    var mouseWasDownOnBtn:Map<String, Bool> = ["play" => false, "settings" => false, "credits" => false];

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

        settingsButton = new FlxSprite(20, 520);
        settingsButton.loadGraphic("assets/images/ui/settings_btn.png");
        add(settingsButton);

        creditsButton = new FlxSprite(200, 520);
        creditsButton.loadGraphic("assets/images/ui/credits_btn.png");
        add(creditsButton);

        swipe = new FlxSprite(1280, 0);
        swipe.loadGraphic("assets/images/ui/start_screen_swipe.png");
        add(swipe);

        FlxMouseEvent.add( // play
            playButton,
            (btn:FlxSprite) -> { // down
                mouseWasDownOnBtn.set("play", true);
                BtnAnim.onMouseDown(btn);
            },
            (btn:FlxSprite) -> { // up
                if (mouseWasDownOnBtn.get("play"))
                {
                    FlxTween.tween(swipe, {x: -520}, 1, {
                        ease: FlxEase.cubeOut,
                        onComplete:
                        (_) -> FlxG.switchState(PlayState.new)
                    });
                }
                BtnAnim.onMouseUp(btn);
            },
            (btn:FlxSprite) -> { // over
                Mouse.setState(CLICKABLE);
                BtnAnim.onMouseOver(btn);
            },
            (btn:FlxSprite) -> { // out
                Mouse.setState(NORMAL);
                mouseWasDownOnBtn.set("play", false);
                BtnAnim.onMouseOut(btn);
            }
        );

        FlxMouseEvent.add( // settings
            settingsButton,
            (btn:FlxSprite) -> { // down
                mouseWasDownOnBtn.set("settings", true);
                BtnAnim.onMouseDown(btn);
            },
            (btn:FlxSprite) -> { // up
                if (mouseWasDownOnBtn.get("settings"))
                {
                    trace("settings pressed");
                }
                BtnAnim.onMouseUp(btn);
            },
            (btn:FlxSprite) -> { // over
                Mouse.setState(CLICKABLE);
                BtnAnim.onMouseOver(btn);
            },
            (btn:FlxSprite) -> { // out
                Mouse.setState(NORMAL);
                mouseWasDownOnBtn.set("settings", false);
                BtnAnim.onMouseOut(btn);
            }
        );

        FlxMouseEvent.add( // credits
            creditsButton,
            (btn:FlxSprite) -> { // down
                mouseWasDownOnBtn.set("credits", true);
                BtnAnim.onMouseDown(btn);
            },
            (btn:FlxSprite) -> { // up
                if (mouseWasDownOnBtn.get("credits"))
                {
                    trace("credits pressed");
                }
                BtnAnim.onMouseUp(btn);
            },
            (btn:FlxSprite) -> { // over
                Mouse.setState(CLICKABLE);
                BtnAnim.onMouseOver(btn);
            },
            (btn:FlxSprite) -> { // out
                Mouse.setState(NORMAL);
                mouseWasDownOnBtn.set("credits", false);
                BtnAnim.onMouseOut(btn);
            }
        );

        FlxTween.tween(fg, {x: 0}, 1, {ease: FlxEase.cubeOut});
        FlxTween.tween(playButton, {x: 650}, 1, {ease: FlxEase.cubeOut});
    }
}
