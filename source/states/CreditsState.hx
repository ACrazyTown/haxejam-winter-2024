package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class CreditsState extends FlxState
{
    var stubText:FlxText;

    override public function create()
    {
        stubText = new FlxText(0, 0, 0, "Credits", 80);
        stubText.font = "Overlock Black";
        stubText.screenCenter();
        stubText.y = 60;
        add(stubText);

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
