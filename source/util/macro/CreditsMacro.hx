package util.macro;

#if macro
import sys.io.File;
#end
import haxe.macro.Expr.ExprOf;

using StringTools;

class CreditsMacro
{
    public static macro function getCreditsText():ExprOf<String>
    {
        var credits:String = File.getContent("./CREDITS.md");
        credits = credits.split("\n").join("");
        return macro $v{credits};
    }
}
