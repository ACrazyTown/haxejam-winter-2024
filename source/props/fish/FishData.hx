package props.fish;

import flixel.util.FlxColor;

class FishData
{
    public var color:FlxColor;
    public var kind:FishKind;
    public var decoration:FishDecoration;
    public var location:FishLocation;
    public var legal:Bool;
    public var poisonous:Bool;
    public var evil:Bool;

    public function new(color:FlxColor, kind:FishKind, decoration:FishDecoration, 
        location:FishLocation, legal:Bool, poisonous:Bool, evil:Bool)
    {
        this.color = color;
        this.kind = kind;
        this.decoration = decoration;
        this.location = location;
        this.legal = legal;
        this.poisonous = poisonous;
        this.evil = evil;
    }
}
