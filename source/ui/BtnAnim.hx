package ui;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;

class BtnAnim
{
    public static function onMouseDown(animButton:FlxSprite)
    {
        FlxTween.tween(animButton, {"scale.x": 0.85, "scale.y": 0.85}, 0.25, {ease: FlxEase.cubeOut});
    }

    public static function onMouseUp(animButton:FlxSprite)
    {
        FlxTween.tween(animButton, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
    }

    public static function onMouseOver(animButton:FlxSprite)
    {
        FlxTween.angle(animButton, 0, -10, 0.25, {ease: FlxEase.cubeOut});
        FlxTween.tween(animButton, {"scale.x": 1.2, "scale.y": 1.2}, 0.25, {ease: FlxEase.cubeOut});
    }

    public static function onMouseOut(animButton:FlxSprite)
    {
        FlxTween.angle(animButton, -10, 0, 0.25, {ease: FlxEase.cubeOut});
        FlxTween.tween(animButton, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
    }
}
