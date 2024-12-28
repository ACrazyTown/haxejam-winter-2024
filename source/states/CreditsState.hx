package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class CreditsState extends FlxState
{
    var stubText:FlxText;
    var creditsText:FlxText;

    override public function create()
    {
        stubText = new FlxText(0, 0, 0, "Credits", 80);
        stubText.font = "Overlock Black";
        stubText.screenCenter();
        stubText.y = 60;
        add(stubText);

        creditsText = new FlxText(0, 0, 0, "--- Sound Effects ---
es-stamp.wav by eddies2000 -- https://freesound.org/s/448474/ -- License: Creative Commons 0
Paper.wav by stijn -- https://freesound.org/s/43672/ -- License: Creative Commons 0
Conveyor belt by freemaster2 -- https://freesound.org/s/172350/ -- License: Attribution 4.0
trash_fall.wav by philberts -- https://freesound.org/s/71512/ -- License: Creative Commons 0
Cinematic Boom by Rizzard -- https://freesound.org/s/559529/ -- License: Creative Commons 0
Old Church Bell.wav by dsp9000 -- https://freesound.org/s/76405/ -- License: Creative Commons 0

--- Fonts ---

Overlock -- https://fonts.google.com/specimen/Overlock", 25);
        creditsText.font = "Overlock Regular";
        creditsText.screenCenter();
        creditsText.y += 60;
        add(creditsText);

        super.create();
    }

    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(MenuState.new);
        }

        super.update(elapsed);
    }
}
