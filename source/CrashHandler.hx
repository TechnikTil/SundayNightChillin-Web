package;

import hxcodec.flixel.FlxVideo;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class CrashHandler extends MusicBeatState
{
    public static var errMsg:String;
	override function create()
	{
		super.create();
		var errText:FlxText = new FlxText(50, 50, FlxG.width / 2, errMsg, 64);
		errText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var sprite:FlxSprite = new FlxSprite();
		add(sprite);
		
		var video:FlxVideo = new FlxVideo();
		video.alpha = 0;
		video.onTextureSetup.add(function()
		{
			sprite.loadGraphic(video.bitmapData);
		});
		video.play(Paths.video('angry-bird'), false);
		
		video.onEndReached.add(function()
		{
			Sys.exit(1);
		});
	}
}
