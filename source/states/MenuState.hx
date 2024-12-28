package states;

import ui.FancyButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MenuState extends FlxState
{
    var playButtonNew:FancyButton;
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

        playButtonNew = new FancyButton(1280, 400, "assets/images/ui/play_btn.png", () -> {
            FlxTween.tween(swipe, {x: -520}, 1, {
                ease: FlxEase.cubeOut,
                onComplete:
                (_) -> FlxG.switchState(PlayState.new)
            });
        });
        add(playButtonNew);

        settingsButton = new FancyButton(20, 520, "assets/images/ui/settings_btn.png", () -> {
            // ...
        });
        add(settingsButton);

        creditsButton = new FancyButton(200, 520, "assets/images/ui/credits_btn.png", () -> {
            // ...
        });
        add(creditsButton);

        swipe = new FlxSprite(1280, 0);
        swipe.loadGraphic("assets/images/ui/start_screen_swipe.png");
        add(swipe);

        FlxTween.tween(fg, {x: 0}, 1, {ease: FlxEase.cubeOut});
        FlxTween.tween(playButtonNew, {x: 650}, 1, {ease: FlxEase.cubeOut});
    }
}
