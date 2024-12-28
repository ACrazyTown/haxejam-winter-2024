package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class SettingsState extends FlxState
{
    var stubText:FlxText;

    override public function create()
    {
        stubText = new FlxText(0, 0, 0, "Settings State", 20);
        stubText.screenCenter();
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
