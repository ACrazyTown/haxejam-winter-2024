package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;
import states.MenuState;
import states.Startup;
import states.PlayState;

class Main extends Sprite
{
    public static var initialState:Class<FlxState> = #if PLAY PlayState #else MenuState #end;

    public function new()
    {
        super();
        addChild(new FlxGame(0, 0, Startup));
    }
}
