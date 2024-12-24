package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;
import states.MenuState;
import states.Startup;

class Main extends Sprite
{
    public static var initialState:Class<FlxState> = MenuState;

    public function new()
    {
        super();
        addChild(new FlxGame(0, 0, Startup));
    }
}
