package game;

import props.fish.FishData;

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
}
