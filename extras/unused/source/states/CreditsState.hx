package states;

// This contains the logic to TechnikTils unused animated Credits Icon.
class CreditsState extends MusicBeatState
{
    // Under `private var creditsStuff:Array<Array<String>> = [];`
    var tilIcon:AttachedSprite;

    override function create()
    {
        // Under `if(str.endsWith('-pixel')) icon.antialiasing = false;`
        if(str.contains('techniktil'))
        {
            var iconName:String = str.replace('credits/', '');
            icon.frames = Paths.getSparrowAtlas(str);

            icon.animation.addByPrefix('normal', '${iconName}0', 24, true);

            if(iconName == 'techniktil')
            {
                icon.animation.addByPrefix('blink', '$iconName blink', 24, false);
                icon.animation.addByPrefix('wink', '$iconName wink', 24, false);

                tilIcon = icon;
            }

            icon.animation.play('normal');
        }
    }

    // Under `var holdTime:Float = 0;`
    var tilMove:Bool = false;
	var tilTimer:FlxTimer = new FlxTimer();

    override function update(elapsed:Float)
    {
        // Above `super.update(elapsed)`
        if (tilIcon != null)
		{
			if (tilMove)
			{
				if(FlxG.random.bool(40) && tilIcon.animation.curAnim.name == 'normal')
					tilIcon.animation.play('blink', true);

				if(FlxG.random.bool(30) && tilIcon.animation.curAnim.name == 'normal')
					tilIcon.animation.play('wink', true);

				if(FlxG.random.bool(35) && tilIcon.animation.curAnim.name == 'wink')
					tilIcon.animation.play('wink', true, true);

				tilMove = false;
			}
			else
			{
				if (!tilTimer.active)
				{
					tilTimer.start(FlxG.random.float(0.5, 5), function (tmr:FlxTimer) {
						tilMove = true;
					});
				}
			}

			if(tilIcon.animation.curAnim.finished && !(tilIcon.animation.curAnim.name == 'wink' && !tilIcon.animation.curAnim.reversed))
				tilIcon.animation.play('normal');
		}
    }
}