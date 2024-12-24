package states;

import hscript.Macro;
import ui.Mouse;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import props.Stamp;
import flixel.util.FlxColor;
import flixel.addons.display.FlxRadialGauge;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import props.Fish;

class PlayState extends FlxState
{
    public static var instance:PlayState;

    public var curHolding:FlxSprite;
    var curHoldingOffsetX:Float = 0;
    var curHoldingOffsetY:Float = 0;

    var concept:FlxSprite;

    var curFish:Fish;
    var clock:FlxRadialGauge;

    var stampAccept:Stamp;
    var stampDeny:Stamp;
    public var stamps:FlxTypedGroup<FlxSprite>;

    var interactableObjects:Array<FlxSprite>;

    override public function create()
    {
        instance = this;
        super.create();
        interactableObjects = [];

        concept = new FlxSprite(0, 0).loadGraphic("assets/images/deskconcept.png");
        add(concept);

        curFish = new Fish(229, 194);
        add(curFish);

        stamps = new FlxTypedGroup<FlxSprite>();
        add(stamps);

        stampAccept = new Stamp(162, 588, true);
        addInteractable(stampAccept);

        stampDeny = new Stamp(stampAccept.x + stampAccept.width, stampAccept.y, false);
        addInteractable(stampDeny);

        clock = new FlxRadialGauge(0, 0);
        clock.makeShapeGraphic(CIRCLE, 50, 0, FlxColor.BLACK);
        add(clock);

        interactableObjects.reverse();
    }

    var clickable:Bool = false;
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        for (obj in interactableObjects)
        {
            if (!clickable)
                clickable = FlxG.mouse.overlaps(obj);
            handleMouse(obj);
        }

        Mouse.setState(clickable ? CLICKABLE : NORMAL);
        clickable = false;
    }

    function handleMouse(obj:FlxSprite):Void
    {
        if (FlxG.mouse.overlaps(obj) && FlxG.mouse.justPressed && curHolding == null)
        {
            curHolding = obj;
            curHoldingOffsetX = FlxG.mouse.x - obj.x;
            curHoldingOffsetY = FlxG.mouse.y - obj.y;

            // Return now otherwise its gonna continue and mess up
            return;
        }

        if (curHolding == obj)
        {
            obj.x = FlxG.mouse.x - curHoldingOffsetX;
            obj.y = FlxG.mouse.y - curHoldingOffsetY;

            if (FlxG.mouse.justPressed)
            {
                curHolding = null;
                curHoldingOffsetX = 0;
                curHoldingOffsetY = 0;
            }
        }
    }

    function addInteractable(obj:FlxSprite):Void
    {
        add(obj);
        interactableObjects.push(obj);
    }
}
