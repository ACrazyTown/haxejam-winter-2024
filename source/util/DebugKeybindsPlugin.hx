package util;

import flixel.FlxG;
import flixel.FlxBasic;

class DebugKeybindsPlugin extends FlxBasic
{
    static var instance:DebugKeybindsPlugin;
    public static function init():Void
    {
        instance = new DebugKeybindsPlugin();
        FlxG.plugins.addIfUniqueType(instance);

        // FlxG.stage.application.onExit.add(() -> )
        // FlxG.plugins.remove(instance);
    }

    public function new()
    {
        super();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.F5)
        {
            FlxG.resetState();
        }
    }
}
