package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxRadialGauge;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import game.Constants;
import props.Stamp;
import props.fish.Fish;
import states.substate.TutorialSubstate;
import ui.Mouse;

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

    var draggableObjects:Array<FlxSprite>;

    public var dimOverlay:FlxSprite;

    // gameplay logic
    var inspecting:Bool = false;
    var maxTime:Float;
    var curTime:Float;
    var penaltiesReceived:Int;

    override public function create()
    {
        instance = this;
        super.create();
        draggableObjects = [];

        concept = new FlxSprite(0, 0).loadGraphic("assets/images/deskconcept.png");
        add(concept);

        curFish = new Fish(229, 194, null);
        add(curFish);

        stamps = new FlxTypedGroup<FlxSprite>();
        add(stamps);

        stampAccept = new Stamp(162, 588, true);
        addDraggable(stampAccept);

        stampDeny = new Stamp(stampAccept.x + stampAccept.width, stampAccept.y, false);
        addDraggable(stampDeny);

        clock = new FlxRadialGauge(0, 0);
        clock.makeShapeGraphic(CIRCLE, 50, 0, FlxColor.BLACK);
        add(clock);

        draggableObjects.reverse();

        // startTutorial();
        // startInspection();

        dimOverlay = new FlxSprite(0, 0);
        dimOverlay.makeGraphic(1280, 720, FlxColor.BLACK);
        add(dimOverlay);
        FlxG.camera.zoom = 1.2;
        FlxTween.tween(FlxG.camera, {zoom: 1}, 2, {ease: FlxEase.cubeOut});
        FlxTween.color(dimOverlay, 1, FlxColor.BLACK, FlxColor.fromRGB(0, 0, 0, 100), 
            {
                ease: FlxEase.cubeOut,
                onComplete: (_) -> 
                {
                    // TODO: Check if tutorial not seen
                    var needsTutorial:Bool = #if PLAY false #else true #end;
                    if (needsTutorial)
                        openSubState(new TutorialSubstate(onIntroComplete));
                }
            }
        );
    }

    var clickable:Bool = false;
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        for (obj in draggableObjects)
        {
            if (!clickable)
                clickable = FlxG.mouse.overlaps(obj);
            handleMouse(obj);
        }

        Mouse.setState(clickable ? CLICKABLE : NORMAL);
        clickable = false;

        if (inspecting)
        {
            curTime += elapsed;
            clock.amount = 1 - (curTime / maxTime);

            if (curTime > maxTime)
            {
                penalty();
                // TODO: reset time? 
            }
        }
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

    function addDraggable(obj:FlxSprite):Void
    {
        add(obj);
        draggableObjects.push(obj);
    }

    function startInspection():Void
    {
        // TODO: randomize
        maxTime = 120;
        curTime = 0;
        inspecting = true;
    }

    function penalty():Void
    {
        penaltiesReceived++;
        if (penaltiesReceived > Constants.MAX_PENALTIES)
        {
            gameover();
        }

        // todo: phone sms
    }

    function gameover():Void
    {
        trace("bruh u so stupid");
    }

    function onIntroComplete():Void 
    {
        startInspection();
    }

}
