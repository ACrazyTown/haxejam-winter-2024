package props.fish;

import game.Constants;
import flixel.FlxG;
import flixel.util.FlxColor;

class FishData
{
    public static function random():FishData
    {
        // TODO: Change when proper fish assets are in
        var color = FlxColor.fromHSB(0, 0.65, 0.84);
        color.hue = FlxG.random.int(0, 359);

        var kind = FlxG.random.getObject(Constants.FISH_KINDS);
        var decoration = FlxG.random.getObject(Constants.FISH_DECORATIONS);
        var location = FlxG.random.getObject(Constants.FISH_LOCATIONS);
        var age = FlxG.random.int(1, 1000);
        // TODO
        var legal = true;
        var poisonous = location == FishLocation.NUCLEAR_WASTELAND;
        var evil = FlxG.random.bool(5);
        var bomb = FlxG.random.bool(15);

        var data = new FishData(color, kind, decoration, location, age, legal, poisonous, evil, bomb);
        return data;
    }

    public var color:FlxColor;
    public var kind:FishKind;
    public var decoration:FishDecoration;
    public var location:FishLocation;
    public var age:Int;
    public var legal:Bool;
    public var poisonous:Bool;
    public var evil:Bool;
    public var bomb:Bool;

    public function new(color:FlxColor, kind:FishKind, decoration:FishDecoration, 
        location:FishLocation, age:Int, legal:Bool, poisonous:Bool, evil:Bool, bomb:Bool)
    {
        this.color = color;
        this.kind = kind;
        this.decoration = decoration;
        this.location = location;
        this.age = age;
        this.legal = legal;
        this.poisonous = poisonous;
        this.evil = evil;
        this.bomb = bomb;
    }

    public function toString():String
    {
        return 'color: ${color.toWebString()} | kind: ${kind} | deco: ${decoration} | loc: ${location} | age: ${age} | legal: ${legal} | pois: ${poisonous} | evil: ${evil}';
    }
}
