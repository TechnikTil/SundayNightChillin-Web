package objects;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;

typedef CheckerData =
{
    @:optional var enabled:Bool;
	var size:Array<Int>;
	var colors:Array<Dynamic>;
	var speed:Array<Float>;
	var alpha:Float;
}

class Checkers extends FlxBackdrop
{
    public var checkerData:CheckerData;

    public function new(checkerData:CheckerData)
    {
        this.checkerData = checkerData;

        for (i in 0...checkerData.colors.length)
        {
            if (Std.isOfType(checkerData.colors[i], String))
                checkerData.colors[i] = FlxColor.fromString('#${checkerData.colors[i]}');
        }

        super(FlxGridOverlay.createGrid(
            checkerData.size[0], checkerData.size[1],
            checkerData.size[0] * 2, checkerData.size[1] * 2,
            true,
            checkerData.colors[0], checkerData.colors[1]
        ));

        velocity.set(checkerData.speed[0], checkerData.speed[1]);
		alpha = checkerData.alpha;
    }
}