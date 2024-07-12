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

	var freeplayItems:FlxTypedGroup<FlxSprite>;

	var freeplayOptions:Array<Array<Dynamic>> = [
		// Name, Unlocked
		['part1', true],
        ['part2', false],
        ['part3', false],
        ['extra', false],
        ['old', true]
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

		freeplayItems = new FlxTypedGroup<FlxSprite>();
		add(freeplayItems);

		for (i in 0...freeplayOptions.length)
		{
			var freeplayItem:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/' + freeplayOptions[i][0]));
            freeplayItem.screenCenter();
            freeplayItem.y += (FlxG.height * i);
            freeplayItems.add(freeplayItem);
		}

		changeItem();

		super.create();

		FlxG.camera.follow(camFollow, null, 8);

        subStateClosed.add(function(_) {
            selectedSomethin = false;

            for (i in freeplayItems.members)
            {
                FlxTween.tween(i, {alpha: 1}, 0.4, {ease: FlxEase.quadIn});
            }

            FlxTween.tween(freeplayItems.members[curSelected], {alpha: 1}, 0.4, {ease: FlxEase.quadIn});
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
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				if (!freeplayOptions[curSelected][1])
				{
					var buzzer:FlxSound = FlxG.sound.play(Paths.sound('buzzer'));
					FlxG.camera.shake(0.0015, buzzer.length / 1000);
					return;
				}

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

				FlxFlicker.flicker(freeplayItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
				{
                    freeplayItems.members[curSelected].visible = true;
                    freeplayItems.members[curSelected].alpha = 0;

					openSubState(new FreeplaySubState(freeplayOptions[curSelected][0]));
				});

                for (i in 0...freeplayItems.members.length)
				{
					if (i == curSelected)
						continue;

					FlxTween.tween(freeplayItems.members[i], {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
				}
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

        curSelected += huh;

        if (curSelected >= freeplayItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = freeplayItems.length - 1;

        var point = freeplayItems.members[curSelected].getGraphicMidpoint();
		camFollow.setPosition(point.x, point.y);
	}
}
