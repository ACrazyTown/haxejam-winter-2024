package props.fish;

import haxe.CallStack.StackItem;

enum abstract FishKind(String) from String to String
{
    var FLOPPER = "flopper";
    var NORMAL = "normal";
    var SALMON = "salmon";
    var CHILL = "chill";
    var DAPPER = "dapper";
    var BIG = "big";
    var SMALL = "small";
    var CAT = "catfish";
    var DOG = "dogfish";
    var PUFFER = "pufferfish";
    var CARDBOARD = "cardboard";

    inline public function formatted():String
    {
        return switch (this)
        {
            case NORMAL: "Regular old boring fish";
            case DOG: "Dog...? fish????";
            case BIG: "BIGFISH";
            case SMALL: "smallfish";
            case DAPPER: "Dapperfish";
            case CHILL: "Chillfish";
            case CARDBOARD: "Fish...?";
            default: this.charAt(0).toUpperCase() + this.substr(1, this.length);
        }
    }
}
