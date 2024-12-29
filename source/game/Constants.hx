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
    inline public static final EZ_MODE_CHANCE:Float = 10;

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

    public static var QUESTIONS_KIND:Array<ChecklistQuestion> = 
    [
        {
            title: "Is the fish a Flopper?",
            titleOpposite: "Is the fish not a Flopper?",
            func: ChecklistQuestions.isFlopper
        },
        {
            title: "Is the fish normal and boring?",
            titleOpposite: "Is the fish not normal and boring?",
            func: ChecklistQuestions.isNormal
        },
        {
            title: "Is the fish a salmon?",
            titleOpposite: "Is the fish not a salmon?",
            func: ChecklistQuestions.isSalmon
        },
        {
            title: "Is the fish chill like dat?",
            titleOpposite: "Is the fish not chill like dat?",
            func: ChecklistQuestions.isChill
        },
        {
            title: "Is the fish a BIG fish?",
            titleOpposite: "Is fish not a BIG fish?",
            func: ChecklistQuestions.isBigKind
        },
        {
            title: "Is the fish a small fish?",
            titleOpposite: "Is the fish not a small fish?",
            func: ChecklistQuestions.isSmallKind
        },
        {
            title: "Is the fish a catfish?",
            titleOpposite: "Is the fish not a catfish?",
            func: ChecklistQuestions.isCatfish
        },
        {
            title: "Is the fish a dogfish?",
            titleOpposite: "Is the fish not a dogfish?",
            func: ChecklistQuestions.isDogfish
        },
        {
            title: "Is the fish a pufferfish?",
            titleOpposite: "Is the fish not a pufferfish?",
            func: ChecklistQuestions.isPufferfish
        },
        {
            title: "Is the fish made from cardboard?",
            titleOpposite: "Is the fish not made from cardboard?",
            func: ChecklistQuestions.isCardboard
        }
    ];

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

    public static var QUESTIONS_MISC:Array<ChecklistQuestion> =
    [
        {
            title: "Does the fish have a decoration?",
            titleOpposite: "Does the fish not have a decoration?",
            func: ChecklistQuestions.hasDecoration
        },
        {
            title: "Does the fish have a hat?",
            titleOpposite: "Does the fish not have a hat?",
            func: ChecklistQuestions.hasHat
        },
        {
            title: "Was the fish legally caught?",
            titleOpposite: "Was the fish ilegally caught?",
            func: ChecklistQuestions.wasLegallyCaught
        },
        {
            title: "Is the fish poisonous?",
            titleOpposite: "Is the fish not poisonous?",
            func: ChecklistQuestions.isPoisonous
        },
        {
            title: "Does the fish meow?",
            titleOpposite: "Does the fish not meow?",
            func: ChecklistQuestions.meows
        },
        {
            title: "Is a saltwater fish?",
            titleOpposite: "Is it a freshwater fish?",
            func: ChecklistQuestions.isSaltwater
        },
        {
            title: "Does the fish bark?",
            titleOpposite: "Does the fish not bark?",
            func: ChecklistQuestions.barks
        },
        {
            title: "Is the fish edible?",
            titleOpposite: "Is the fish not edible?",
            func: ChecklistQuestions.isEdible
        },
        {
            title: "Is the fish over 10 years old? (no leap years)",
            titleOpposite: "Is the fish not over 10 years old? (no leap years)",
            func: ChecklistQuestions.isOver10YearsOld
        }
    ];
}
