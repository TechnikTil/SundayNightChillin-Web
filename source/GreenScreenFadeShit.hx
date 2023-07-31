package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GreenScreenFadeShit extends MusicBeatState
{
    var wantsShowFPS:Bool = true;
	override function create() //it is for the first cutscene lol
	{
        wantsShowFPS = ClientPrefs.showFPS;
        ClientPrefs.showFPS = false;
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.LIME);
		add(bg);
	}

	override function update(elapsed:Float)
	{
		var enter:Bool = controls.ACCEPT;
		if (enter) {
			openSubState(new CustomFadeTransition(0.35, false));
			new FlxTimer().start(0.35, function(tmr:FlxTimer) { openSubState(new CustomFadeTransition(0.35, true)); });
		}
		var back:Bool = controls.BACK;
		if (back) {
            ClientPrefs.showFPS = wantsShowFPS;
            MusicBeatState.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
