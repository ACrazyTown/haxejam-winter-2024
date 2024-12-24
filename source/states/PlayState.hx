package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import props.Fish;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.mouse.visible = true;

		var concept:FlxSprite = new FlxSprite(0, 0).loadGraphic("assets/images/deskconcept.png");
		add(concept);

		var fish:Fish = new Fish(0, 0);
		add(fish);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
