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

        btn_mouseEventSetup(playButton, "play", () -> {
            FlxTween.tween(swipe, {x: -520}, 1, {
                ease: FlxEase.cubeOut,
                onComplete:
                (_) -> FlxG.switchState(PlayState.new)
            });
        });
        
        btn_mouseEventSetup(settingsButton, "settings", () -> {
            trace("settings clicked (newer)");
        });
        
        btn_mouseEventSetup(creditsButton, "credits", () -> {
            trace("credits clicked (newer)");
        });

        FlxTween.tween(fg, {x: 0}, 1, {ease: FlxEase.cubeOut});
        FlxTween.tween(playButton, {x: 650}, 1, {ease: FlxEase.cubeOut});
    }

    function btn_mouseEventSetup(button:FlxSprite, btnName:String, onClick:Null<Void -> Void>)
    {
        FlxMouseEvent.add(
            button,
            (btn:FlxSprite) -> { // down
                mouseWasDownOnBtn.set(btnName, true);

                FlxTween.tween(btn, {"scale.x": 0.85, "scale.y": 0.85}, 0.25, {ease: FlxEase.cubeOut});
            },
            (btn:FlxSprite) -> { // up
                if (mouseWasDownOnBtn.get(btnName))
                {
                    onClick();
                }

                FlxTween.tween(btn, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
            },
            (btn:FlxSprite) -> { // over
                Mouse.setState(CLICKABLE);

                FlxTween.angle(btn, 0, -10, 0.25, {ease: FlxEase.cubeOut});
                FlxTween.tween(btn, {"scale.x": 1.2, "scale.y": 1.2}, 0.25, {ease: FlxEase.cubeOut});
            },
            (btn:FlxSprite) -> { // out
                Mouse.setState(NORMAL);
                mouseWasDownOnBtn.set(btnName, false);

                FlxTween.angle(btn, -10, 0, 0.25, {ease: FlxEase.cubeOut});
                FlxTween.tween(btn, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
            }
        );
    }
}
