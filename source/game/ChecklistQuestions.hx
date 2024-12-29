package game;

import props.fish.Fish;
import props.fish.FishData;
import props.fish.FishLocation;

class ChecklistQuestions 
{
    // -------------------------- COLORS --------------------------
    // If this is wrong I blame this site
    // https://hackmd.io/@Markdown-It/HkHPqV2sX#1690-Colors-Chart-with-names-331-355%C2%B0

    public static function isRed(data:FishData):Bool
    {
        return data.color.hue >= 355 || data.color.hue <= 10;
    }

    public static function isGreen(data:FishData):Bool
    {
        return data.color.hue >= 81 && data.color.hue <= 140;
    }

    public static function isYellow(data:FishData):Bool
    {
        return data.color.hue >= 51 && data.color.hue <= 60;
    }

    public static function isBlue(data:FishData):Bool
    {
        // return data.color.hue >= 200 && data.color.hue <= 245;
        return data.color.hue >= 221 && data.color.hue <= 240;
    }

    public static function isCyan(data:FishData):Bool
    {
        return data.color.hue >= 170 && data.color.hue <= 200;
    }

    public static function isMagenta(data:FishData):Bool
    {
        return data.color.hue >= 281 && data.color.hue <= 320;
    }

    // --------------------------gsgsdggsd--------------------------

    public static function isPoisonous(data:FishData):Bool
    {
        return data.poisonous;
    }
    
    public static function wasLegallyCaught(data:FishData):Bool
    {
        return data.legal;
    }

    public static function hasDecoration(data:FishData):Bool
    {
        return data.kind == DAPPER || data.kind == CHILL;
    }

    public static function hasHat(data:FishData):Bool
    {
        return data.kind == DAPPER;
    }

    public static function isOverAYearOld(data:FishData):Bool
    {
        return data.age > 365;
    }

    public static function isFromFindfishLake(data:FishData):Bool
    {
        return data.location == FINDFISH_LAKE;
    }

    public static function isFromUnderlake(data:FishData):Bool
    {
        return data.location == UNDERLAKE;
    }

    public static function isFromSalmonSea(data:FishData):Bool
    {
        return data.location == SALMON_SEA;
    }

    public static function isFromCatfishCanal(data:FishData):Bool
    {
        return data.location == CATFISH_CANAL;
    }

    public static function isFromNuclearWasteland(data:FishData):Bool
    {
        return data.location == NUCLEAR_WASTELAND;
    }

    public static function isFromHaksHarbor(data:FishData):Bool
    {
        return data.location == HAKS_HARBOR;
    }

    public static function isFromFlikselFjord(data:FishData):Bool
    {
        return data.location == FLIKSEL_FJORD;
    }

    public static function meows(data:FishData):Bool
    {
        return data.kind == CAT;
    }

    public static function isSaltwater(data:FishData):Bool
    {
        return data.saltwater;
    }

    public static function barks(data:FishData):Bool
    {
        return data.kind == DOG;
    }

    public static function isFlopper(data:FishData):Bool
    {
        return data.kind == FLOPPER;
    }

    public static function isNormal(data:FishData):Bool
    {
        return data.kind == NORMAL;
    }

    public static function isSalmon(data:FishData):Bool
    {
        return data.kind == SALMON;
    }

    public static function isChill(data:FishData):Bool
    {
        return data.kind == CHILL;
    }

    public static function isDapper(data:FishData):Bool
    {
        return data.kind == DAPPER;
    }

    public static function isBigKind(data:FishData):Bool
    {
        return data.kind == BIG;
    }

    public static function isSmallKind(data:FishData):Bool
    {
        return data.kind == SMALL;
    }

    public static function isCatfish(data:FishData):Bool
    {
        return data.kind == CAT;
    }

    public static function isDogfish(data:FishData):Bool
    {
        return data.kind == DOG;
    }

    public static function isPufferfish(data:FishData):Bool
    {
        return data.kind == PUFFER;
    }

    public static function isCardboard(data:FishData):Bool
    {
        return data.kind == CARDBOARD;
    }

    public static function isEdible(data:FishData):Bool
    {
        return data.kind != CARDBOARD;
    }

    public static function isOver10YearsOld(data:FishData):Bool
    {
        return data.age > 3650;
    }
}
