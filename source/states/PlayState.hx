package states;

import flixel.sound.FlxSound;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxObject;
import props.IDraggable;
import props.Document;
import props.fish.FishData;
import util.MathUtil;
import flixel.math.FlxRect;
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

    var concept:FlxSprite;

    var fishPos:FlxPoint;
    var curFish:Fish;
    var stampAccept:Stamp;
    var stampDeny:Stamp;
    public var stamps:FlxTypedGroup<FlxSprite>;
    var infoPaper:Document;
    var checklist:Document;

    var clock:FlxRadialGauge;
    var conveyorArea:FlxSprite;
    var trashArea:FlxSprite;

    public var dimOverlay:FlxSprite;

    // gameplay logic
    var inspecting:Bool = false;
    var totalTime:Float;
    var maxTime:Float;
    var curTime:Float;
    var penaltiesReceived:Int;
    var score:Float;

    var tickTime:Float;
    var tick1:Bool = false;

    var draggableObjects:Array<IDraggable>;
    public var curHolding:IDraggable;
    var curHoldingOffsetX:Float = 0;
    var curHoldingOffsetY:Float = 0;

    override public function create()
    {
        instance = this;
        super.create();
        persistentUpdate = true;
        draggableObjects = [];

        concept = new FlxSprite(0, 0).loadGraphic("assets/images/deskconcept.png");
        add(concept);

        curFish = new Fish(229, 194, FishData.random());
        curFish.visible = false;
        addDraggable(curFish);

        infoPaper = new Document(775, 54, Paper);
        add(infoPaper);

        checklist = new Document(936, 122, Checklist);
        add(checklist);

        stamps = new FlxTypedGroup<FlxSprite>();
        add(stamps);

        stampAccept = new Stamp(162, 588, true);
        addDraggable(stampAccept);

        stampDeny = new Stamp(stampAccept.x + stampAccept.width, stampAccept.y, false);
        addDraggable(stampDeny);

        conveyorArea = new FlxSprite(0, 0).makeGraphic(180, 500, FlxColor.WHITE);
        conveyorArea.x = FlxG.width - conveyorArea.width;
        conveyorArea.alpha = 0;
        add(conveyorArea);

        trashArea = new FlxSprite(conveyorArea.x, conveyorArea.height).makeGraphic(180, 220);
        trashArea.alpha = 0;
        add(trashArea);

        clock = new FlxRadialGauge(0, 0);
        clock.makeShapeGraphic(CIRCLE, 50, 0, FlxColor.BLACK);
        add(clock);

        draggableObjects.reverse();

        // startTutorial();
        // startInspection();

        // TODO: Finalized track, add .mp3 for web
        FlxG.sound.playMusic("assets/music/test1a", 0.5);
        // FlxG.sound.music.fadeIn(2, 0, 0.7);

        // TODO: Check if tutorial not seen
        var needsTutorial:Bool = #if PLAY false #else true #end;

        dimOverlay = new FlxSprite(0, 0);
        dimOverlay.makeGraphic(1280, 720, FlxColor.BLACK);
        add(dimOverlay);
        FlxG.camera.zoom = 1.2;
        FlxTween.tween(FlxG.camera, {zoom: 1}, 2, {ease: FlxEase.cubeOut});
        FlxTween.color(dimOverlay, 1, FlxColor.BLACK, needsTutorial ? FlxColor.fromRGB(0, 0, 0, 100) : 0, 
            {
                ease: FlxEase.cubeOut,
                onComplete: (_) -> 
                {
                    if (needsTutorial)
                        openSubState(new TutorialSubstate(onIntroComplete));
                    else
                        onIntroComplete();
                }
            }
        );
    }

    public var interactionsAllowed:Bool = false;
    public var mouseState:MouseState = NORMAL;
    // bleh
    var skipInteractionsForAFrame:Bool = false;
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (interactionsAllowed)
        {
            for (obj in draggableObjects)
            {
                if (!obj.dragAllowed || skipInteractionsForAFrame)
                    continue;

                var spr:FlxSprite = cast (obj, FlxSprite);
                if (mouseState == NORMAL)
                    mouseState = FlxG.mouse.overlaps(spr) ? CLICKABLE : NORMAL;
                
                handleMouse(spr, obj);
            }
        }
        skipInteractionsForAFrame = false;

        Mouse.setState(mouseState);
        mouseState = NORMAL;
        if (inspecting)
        {
            totalTime += elapsed;
            curTime += elapsed;
            clock.amount = 1 - (curTime / maxTime);

            if (curTime > maxTime)
            {
                penalty();
                // TODO: reset time? 
            }

            if (curTime > (maxTime - 5))
            {
                // clock.color = FlxColor.RED;
                FlxG.sound.music.pitch += 0.2 * elapsed;
            }
        }
    }

    function handleMouse(obj:FlxObject, d:IDraggable):Void
    {
        if (FlxG.mouse.overlaps(obj) && FlxG.mouse.justPressed && curHolding == null)
        {
            curHolding = d;
            curHoldingOffsetX = FlxG.mouse.x - obj.x;
            curHoldingOffsetY = FlxG.mouse.y - obj.y;

            if (d.pickupSound != null)
            {
                FlxG.sound.play(d.pickupSound);
            }

            // Return now otherwise its gonna continue and mess up
            return;
        }

        if (curHolding == d)
        {
            obj.x = FlxG.mouse.x - curHoldingOffsetX;
            obj.y = FlxG.mouse.y - curHoldingOffsetY;

            if (obj is Fish)
            {
                if (FlxG.mouse.overlaps(trashArea))
                {
                    mouseState = TRASH;
                    trashArea.alpha = 0.4;
                }
                else
                {
                    trashArea.alpha = 0;
                }

                if (FlxG.mouse.overlaps(conveyorArea))
                {
                    // mouseState = TRASH;
                    conveyorArea.alpha = 0.4;
                }
                else
                {
                    conveyorArea.alpha = 0;
                }
            }

            if (FlxG.mouse.justPressed)
            {
                if (obj is Stamp)
                {
                    // cast (obj, IDraggable).dragAllowed = false;
                    var stamp:Stamp = cast obj;
                    stamp.dragAllowed = false;
                    FlxTween.tween(obj, {x: stamp.initialX, y: stamp.initialY}, 0.5,
                        {
                            ease: FlxEase.quadInOut, 
                            onComplete: (_) ->
                            {
                                stamp.dragAllowed = true;
                            }
                        }
                    );
                }
                else if (obj is Fish)
                {
                    // TODO: Check trash & plate
                    if (!FlxG.mouse.overlaps(conveyorArea) && !FlxG.mouse.overlaps(trashArea))
                    {
                        // TODO: sound
                        return;
                    }
                    else
                    {
                        if (FlxG.mouse.overlaps(conveyorArea))
                        {
                            startConveyor();
                        }
                        else if (FlxG.mouse.overlaps(trashArea))
                        {
                            trash();
                        }
                    }
                }

                curHolding = null;
                curHoldingOffsetX = 0;
                curHoldingOffsetY = 0;
                skipInteractionsForAFrame = true;
            }
        }
    }

    function addDraggable(obj:IDraggable):Void
    {
        add(cast (obj, FlxBasic));
        draggableObjects.push(obj);
    }

    function startInspection():Void
    {
        // TODO: randomize
        interactionsAllowed = false;
        maxTime = 10;
        curTime = 0;

        curFish.dragAllowed = false;
        curFish.loadFromData(FishData.random());
        trace(curFish.data);
        curFish.y = -curFish.height;

        if (fishPos != null)
            fishPos.put();
        fishPos = MathUtil.centerToArea(FlxRect.get(0, 0, curFish.width, curFish.height), FlxRect.get(200, 110, 520, 420), XY);

        curFish.visible = true;
        FlxTween.tween(curFish, {y: fishPos.y}, 2, {ease: FlxEase.cubeInOut, onComplete: (_) ->
        {
            inspecting = true;
            interactionsAllowed = true;
            curFish.dragAllowed = true;
        }});
    }

    function penalty():Void
    {
        FlxG.sound.music.stop();
        FlxG.sound.music.pitch = 1;

        penaltiesReceived++;
        score += Constants.SCORE_PENALTY;

        if (penaltiesReceived > Constants.MAX_PENALTIES)
        {
            gameover();
        }

        // todo: phone sms
    }

    function gameover():Void
    {
        inspecting = false;

        trace("bruh u so stupid");
    }

    function startConveyor():Void
    {
        inspecting = false;
        interactionsAllowed = false;

        var conveyorSound:FlxSound = FlxG.sound.play("assets/sounds/conveyor");

        var distance:Float = Math.abs(-curFish.height - curFish.y);
        var speed:Float = distance / 2;
        var duration:Float = distance / speed;
        trace(duration);
        FlxTween.tween(curFish, {y: -curFish.height}, duration, {onComplete: (_) ->
        {
            conveyorSound.fadeOut(0.5, 0, (_) ->
            {

            });
        }});
    }

    function trash():Void
    {
        trace("oi oi oi ");
        inspecting = false;
        interactionsAllowed = false;

        FlxG.sound.play("assets/sounds/trash");
        curFish.visible = false;
    }

    function onIntroComplete():Void 
    {
        startInspection();
    }

}
