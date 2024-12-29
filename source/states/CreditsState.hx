package states;

import util.macro.CreditsMacro;
import ui.Mouse;
import ui.FancyButton;
// import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class CreditsState extends FlxState
{
    var titleText:FlxText;
    var creditsText:FlxText;

    var closeBtn:FancyButton;

    override public function create()
    {
        titleText = new FlxText(0, 0, 0, "Credits", 70);
        titleText.font = "Overlock Black";
        titleText.screenCenter();
        titleText.y = 40;
        add(titleText);

        creditsText = new FlxText(0, 0, 0, "", 20);
        creditsText.fieldWidth = 1000;
        creditsText.font = "Overlock Regular";
        // creditsText.y += 60;
        add(creditsText);

        var creditsData = CreditsMacro.getCreditsText();
        for (i in 0...creditsData.length)
        {
            creditsText.text += creditsData[i];
            if (i != creditsData.length)
                creditsText.text += "\n";
        }

        creditsText.screenCenter();

        closeBtn = new FancyButton(10, 10, "assets/images/ui/arrow_left.png", () -> {
            Mouse.setState(NORMAL);
            FlxG.switchState(MenuState.new);
        });
        add(closeBtn);

        super.create();
    }

    override public function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
        {
            Mouse.setState(NORMAL);
            FlxG.switchState(MenuState.new);
        }
    }
}
