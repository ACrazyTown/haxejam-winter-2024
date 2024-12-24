package;

import flixel.FlxState;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.Startup;
import states.PlayState;

class Main extends Sprite
{
	public static var initialState:Class<FlxState> = PlayState;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, Startup));
	}
}
