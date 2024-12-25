package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxRadialGauge;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import props.fish.Fish;
import props.Stamp;
import ui.Mouse;
import game.Constants;

class PlayState extends FlxState
{
    public static var instance:PlayState;

    public var curHolding:FlxSprite;
    var curHoldingOffsetX:Float = 0;
    var curHoldingOffsetY:Float = 0;

    static inline var t_popupPath:String = "assets/images/ui/tutorial/popup-";
    static inline var t_popupAmt:Int = 11;
    var t_dimOverlay:FlxSprite;
    var t_pressPrompt:FlxSprite;
    var t_popups:FlxSprite;
    var t_currPopup:Int = 1;
    var t_inProgress:Bool = false;
    var t_canSwitchPopup:Bool = false;

    var concept:FlxSprite;

    var curFish:Fish;

    var clock:FlxRadialGauge;

    var stampAccept:Stamp;
    var stampDeny:Stamp;
    public var stamps:FlxTypedGroup<FlxSprite>;

    var draggableObjects:Array<FlxSprite>;

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
        addInteractable(stampAccept);

        stampDeny = new Stamp(stampAccept.x + stampAccept.width, stampAccept.y, false);
        addInteractable(stampDeny);

        clock = new FlxRadialGauge(0, 0);
        clock.makeShapeGraphic(CIRCLE, 50, 0, FlxColor.BLACK);
        add(clock);

        draggableObjects.reverse();

        t_dimOverlay = new FlxSprite(0, 0);
        t_dimOverlay.makeGraphic(1280, 720, FlxColor.BLACK);
        add(t_dimOverlay);
        FlxG.camera.zoom = 1.2;
        FlxTween.tween(FlxG.camera, {zoom: 1}, 2, {ease: FlxEase.cubeOut});
        FlxTween.color(
            t_dimOverlay,
            1,
            FlxColor.BLACK,
            FlxColor.fromRGB(0, 0, 0, 100),
            {ease: FlxEase.cubeOut, onComplete: startTutorial}
        );

        // startTutorial();
        // startInspection();
    }

    var clickable:Bool = false;
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (t_inProgress)
        {
            if (t_canSwitchPopup && FlxG.mouse.justPressed)
                switchTPopup();
            return;
        }

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

    function getCurrPopupPath()
    {
        var middle = Std.string(t_currPopup);
        if (t_currPopup < 10)
            middle = "0" + middle;

        return t_popupPath + middle + ".png";
    }

    function startTutorial(_)
    {
        t_inProgress = true;

        t_pressPrompt = new FlxSprite(-541, 573);
        t_pressPrompt.loadGraphic("assets/images/ui/tutorial/press.png");
        add(t_pressPrompt);

        FlxTween.tween(t_pressPrompt, {x: 0}, 1, {ease: FlxEase.cubeOut});

        t_popups = new FlxSprite(0, 0);
        t_popups.loadGraphic(getCurrPopupPath());
        t_popups.scale.set(0, 0);
        add(t_popups);

        animatePopup();
    }

    function switchTPopup()
    {
        t_canSwitchPopup = false;

        if (t_currPopup == t_popupAmt)
        {
            t_inProgress = false;

            FlxTween.tween(
                t_popups,
                {"scale.x": 0, "scale.y": 0},
                1,
                {
                    ease: FlxEase.cubeIn,
                    onComplete: (_) -> {
                        FlxTween.color(
                            t_dimOverlay,
                            1,
                            FlxColor.fromRGB(0, 0, 0, 100),
                            FlxColor.TRANSPARENT,
                            {ease: FlxEase.cubeOut, onComplete: startInspection}
                        );

                        FlxTween.tween(t_pressPrompt, {x: -541}, 1, {ease: FlxEase.cubeOut});
                    }
                }
            );
        }
        else
        {
            if (t_currPopup == 1)
            {
                FlxTween.color(
                    t_dimOverlay,
                    1,
                    FlxColor.fromRGB(0, 0, 0, 100),
                    FlxColor.TRANSPARENT,
                    {ease: FlxEase.cubeOut}
                );
            }
            else if (t_currPopup == t_popupAmt - 1)
            {
                FlxTween.color(
                    t_dimOverlay,
                    1,
                    FlxColor.TRANSPARENT,
                    FlxColor.fromRGB(0, 0, 0, 100),
                    {ease: FlxEase.cubeOut}
                );
            }

            t_currPopup++;
            t_popups.scale.set(0, 0);
            t_popups.loadGraphic(getCurrPopupPath());
    
            animatePopup();
        }
    }

    function animatePopup()
    {
        FlxTween.tween(
            t_popups,
            {"scale.x": 1, "scale.y": 1},
            1,
            {ease: FlxEase.bounceOut, onComplete: (_) -> {t_canSwitchPopup = true;}}
        );
    }

    function addInteractable(obj:FlxSprite):Void
    {
        add(obj);
        draggableObjects.push(obj);
    }

    function startInspection(_):Void
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
}
