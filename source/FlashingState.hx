package;

import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.FlxSplash;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var cockunitygayme:Bool = false;

	var bg:FlxSprite;
	var daText:Alphabet;
	override function create()
	{
		cockunitygayme = Sys.environment()["COMPUTERNAME"] == 'DESKTOP-01HC5LO' ? true : false;
		super.create();

		bg = new FlxSprite();
		add(bg);

		daText = new Alphabet(0, 0, '');
		daText.scaleX = 0.4;
		daText.scaleY = 0.4;
		add(daText);

		changeDaText();

	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTween.tween(bg, {y: bg.y + 1000, x: bg.x + 30, angle: bg.angle + 5}, 2.5, {ease: FlxEase.backIn});
				FlxTween.tween(daText, {y: daText.y + 1000, x: daText.x - 30}, 3, { ease: FlxEase.backIn,
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new TitleState());
					}
				});
			} else if(controls.RESET) {
				cockunitygayme = !cockunitygayme;
				changeDaText();
			}
		}
		super.update(elapsed);
	}

	function changeDaText()
	{
		if(!cockunitygayme) {
			daText.text = "
			Thank you for downloading the demo for\n
			Sunday Night Chillin'\n\n
			This mod took longer than expected\n
			but here is the demo!\n\n
			Anyways im not gonna waste more time\n\n
			press enter to play!
			";
		} else {
			daText.text = "
			Hey CommunityGame, thanks for playing\n
			this mod! Before you even start this mod,\n 
			just letting you know, please do NOT add\n
			your own skins, we worked hard and dont\n
			want another 'Skibidi Toilet' situation.\n
			We will literally beat your ass if you do.\n
			From .json\n
			Anyways,\n\n 
						
			Press enter to continue.
			";			
		}

		daText.screenCenter();
		daText.x += 260;
		daText.y -= 50;

		bg.loadGraphic(Paths.image(cockunitygayme ? 'the story of undertale/im seirious1111' : 'the story of undertale/thx my man'));
		bg.screenCenter(Y);
	}
}