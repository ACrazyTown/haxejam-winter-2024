package states;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.mouse.visible = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
