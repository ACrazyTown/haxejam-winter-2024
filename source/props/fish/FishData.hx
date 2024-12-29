package props.fish;

import game.Constants;
import flixel.FlxG;
import flixel.util.FlxColor;

class FishData
{
    public static function random():FishData
    {
        var kind = FlxG.random.getObject(Constants.FISH_KINDS);
        var location = FlxG.random.getObject(Constants.FISH_LOCATIONS);
        var age = FlxG.random.int(1, 1000);
        // TODO
        var legal = true;
        if (location == FishLocation.FINDFISH_LAKE && age < 365)
            legal = false;

        var poisonous = location == FishLocation.NUCLEAR_WASTELAND || kind == FishKind.PUFFER;
        var evil = FlxG.random.bool(5);
        var bomb = FlxG.random.bool(15);

        var color:Null<FlxColor> = null;
        if (kind != FishKind.SALMON && kind != FishKind.CARDBOARD && !bomb)
        {
            color = FlxColor.fromHSB(0, 0.65, 0.84);
            color.hue = FlxG.random.int(0, 359);
        }

        var data = new FishData(color, kind, location, age, legal, poisonous, evil, bomb);
        return data;
    }

    public var color:Null<FlxColor>;
    public var kind:FishKind;
    public var location:FishLocation;
    public var age:Int;
    public var legal:Bool;
    public var poisonous:Bool;
    public var evil:Bool;
    public var bomb:Bool;

    public function new(color:Null<FlxColor>, kind:FishKind, location:FishLocation, 
        age:Int, legal:Bool, poisonous:Bool, evil:Bool, bomb:Bool)
    {
        this.color = color;
        this.kind = kind;
        this.location = location;
        this.age = age;
        this.legal = legal;
        this.poisonous = poisonous;
        this.evil = evil;
        this.bomb = bomb;
    }

    public function toString():String
    {
        return 'color: ${color?.toWebString()} | kind: ${kind} | loc: ${location} | age: ${age} | legal: ${legal} | pois: ${poisonous} | evil: ${evil} | bomb: ${bomb}';
    }
}
