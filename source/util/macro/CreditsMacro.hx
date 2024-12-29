package util.macro;

import haxe.io.Bytes;
#if macro
import sys.io.File;
#end
import haxe.macro.Expr.ExprOf;

using StringTools;

class CreditsMacro
{
    public static macro function getCreditsText():ExprOf<Array<String>>
    {
        // Sorry.
        var credits:String = File.getContent("./CREDITS.md").trim();
        var splitCredits = credits.split("\n");
        var toReturn = [];
        for (c in splitCredits)
        {
            var trimmed = c.trim();
            if (trimmed.length != 0)
                toReturn.push(c.trim());
        }
        return macro $v{toReturn};
    }
}
