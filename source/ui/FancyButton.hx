package ui;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.mouse.FlxMouseEvent;
import flixel.FlxSprite;

class FancyButton extends FlxSprite
{
    var onClick:Null<Void->Void>;
    var mouseWasDownOnBtn:Bool = false;

	public function new(x:Float = 0, y:Float = 0, graphicPath:String, onClick:Null<Void -> Void>)
    {
        super(x, y);
        this.onClick = onClick;

        loadGraphic(graphicPath);
        
        FlxMouseEvent.add(this, onMouseDown, onMouseUp, onMouseOver, onMouseOut);
    }

    function onMouseDown(btn:FlxSprite):Void
    {
        mouseWasDownOnBtn = true;

        FlxTween.tween(btn.scale, {x: 0.85, y: 0.85}, 0.25, {ease: FlxEase.cubeOut});
    }

    function onMouseUp(btn:FlxSprite):Void
    {
        if (mouseWasDownOnBtn)
        {
            onClick();
        }

        FlxTween.tween(btn.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.cubeOut});
    }

    function onMouseOver(btn:FlxSprite):Void
    {
        Mouse.setState(CLICKABLE);

        FlxTween.angle(btn, 0, -10, 0.25, {ease: FlxEase.cubeOut});
        FlxTween.tween(btn.scale, {x: 1.2, y: 1.2}, 0.25, {ease: FlxEase.cubeOut});
    }

    function onMouseOut(btn:FlxSprite):Void
    {
        Mouse.setState(NORMAL);
        mouseWasDownOnBtn = false;

        FlxTween.angle(btn, -10, 0, 0.25, {ease: FlxEase.cubeOut});
        FlxTween.tween(btn.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.cubeOut});
    }

    override function destroy():Void
    {
        FlxMouseEvent.remove(this);
        FlxTween.cancelTweensOf(this);
        super.destroy();
    }
}
