package states;

import flixel.util.FlxTimer;
import props.Phone;
import states.substate.EndingSubState;
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
    public var curFish:Fish;
    var stampAccept:Stamp;
    var stampDeny:Stamp;
    public var stamps:FlxTypedGroup<FlxSprite>;
    var infoPaper:Document;
    var checklist:Document;
    var book:Document;
    var phone:Phone;

    var clockBg:FlxSprite;
    var clock:FlxRadialGauge;
    var plateArea:FlxSprite;
    var conveyorArea:FlxSprite;
    var trashArea:FlxSprite;

    public var dimOverlay:FlxSprite;

    // gameplay logic
    var fishTakenCareOf:Bool = false;
    var inspecting:Bool = false;
    var totalTime:Float;
    var maxTime:Float;
    var curTime:Float;
    var penaltiesReceived:Int;
    var score:Float;
    public var checklistQuestions:Array<ActualQuestionUsedInGame> = [];

    var draggableObjects:Array<IDraggable>;
    public var curHolding:IDraggable;
    var curHoldingOffsetX:Float = 0;
    var curHoldingOffsetY:Float = 0;

    var bombSfx:FlxSound;

    override public function create()
    {
        instance = this;
        super.create();
        persistentUpdate = true;
        draggableObjects = [];

        concept = new FlxSprite(0, 0).loadGraphic("assets/images/desk.png");
        add(concept);

        infoPaper = new Document(778, 54, PAPER);
        add(infoPaper);

        checklist = new Document(948, 201, CHECKLIST);
        add(checklist);

        book = new Document(796, 424, BOOK);
        add(book);

        phone = new Phone(10, 450);
        add(phone);

        var stampUnderside:FlxSprite = new FlxSprite(240, 585).loadGraphic("assets/images/stamp/underside.png");
        add(stampUnderside);

        curFish = new Fish(229, 194, FishData.random());
        curFish.visible = false;
        addDraggable(curFish);

        stamps = new FlxTypedGroup<FlxSprite>();
        add(stamps);

        stampAccept = new Stamp(248, 594, true);
        addDraggable(stampAccept);

        stampDeny = new Stamp(365, 598, false);
        addDraggable(stampDeny);

        plateArea = new FlxSprite(176, 76).makeGraphic(580, 510, FlxColor.WHITE);
        plateArea.alpha = 0;
        add(plateArea);

        conveyorArea = new FlxSprite(0, 0).makeGraphic(180, 500, FlxColor.WHITE);
        conveyorArea.x = FlxG.width - conveyorArea.width;
        conveyorArea.alpha = 0;
        add(conveyorArea);

        trashArea = new FlxSprite(conveyorArea.x, conveyorArea.height).makeGraphic(180, 220);
        trashArea.alpha = 0;
        add(trashArea);

        clockBg = new FlxSprite(-25, -25, "assets/images/ui/stopwatch.png");
        add(clockBg);

        clock = new FlxRadialGauge(24, 37);
        clock.makeShapeGraphic(CIRCLE, 42, 0, FlxColor.fromRGB(133, 100, 67));
        add(clock);

        draggableObjects.reverse();

        // startTutorial();
        // startInspection();

        FlxG.random.resetInitialSeed();
        trace("RNG seed: " + FlxG.random.initialSeed);

        // TODO: Check if tutorial not seen
        var needsTutorial:Bool = #if PLAY false #else true #end;

        dimOverlay = new FlxSprite(0, 0);
        dimOverlay.makeGraphic(1280, 720, FlxColor.WHITE);
        dimOverlay.color = FlxColor.BLACK;
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
                    trashArea.alpha = 0.6;
                }
                else
                {
                    trashArea.alpha = 0;
                }

                if (FlxG.mouse.overlaps(conveyorArea))
                {
                    // mouseState = TRASH;
                    conveyorArea.alpha = 0.6;
                }
                else
                {
                    conveyorArea.alpha = 0;
                }

                if (FlxG.mouse.overlaps(plateArea))
                {
                    plateArea.alpha = 0.6;
                }
                else
                {
                    plateArea.alpha = 0;
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
                    if (!FlxG.mouse.overlaps(conveyorArea) && !FlxG.mouse.overlaps(trashArea) && !FlxG.mouse.overlaps(plateArea))
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
                        else if (FlxG.mouse.overlaps(plateArea))
                        {
                            curFish.setPosition(fishPos.x, fishPos.y);
                        }
                    }
                }

                curHolding = null;
                curHoldingOffsetX = 0;
                curHoldingOffsetY = 0;
                skipInteractionsForAFrame = true;

                conveyorArea.alpha = 0;
                plateArea.alpha = 0;
                trashArea.alpha = 0;
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
        interactionsAllowed = false;
        fishTakenCareOf = false;
        maxTime = FlxG.random.float(Constants.TIME_MIN, Constants.TIME_MAX);
        curTime = 0;

        trace(maxTime);

        curFish.dragAllowed = false;
        curFish.loadFromData(FishData.random());
        trace(curFish.data);
        curFish.y = -curFish.height;

        // generate checklist
        var colors = Constants.QUESTIONS_COLOR.copy();
        var locations = Constants.QUESTIONS_LOCATION.copy();

        FlxG.random.shuffle(colors);
        FlxG.random.shuffle(locations);

        var allCorrect = FlxG.random.bool(Constants.ALL_CORRECT_CHANCE);
        if (allCorrect)
        {
            checklistQuestions.push({q: colors[0], inverse: !colors[1].func(curFish.data)});
            checklistQuestions.push({q: colors[1], inverse: !colors[1].func(curFish.data)});
            checklistQuestions.push({q: colors[1], inverse: !colors[1].func(curFish.data)});
        }
        else
        {
            
        }

        if (curFish.data.evil || curFish.data.bomb)
            maxTime = Constants.TIME_MAX_DANGER;

        if (curFish.data.evil)
        {
            dimOverlay.color = FlxColor.RED;
            dimOverlay.blend = MULTIPLY;
            dimOverlay.alpha = 0.7;
        }

        if (curFish.data.bomb)
        {
            bombSfx = FlxG.sound.load("assets/sounds/fuse");
            bombSfx.play();
            bombSfx.fadeIn(2.5);
        }

        if (fishPos != null)
            fishPos.put();
        fishPos = MathUtil.centerToArea(FlxRect.get(0, 0, curFish.width, curFish.height), FlxRect.get(200, 110, 520, 420), XY);

        curFish.visible = true;
        if (curFish.data.evil)
        {
            // no Tween we're going in Evil mode
            FlxG.sound.play("assets/sounds/impact");
            curFish.setPosition(fishPos.x, fishPos.y);
            inspecting = true;
            interactionsAllowed = true;
            curFish.dragAllowed = true;
            FlxG.sound.music.stop();

        }
        else
        {
            FlxTween.tween(curFish, {y: fishPos.y}, 2, {ease: FlxEase.cubeInOut, onComplete: (_) ->
            {
                inspecting = true;
                interactionsAllowed = true;
                curFish.dragAllowed = true;
                FlxG.sound.music.play();
            }});
        }   
    }

    function penalty():Void
    {
        FlxG.sound.music.stop();
        FlxG.sound.music.pitch = 1;

        penaltiesReceived++;
        score += Constants.SCORE_PENALTY;

        if (curFish.data.evil)
        {
            openSubState(new EndingSubState(EVIL));
        }
        if (curFish.data.bomb)
        {
            bombSfx.stop();
            openSubState(new EndingSubState(EXPLODE));
        }

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
        fishTakenCareOf = true;
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
                verifyFishAction(false);
            });
        }});
    }

    function verifyFishAction(trashed:Bool):Void
    {
        conveyorArea.alpha = 0;
        trashArea.alpha = 0;

        if (curFish.data.evil)
        {
            if (trashed)
            {
                dimOverlay.color = FlxColor.WHITE;
                dimOverlay.blend = NORMAL;
                dimOverlay.alpha = 0;
            }
            else
            {
                openSubState(new EndingSubState(EVIL));
            }
        }

        if (curFish.data.bomb)
        {
            bombSfx.stop();
            if (!trashed)
            {   
                openSubState(new EndingSubState(EXPLODE));
            }
        }
    }

    function trash():Void
    {
        fishTakenCareOf = true;
        inspecting = false;
        interactionsAllowed = false;

        FlxG.sound.play("assets/sounds/trash");
        curFish.visible = false;

        verifyFishAction(true);
    }

    function onIntroComplete():Void 
    {
        startInspection();
    }

}

typedef ActualQuestionUsedInGame =
{
    q:ChecklistQuestion,
    inverse:Bool
}
