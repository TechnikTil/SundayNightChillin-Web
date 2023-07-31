package;

import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

class Cache extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;

    var text:FlxText;
    var sncLogo:FlxSprite;

    var whatCache:Array<Array<String>> = [[]];

	override function create()
	{
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);

        text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Loading SNC...");
        text.size = 34;
        text.alignment = FlxTextAlign.CENTER;
        text.alpha = 0;

        sncLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('SNC'));
        sncLogo.x -= sncLogo.width / 2;
        sncLogo.y -= sncLogo.height / 2 + 100;
        text.y -= sncLogo.height / 2 - 125;
        text.x -= 170;
        sncLogo.setGraphicSize(Std.int(sncLogo.width * 0.6));

        sncLogo.alpha = 1;

        add(sncLogo);
        add(text);

        trace('starting caching..');
        
        sys.thread.Thread.create(() -> {
            FlxG.sound.play(Paths.sound('startup'), 1, false, null, true, function() {
                sncLogo.alpha = 0;
                cachingReq();
            });
        });


        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {
        if (toBeDone != 0 && done != toBeDone)
        {
            var alpha = CoolUtil.truncateFloat(done / toBeDone * 100,2) / 100;
            sncLogo.alpha = alpha;
            text.alpha = alpha;
            text.text = "Loading... (" + done + "/" + toBeDone + ")";
        }

        super.update(elapsed);
    }


    function cachingReq(daPath:String = 'assets'):Void
    {
        var files:Array<String> = FileSystem.readDirectory(daPath);
        var imageCount:Int = 0;
        var soundCount:Int = 0;

        for (file in files)
        {
            var filePath:String = daPath + "/" + file;

            if (FileSystem.isDirectory(filePath))
            {
                trace('oh shit, we hit a dir, going in it! btw it is ' + filePath);
                cachingReq(filePath);
            }
            else
            {
                var fileExtension:String = filePath.split('.')[1];
                var fileName:String = filePath.split('.')[0];

                switch (fileExtension)
                {
                    case "mp3", "ogg":
                        trace('found a sound! its dir is ' + filePath);
                        whatCache[0].push(filePath);
                        soundCount++;
                    case "png":
                        trace('found an image! its dir is ' + filePath);
                        whatCache[1].push(filePath);
                        imageCount++;
                    default:
                        trace('fuck you ' + filePath +  ' i cant load your ass');
                }
            }
        }

        toBeDone = imageCount + soundCount;
        trace("Finished calculating!");
        cache();

    }

    function cache()
    {

        trace(whatCache);

        for (i in whatCache[0])
        {
            if(i.contains('shared')) {
                var replaced = i.replace("assets/shared/images", "");
                FlxG.bitmap.add(Paths.image(i, "shared"));
            } else {
                var replaced = i.replace("assets/images", "");
                FlxG.bitmap.add(Paths.image(i));
            }
            trace("cached " + i);
            done++;
        }

        for (i in whatCache[1])
        {
            FlxG.sound.cache(i);
            trace("cached " + i);
            done++;
        }

        trace("Finished caching...");

        FlxG.switchState(new TitleState());
    }

}