package states;

import flixel.util.FlxStringUtil;
import flixel.text.FlxText;
import ui.Mouse;
import flixel.util.typeLimit.NextState;
import ui.FancyButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MenuState extends FlxState
{
    var saveText:FlxText;

    var playButtonNew:FancyButton;
    var creditsButton:FlxSprite;
    var creditsPoint:FlxSprite;

    var bg:FlxSprite;
    var fg:FlxSprite;
    var swipe:FlxSprite;

    override public function create()
    {
        super.create();

        FlxG.camera.bgColor.setRGB(128, 143, 135);

        bg = new FlxSprite(0, 0);
        bg.loadGraphic("assets/images/ui/menu_bg.png");
        add(bg);

        fg = new FlxSprite(-1280, 0);
        fg.loadGraphic("assets/images/ui/menu_fg.png");
        add(fg);

        playButtonNew = new FancyButton(1280, 400, "assets/images/ui/play_btn.png", () -> {
            Mouse.setState(NORMAL);
            swipeStateSwitcher(PlayState.new);
        });
        add(playButtonNew);

        creditsButton = new FancyButton(20, 520, "assets/images/ui/credits_btn.png", () -> {
            Mouse.setState(NORMAL);
            FlxG.openURL("https://github.com/ACrazyTown/haxejam-winter-2024/blob/main/CREDITS.md");
        });
        add(creditsButton);

        creditsPoint = new FlxSprite(115, 445, "assets/images/ui/credits_point.png");
        add(creditsPoint);

        swipe = new FlxSprite(1280, 0);
        swipe.loadGraphic("assets/images/ui/start_screen_swipe.png");
        add(swipe);

        saveText = new FlxText(0, 0, 0, 'Most survived rounds: ${FlxG.save.data.survivedRounds} | Total survived time: ${FlxStringUtil.formatTime(FlxG.save.data.survivedTime)}', 18);
        saveText.font = "Overlock Regular";
        add(saveText);
        
        saveText.x = FlxG.width - saveText.width;
        saveText.y = FlxG.height - saveText.height;

        FlxTween.tween(fg, {x: 0}, 1, {ease: FlxEase.cubeOut});
        FlxTween.tween(playButtonNew, {x: 650}, 1, {ease: FlxEase.cubeOut});
    }

    function swipeStateSwitcher(nextState:NextState)
    {
        FlxTween.tween(swipe, {x: -520}, 1, {
            ease: FlxEase.cubeOut,
            onComplete:
            (_) -> FlxG.switchState(nextState)
        });
    }
}
