package states.stages;

import substates.GameOverSubstate;
import flixel.FlxSubState;
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
import states.stages.objects.*;

class GBStage extends BaseStage
{
	var rainShader:FlxRuntimeShader;
	var usingRainShader:Bool = false;

	var bg:FlxSprite;
	var clouds:BGSprite;
	var mountain3:BGSprite;
	var mountain2:BGSprite;
	var mountain1:BGSprite;
	var ground:BGSprite;

	override public function create():Void
	{
		bg = new FlxSprite(-600, -500).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
		bg.color = 0x0;

		if (!ClientPrefs.data.lowQuality)
		{
			clouds = new BGSprite(null, -600, -400, 0.3, 0.3);
			mountain3 = new BGSprite(null, -550, -11, 0.8, 0.4);
			mountain2 = new BGSprite(null, -600, 41, 0.75, 0.4);
			mountain1 = new BGSprite(null, -600, 150, 0.7, 0.4);
		}

		ground = new BGSprite(null, -500, 702, 0.9, 0.9);

		reloadSprites('Light');

		add(bg);

		if (!ClientPrefs.data.lowQuality)
		{
			add(clouds);
			add(mountain3);
			add(mountain2);
			add(mountain1);
		}

		add(ground);
	}

    override public function createPost():Void
    {
        if (isStoryMode && !PlayState.seenCutscene)
        {
            switch (songName)
            {
                case 'chillin':
                    setStartCallback(function () {
                        game.startVideo('chillin-start');
                    });

                case 'anger-issues':
                    setEndCallback(function () {
                        // All because I saw a frame of the actual game at the end.
                        var black:FlxSprite = new FlxSprite(-1000, -500).makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.BLACK);
                        black.scrollFactor.set();
                        black.camera = camOther;
                        black.alpha = 0;
                        add(black);

                        // Just so it doesn't flash black before playing.
                        new FlxTimer().start(1, function (tmr:FlxTimer) {
                            black.alpha = 1;
                        });

                        game.startVideo('anger-issues-end');
                        game.endingSong = true;
                    });
            }
        }
    }

	override public function update(elapsed:Float):Void
	{
		if (ClientPrefs.data.shaders && usingRainShader && rainShader != null)
			rainShader.setFloat('uTime', rainShader.getFloat('uTime') + elapsed);

        if (game.health <= 0 && rainShader != null && usingRainShader)
            removeRainShader();
	}

	override public function stepHit():Void
	{
		if (ClientPrefs.data.flashing && curStep == 511 && songName == 'anger-issues')
			camGame.flash();
	}

	override public function eventPushed(event:objects.Note.EventNote):Void
	{
		var value1:String = event.value1.toLowerCase();

		switch (event.event)
		{
			case 'Change GB Stage Setting':
                // Precaching all images before hand to avoid frame drops upon changing.
				if (!ClientPrefs.data.lowQuality)
				{
					Paths.image('$value1/clouds', null, true);
					Paths.image('$value1/mountainback3', null, true);
					Paths.image('$value1/mountainback2', null, true);
					Paths.image('$value1/mountainback1', null, true);
				}

				Paths.image('$value1/ground', null, true);

				if (ClientPrefs.data.shaders && value1.toLowerCase() == 'rain' && rainShader == null)
				{
					rainShader = game.createRuntimeShader('rain');
					rainShader.setFloatArray('uScreenResolution', [FlxG.width, FlxG.height]);
					rainShader.setFloatArray('uCameraBounds', [camGame.viewLeft, camGame.viewTop, camGame.viewRight, camGame.viewBottom]);
					rainShader.setFloat('uTime', 1);
					rainShader.setFloat('uIntensity', 0.2);
					rainShader.setFloat('uScale', FlxG.height / 200);
				}
		}
	}

    var rainShaderFilter:ShaderFilter;

	override public function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float):Void
	{
		switch (eventName)
		{
			case 'Change GB Stage Setting':
				reloadSprites(value1);

				if (ClientPrefs.data.shaders && rainShader != null)
				{
					if (value1.toLowerCase() == 'rain' && !usingRainShader)
					{
                        rainShaderFilter = new ShaderFilter(rainShader);

                        if (FlxG.camera.filters == null)
                            FlxG.camera.filters = [rainShaderFilter];
                        else
                            FlxG.camera.filters.push(rainShaderFilter);

						usingRainShader = true;
					}
                    else if (value1.toLowerCase() != 'rain' && usingRainShader)
                        removeRainShader();
				}
		}
	}

    function removeRainShader():Void
    {
        rainShader = null;
        FlxG.camera.filters.remove(rainShaderFilter);
        usingRainShader = false;
    }

	function reloadSprites(type:String):Void
	{
		var typeLowercase:String = type.toLowerCase();

		bg.color = grabBGColor(typeLowercase);
		bg.scrollFactor.set(0.1, 0.1);

		if (!ClientPrefs.data.lowQuality)
		{
			clouds.loadGraphic(Paths.image('$typeLowercase/clouds'));

			if (typeLowercase == 'light')
			{
				clouds.x = 634;
				clouds.y = -367;
				clouds.velocity.x = 5;
			}
			else
			{
				clouds.x = 600;
				clouds.y = -400;
				clouds.velocity.x = 0;
			}

			mountain3.loadGraphic(Paths.image('$typeLowercase/mountainback3'));
			mountain2.loadGraphic(Paths.image('$typeLowercase/mountainback2'));
			mountain1.loadGraphic(Paths.image('$typeLowercase/mountainback1'));
		}

		ground.loadGraphic(Paths.image('$typeLowercase/ground'));
		ground.setGraphicSize(Std.int(ground.width * 1.2));
	}

	function grabBGColor(type:String):FlxColor
	{
		return switch (type.toLowerCase())
		{
			case 'light':
				0xFF95D1DD;

			case 'rain':
				0xFF78979D;

			default:
				0x0;
		};
	}
}
