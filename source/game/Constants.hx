package game;

import util.macro.AbstractEnumTools;
import props.fish.FishData;
import props.fish.FishKind;
import props.fish.FishLocation;

typedef ChecklistFunction = FishData->Bool;
typedef ChecklistQuestion =
{
    title:String,
    func:ChecklistFunction,
    ?mustReturn:Null<Bool>
}

class Constants
{
    inline public static final MAX_PENALTIES:Int = 3;

    inline public static final TIME_MAX_DANGER:Int = 10;
    inline public static final TIME_MIN:Int = 120;
    inline public static final TIME_MAX:Int = 240;

    inline public static final SCORE_BASE:Int = 50;
    inline public static final SCORE_PENALTY:Int = -100;
    inline public static final SCORE_MAX_BONUS:Int = 200;

    public static final FISH_KINDS:Array<String> = AbstractEnumTools.getValues(FishKind);
    public static final FISH_LOCATIONS:Array<String> = AbstractEnumTools.getValues(FishLocation);
    
    public static var QUESTIONS_COLOR:Array<ChecklistQuestion> = 
    [
        {
            title: "Is the fish green?",
            func: (data:FishData) ->
            {
                return data.color.hue >= 81 && data.color.hue <= 140;
            }
        },
        {
            title: "Is the fish blue?",
            func: (data:FishData) ->
            {
                return data.color.hue >= 200 && data.color.hue <= 245;
            }
        },
        {
            title: "Is the fish red?",
            func: (data:FishData) ->
            {
                return data.color.hue >= 355 || data.color.hue <= 10;
            }
        }
    ];

    public static var QUESTIONS_KIND:Array<ChecklistQuestion> = null;
}
