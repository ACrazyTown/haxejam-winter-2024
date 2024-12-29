package states.substate;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import ui.FancyButton;
import util.MathUtil;
import props.Document;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;
import props.Document.DocumentType;

class DocumentViewSubstate extends FlxSubState
{
    var overlay:FlxSprite;
    var bg:FlxSprite;
    var type:DocumentType;

    var header:FlxSprite;
    var infoText:FlxText;

    var leftBtn:FancyButton;
    var rightBtn:FancyButton;

    var parent:Document;

    final intro:Array<String> = [
        "Quite a specimen.",
        "Who lives under a pineapple under the sea? Not this fish.",
        "Looks fishy.",
        "My job is to write these info papers. Sorry this text is irrelevant just wanted to say that.",
        "I don't like this one.",
        "I like this one.",
        "Once upon a time there was a fish. This is its info:"
    ];

    public function new(type:DocumentType, parent:Document)
    {
        super();
        this.type = type;
        this.parent = parent;
    }

    override function create():Void
    {
        PlayState.instance.interactionsAllowed = false;
        parent.visible = false;
        var sound = FlxG.sound.play("assets/sounds/paper_grab");
        sound.pitch = MathUtil.eerp(0.9, 1.1);

        overlay = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
        overlay.alpha = 0.5;
        add(overlay);

        bg = new FlxSprite();
        add(bg);

        switch (type)
        {
            case PAPER:
                // TODO: Replace with asset
                bg.makeGraphic(500, 700);
                bg.screenCenter();

                header = new FlxSprite(bg.x + 20, bg.y + 20).loadGraphic("assets/images/ui/fish_info.png");
                add(header);

                if (PlayState.instance.checklistIntroText == null)
                    PlayState.instance.checklistIntroText = FlxG.random.int(0, intro.length - 1);

                var fd = PlayState.instance.curFish.data;
                var text = intro[PlayState.instance.checklistIntroText] + "\n\n";
                text += 'It is a ${fd.kind.formatted()} originating from the ${fd.location}.\n';
                text += 'Estimated to be around ${fd.age} days old.';

                infoText = new FlxText(header.x, header.y + header.height, bg.width - 40, text, 24);
                infoText.font = "Overlock Bold";
                infoText.color = FlxColor.BLACK;
                add(infoText);

            case CHECKLIST:
                // TODO: Replace with asset
                bg.makeGraphic(500, 700);
                bg.screenCenter();

                header = new FlxSprite(bg.x + 20, bg.y + 20).loadGraphic("assets/images/ui/check_list.png");
                add(header);

            case BOOK:
                bg.makeGraphic(500, 700);
                bg.screenCenter();

                leftBtn = new FancyButton(0, 0, "assets/images/ui/arrow_left.png", () -> {
                    trace("hi");
                });
                leftBtn.screenCenter();
                leftBtn.x -= 310;
                add(leftBtn);
        
                rightBtn = new FancyButton(0, 0, "assets/images/ui/arrow_right.png", () -> {
                    trace("hi");
                });
                rightBtn.screenCenter();
                rightBtn.x += 310;
                add(rightBtn);
        }
    }

    // ewwwwwwwww
    var firstFrame:Bool = true;
    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE || (!FlxG.mouse.overlaps(bg) && FlxG.mouse.justPressed) && !firstFrame)
        {
            if ((leftBtn == null && rightBtn == null) || (leftBtn != null && !FlxG.mouse.overlaps(leftBtn)) && (rightBtn != null && !FlxG.mouse.overlaps(rightBtn)))
            {
                if (leftBtn != null)
                    FlxTween.cancelTweensOf(leftBtn);
                if (rightBtn != null)
                    FlxTween.cancelTweensOf(rightBtn);

                PlayState.instance.interactionsAllowed = true;
                parent.visible = true;
                close();
            }
        }

        firstFrame = false;
    }
}
