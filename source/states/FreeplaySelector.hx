package states;

import substates.FreeplaySubState;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import options.OptionsState;
import states.editors.MasterEditorMenu;

class FreeplaySelector extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'part1',
        'part2',
        'part3',
        'extra',
        'old'
	];

	public static var bg:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.scrollFactor.set(0, 0);
		bg.color = 0xFFFDE871;
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		if (TitleState.titleJSON.checkerData.enabled)
		{
			var checkeredBG:Checkers = new Checkers({
				size: TitleState.titleJSON.checkerData.size,
				colors: [0x33FFFFFF, 0x0],
				speed: TitleState.titleJSON.checkerData.speed,
				alpha: 1
			});
			checkeredBG.scrollFactor.set(0, 0);
			add(checkeredBG);
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/' + optionShit[i]));
            menuItem.screenCenter();
            menuItem.y += (FlxG.height * i);
            menuItems.add(menuItem);
		}

		changeItem();

		super.create();

		FlxG.camera.follow(camFollow, null, 8);

        subStateClosed.add(function(_) {
            FlxTween.tween(bg, {x: bg.x - 40}, 0.4, {ease: FlxEase.cubeIn});
            selectedSomethin = false;

            for (i in menuItems.members)
            {
                FlxTween.tween(i, {alpha: 1}, 0.4, {ease: FlxEase.quadIn});
            }

            FlxTween.tween(menuItems.members[curSelected], {alpha: 1}, 0.4, {ease: FlxEase.quadIn});
        });
	}

	var selectedSomethin:Bool = false;
	var isMagenta:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplaySubState.vocals != null)
				FreeplaySubState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				selectedSomethin = true;

                if (ClientPrefs.data.flashing)
				{
					new FlxTimer().start(0.15, function (tmr:FlxTimer)
					{
						if (isMagenta)
							bg.color = 0xFFFDE871;
						else
							bg.color = 0xFFFD719B;

						isMagenta = !isMagenta;
					}, Std.int(1.1 / 0.15));
				}

				FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
				{
                    menuItems.members[curSelected].visible = true;
                    menuItems.members[curSelected].alpha = 0;

                    FlxTween.tween(bg, {x: bg.x + 40}, 0.4, {ease: FlxEase.cubeOut});
					openSubState(new FreeplaySubState(optionShit[curSelected]));
				});

                for (i in 0...menuItems.members.length)
				{
					if (i == curSelected)
						continue;

					FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
				}
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

        curSelected += huh;
		
        if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

        var point = menuItems.members[curSelected].getGraphicMidpoint();
		camFollow.setPosition(point.x, point.y);
	}
}
