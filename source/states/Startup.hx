package states;

import util.DebugKeybindsPlugin;
import ui.Mouse;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

class Startup extends FlxState
{
    var webText:FlxText;

    override function create():Void
    {
        super.create();

        init();

        // Don't automatically switch to the first state
        // on HTML5 as we need to get a user interaction
        // first, otherwise we can't get an audio context
        // and the game will crash
        #if !web
        done();
        #else
        webText = new FlxText(0, 0, 0, "Click to begin", 32);
        webText.screenCenter();
        add(webText);
        #end
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        #if (web && FLX_MOUSE)
        if (FlxG.mouse.justPressed)
        {
            done();
        }
        #end
    }

    function init():Void
    {
        FlxG.fixedTimestep = false;
        FlxSprite.defaultAntialiasing = true;
        FlxG.mouse.visible = true;

        Mouse.setState(NORMAL);

        #if debug
        DebugKeybindsPlugin.init();
        #end
    }

    function done():Void
    {
        FlxG.switchState(() -> Type.createInstance(Main.initialState, []));
    }
}
