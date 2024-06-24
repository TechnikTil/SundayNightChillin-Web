package backend;

#if (windows && cpp)
@:buildXml('
    <target id="haxe"> <lib name="dwmapi.lib" if="windows" /> </target>
')
@:cppFileCode('
	#include <dwmapi.h>
')
#end

class SystemUtil
{
    // This is here because I need to access it from a PlayState function so it doesn't stop even when a substate is opened.
    public static var windowOpacityTween:FlxTween;

    #if (windows && cpp)
	@:functionCode('
		BOOL USE_DARK_MODE = isDark;
		HWND WINDOW = GetActiveWindow();

		BOOL SET_IMMERSIVE_DARK_MODE_SUCCESS = SUCCEEDED(DwmSetWindowAttribute(
			WINDOW,
			DWMWINDOWATTRIBUTE::DWMWA_USE_IMMERSIVE_DARK_MODE,
			&USE_DARK_MODE,
			sizeof(USE_DARK_MODE)
		));
	')
    #end
	public static function darkTitle(isDark:Bool) {}

    /**
     * Tweens the window opacity to 0 then closes the game.
     * 
     * @param time How long it takes to tween the window opacity.
     */
    public static function tweenClose(time:Float = 1):Void
    {
        windowOpacityTween = FlxTween.tween(FlxG.stage.window, { opacity: 0 }, time, { ease: FlxEase.sineOut, onComplete: function (twn:FlxTween) {
            Sys.exit(0);
        }});
    }
}