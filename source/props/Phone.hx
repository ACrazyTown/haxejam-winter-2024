package props;

import flixel.util.FlxAxes;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteContainer;
import flixel.FlxG;
import flixel.FlxSprite;

class Phone extends FlxSpriteContainer
{
	var shell:FlxSprite;
	var screen:FlxSprite;

    var sndBeep:FlxSound;
    var sndBuzz:FlxSound;
    var sndHappy:FlxSound;
    var sndMad:FlxSound;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
        
        screen = new FlxSprite(3, 47, "assets/images/phone3.png");
        screen.scale = FlxPoint.weak(0.5, 0.5);
        screen.angle = -7;
        add(screen);

        shell = new FlxSprite(0, 0, "assets/images/phone.png");
        add(shell);

        sndBeep = FlxG.sound.load("assets/sounds/sqr_beep");
        sndBeep.volume = 0.6;
        sndBuzz = FlxG.sound.load("assets/sounds/phone_buzz");
        sndHappy = FlxG.sound.load("assets/sounds/phone-happy");
        sndMad = FlxG.sound.load("assets/sounds/phone-mad");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

    public function doHappy()
    {
        screen.loadGraphic("assets/images/phone0.png");
        sndBeep.play();
        sndBuzz.play();
        FlxTween.shake(this, 0.01, 0.5, FlxAxes.X);
        new FlxTimer().start(1.5, (_) -> {
            sndHappy.play();
            screen.loadGraphic("assets/images/phone1.png");
        });
        new FlxTimer().start(4, (_) -> {
            screen.loadGraphic("assets/images/phone4.png");
        });
        new FlxTimer().start(7, (_) -> {
            screen.loadGraphic("assets/images/phone3.png");
        });
    }

    public function doMad()
    {
        screen.loadGraphic("assets/images/phone0.png");
        sndBeep.play();
        sndBuzz.play();
        FlxTween.shake(this, 0.01, 0.5, FlxAxes.X);
        new FlxTimer().start(1.5, (_) -> {
            sndMad.play();
            screen.loadGraphic("assets/images/phone2.png");
        });
        new FlxTimer().start(4, (_) -> {
            screen.loadGraphic("assets/images/phone5.png");
        });
        new FlxTimer().start(7, (_) -> {
            screen.loadGraphic("assets/images/phone3.png");
        });
    }
}
