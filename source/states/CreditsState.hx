package states;

import ui.Mouse;
import ui.FancyButton;
// import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class CreditsState extends FlxState
{
    var titleText:FlxText;
    var creditsText:FlxText;

    var closeBtn:FancyButton;

    override public function create()
    {
        titleText = new FlxText(0, 0, 0, "Credits", 70);
        titleText.font = "Overlock Black";
        titleText.screenCenter();
        titleText.y = 40;
        add(titleText);

        creditsText = new FlxText(0, 0, 0, "Game made by .............. idiots s s sssssssss
        
--- Sound Effects ---
es-stamp.wav by eddies2000 -- https://freesound.org/s/448474/ -- License: Creative Commons 0
Paper.wav by stijn -- https://freesound.org/s/43672/ -- License: Creative Commons 0
Conveyor belt by freemaster2 -- https://freesound.org/s/172350/ -- License: Attribution 4.0
trash_fall.wav by philberts -- https://freesound.org/s/71512/ -- License: Creative Commons 0
Cinematic Boom by Rizzard -- https://freesound.org/s/559529/ -- License: Creative Commons 0
Old Church Bell.wav by dsp9000 -- https://freesound.org/s/76405/ -- License: Creative Commons 0
Explosion and Rubble/Debris by deleted_user_1887925 -- https://freesound.org/s/132929/ -- License: Creative Commons 0
Sparkler.aif by Ned Bouhalassa -- https://freesound.org/s/8320/ -- License: Creative Commons 0
phone short buzz by richwise -- https://freesound.org/s/476836/ -- License: Creative Commons 0

--- Fonts ---
Overlock -- https://fonts.google.com/specimen/Overlock -- Copyright (c) 2011, Dario Manuel Muhafara -- SIL Open Font License", 25);
        creditsText.font = "Overlock Regular";
        creditsText.screenCenter();
        creditsText.y += 60;
        add(creditsText);

        closeBtn = new FancyButton(10, 10, "assets/images/ui/arrow.png", () -> {
            Mouse.setState(NORMAL);
            FlxG.switchState(MenuState.new);
        });
        add(closeBtn);

        super.create();
    }

    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE)
        {
            Mouse.setState(NORMAL);
            FlxG.switchState(MenuState.new);
        }

        super.update(elapsed);
    }
}
