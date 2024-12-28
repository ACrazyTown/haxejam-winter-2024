package game;

import util.macro.AbstractEnumTools;
import props.fish.FishData;
import props.fish.FishKind;
import props.fish.FishLocation;

typedef ChecklistFunction = FishData->Bool;
typedef ChecklistQuestion =
{
    title:String,
    titleOpposite:String,
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

    inline public static final ALL_CORRECT_CHANCE:Float = 50;

    public static final FISH_KINDS:Array<String> = AbstractEnumTools.getValues(FishKind);
    public static final FISH_LOCATIONS:Array<String> = AbstractEnumTools.getValues(FishLocation);
    
    public static var QUESTIONS_COLOR:Array<ChecklistQuestion> = 
    [
        {
            title: "Is the fish green?",
            titleOpposite: "Is the fish not green?",
            func: ChecklistQuestions.isGreen
        },
        {
            title: "Is the fish blue?",
            titleOpposite: "Is the fish not blue?",
            func: ChecklistQuestions.isBlue
        },
        {
            title: "Is the fish red?",
            titleOpposite: "Is the fish not red?",
            func: ChecklistQuestions.isRed
        },
        {
            title: "Is the fish yellow?",
            titleOpposite: "Is the fish not yellow?",
            func: ChecklistQuestions.isYellow
        },
        {
            title: "Is the fish cyan?",
            titleOpposite: "Is the fish not cyan?",
            func: ChecklistQuestions.isCyan
        },
        {
            title: "Is the fish magenta?",
            titleOpposite: "Is the fish not magenta?",
            func: ChecklistQuestions.isMagenta
        }
    ];

    public static var QUESTIONS_KIND:Array<ChecklistQuestion> = null;

    public static var QUESTIONS_LOCATION:Array<ChecklistQuestion> =
    [
        {
            title: "Is the fish from Findfish Lake?",
            titleOpposite: "Is the fish not from Findfish Lake?",
            func: ChecklistQuestions.isFromFindfishLake
        },
        {
            title: "Is the fish from the Salmon Seas?",
            titleOpposite: "Is the fish not from the Salmon Seas?",
            func: ChecklistQuestions.isFromSalmonSea,
        },
        {
            title: "Is the fish from the Catfish Canal?",
            titleOpposite: "Is the fish not from the Catfish Canal?",
            func: ChecklistQuestions.isFromCatfishCanal
        },
        {
            title: "Is the fish from the Underlake?",
            titleOpposite: "Is te fish not from the Underlake?",
            func: ChecklistQuestions.isFromUnderlake
        },
        {
            title: "Is the fish from a nuclear wasteland?",
            titleOpposite: "Is the fish not from a nuclear wasteland?",
            func: ChecklistQuestions.isFromNuclearWasteland
        },
        {
            title: "Is the fish from the Haks Harbor?",
            titleOpposite: "Is the fish not from the Haks Harbor?",
            func: ChecklistQuestions.isFromHaksHarbor
        },
        {
            title: "Is the fish from the Fliksel Fjords?",
            titleOpposite: "Is the fish not from the Fliksel Fjords?",
            func: ChecklistQuestions.isFromFlikselFjord
        }
    ];
}
