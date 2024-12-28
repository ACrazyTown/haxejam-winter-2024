package ui;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.mouse.FlxMouseEvent;
import flixel.FlxSprite;

class FancyButton extends FlxSprite
{
    var mouseWasDownOnBtn:Bool = false;

	public function new(x:Float = 0, y:Float = 0, graphicPath:String, onClick:Null<Void -> Void>)
    {
        super(x, y);
        loadGraphic(graphicPath);
        
        FlxMouseEvent.add(
            this,
            (btn:FlxSprite) -> { // down
                mouseWasDownOnBtn = true;

                FlxTween.tween(btn, {"scale.x": 0.85, "scale.y": 0.85}, 0.25, {ease: FlxEase.cubeOut});
            },
            (btn:FlxSprite) -> { // up
                if (mouseWasDownOnBtn)
                {
                    onClick();
                }

                FlxTween.tween(btn, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
            },
            (btn:FlxSprite) -> { // over
                Mouse.setState(CLICKABLE);

                FlxTween.angle(btn, 0, -10, 0.25, {ease: FlxEase.cubeOut});
                FlxTween.tween(btn, {"scale.x": 1.2, "scale.y": 1.2}, 0.25, {ease: FlxEase.cubeOut});
            },
            (btn:FlxSprite) -> { // out
                Mouse.setState(NORMAL);
                mouseWasDownOnBtn = false;

                FlxTween.angle(btn, -10, 0, 0.25, {ease: FlxEase.cubeOut});
                FlxTween.tween(btn, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
            }
        );
    }
}
