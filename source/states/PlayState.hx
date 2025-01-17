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
    public var totalTime:Float;
    var maxTime:Float;
    var curTime:Float;
    var penaltiesReceived:Int;
    var score:Float;
    public var stampsGood:Int = 0;
    public var stampsBad:Int = 0;
    public var checklistQuestions:Array<ActualQuestionUsedInGame> = [];
    public var checklistIntroText:Null<Int> = null;
    public var checklistLastPage:Int = 1;

    var draggableObjects:Array<IDraggable>;
    public var curHolding:IDraggable;
    var curHoldingOffsetX:Float = 0;
    var curHoldingOffsetY:Float = 0;

    var bombSfx:FlxSound;

    public var survivedRounds:Int = -1;

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

        phone = new Phone(10, 450, onPhoneSequenceComplete);
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

        conveyorArea = new FlxSprite(0, 0).makeGraphic(160, 500, FlxColor.WHITE);
        conveyorArea.x = FlxG.width - conveyorArea.width;
        conveyorArea.alpha = 0;
        add(conveyorArea);

        trashArea = new FlxSprite(conveyorArea.x, conveyorArea.height).makeGraphic(160, 220);
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

        FlxG.sound.playMusic("assets/music/main", 0.5);

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
                        FlxG.sound.play("assets/sounds/disallowed");
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
        FlxG.sound.music.pitch = 1;
        interactionsAllowed = false;
        fishTakenCareOf = false;
        stampsGood = 0;
        stampsBad = 0;
        maxTime = FlxG.random.float(Constants.TIME_MIN, Constants.TIME_MAX);
        curTime = 0;
        clock.amount = 1;
        survivedRounds++;

        trace(maxTime);

        curFish.dragAllowed = false;
        curFish.loadFromData(FishData.random());
        trace(curFish.data);
        curFish.y = -curFish.height * 2;

        checklistQuestions.splice(0, checklistQuestions.length);

        // generate checklist
        var colors = Constants.QUESTIONS_COLOR.copy();
        var misc = Constants.QUESTIONS_MISC.copy();

        var locations = Constants.QUESTIONS_LOCATION.copy();
        var kinds = Constants.QUESTIONS_KIND.copy();
        var ezmix = locations.concat(kinds);

        FlxG.random.shuffle(colors);
        FlxG.random.shuffle(misc);
        FlxG.random.shuffle(ezmix);

        var allCorrect = FlxG.random.bool(Constants.ALL_CORRECT_CHANCE);
        if (curFish.data.location == NUCLEAR_WASTELAND)
            allCorrect = false;

        var reallyEasy = FlxG.random.bool(Constants.EZ_MODE_CHANCE);
        if (allCorrect)
        {
            // trace("all correct btw");
            // only add color questions if there's a color modifier
            if (curFish.data.color != null)
                checklistQuestions.push({q: colors[0], inverse: !colors[0].func(curFish.data)});
            else
                checklistQuestions.push({q: misc[0], inverse: !misc[0].func(curFish.data)});

            checklistQuestions.push({q: misc[1], inverse: !misc[1].func(curFish.data)});
            checklistQuestions.push({q: misc[2], inverse: !misc[2].func(curFish.data)});

            if (reallyEasy)
                checklistQuestions.push({q: ezmix[0], inverse: !ezmix[0].func(curFish.data)});
            else
                checklistQuestions.push({q: misc[3], inverse: !misc[3].func(curFish.data)});
        }
        else
        {
            if (curFish.data.color != null)
                checklistQuestions.push({q: colors[0], inverse: FlxG.random.bool()});
            else
                checklistQuestions.push({q: misc[0], inverse: FlxG.random.bool()});

            checklistQuestions.push({q: misc[1], inverse: FlxG.random.bool()});
            checklistQuestions.push({q: misc[2], inverse: FlxG.random.bool()});

            if (reallyEasy)
                checklistQuestions.push({q: ezmix[0], inverse: !FlxG.random.bool()});
            else
                checklistQuestions.push({q: misc[3], inverse: FlxG.random.bool()});
        }

        // shuffle for random order
        FlxG.random.shuffle(checklistQuestions);
        // trace(checklistQuestions);

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
        curFish.x = fishPos.x;

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
        openSubState(new EndingSubState(TOO_MANY_PENALTIES));
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
        // trace(duration);
        FlxTween.tween(curFish, {y: -curFish.height * 2}, duration, {onComplete: (_) ->
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
                return;
            }
        }

        if (curFish.data.bomb)
        {
            bombSfx.stop();
            if (!trashed)
            {   
                openSubState(new EndingSubState(EXPLODE));
                return;
            }
        }

        FlxG.sound.music.pitch = 1;
        var finalDecision:Bool = true;
        if (trashed)
        {
            // trace(finalDecision);
            if (!curFish.data.evil && !curFish.data.bomb)
            {
                // autofail if we trash something that shouldn't have been trashed
                finalDecision = false;
            }
        }
        else
        {
            // trace(finalDecision);
            if (!curFish.data.evil && !curFish.data.bomb)
            {
                // trace("testing");
                var passesRequirements:Bool = true;
                for (que in checklistQuestions)
                {
                    // trace(que.q.title);
                    // trace(que.q.titleOpposite);
                    // trace(que.inverse);
                    
                    var testResult = que.q.func(curFish.data);
                    if (que.inverse)
                        testResult = !testResult;

                    if (!testResult)
                    {
                        passesRequirements = false;
                        break;
                    }
                }

                var stampAccepted = stampResult();
                if (stampsGood == 0 && stampsBad == 0)
                {
                    finalDecision = false;

                    if (curFish.data.poisonous)
                    {
                        openSubState(new EndingSubState(POISONED));
                        return;
                    }
                }
                else if ((stampAccepted && !passesRequirements) || (!stampAccepted && passesRequirements))
                    finalDecision = false;

                if (curFish.data.poisonous && stampAccepted)
                {
                    finalDecision = false;
                    openSubState(new EndingSubState(POISONED));
                    return;
                }
            }
        }

        FlxTimer.wait(1, () -> 
        {
            if (finalDecision)
                phone.doHappy();
            else
            {
                phone.doMad();
                penalty();
            }
        });
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

    function stampResult():Bool
    {
        if (stampsGood < stampsBad)
            return false;
        if (stampsGood > stampsBad)
            return true;

        // Equal number of stamps
        // Fuck you, now you get a random result
        return FlxG.random.bool();
    }

    function onPhoneSequenceComplete():Void
    {
        FlxTimer.wait(2, startInspection);
    }

}

typedef ActualQuestionUsedInGame =
{
    q:ChecklistQuestion,
    inverse:Bool
}
