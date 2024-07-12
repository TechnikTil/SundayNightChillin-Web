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

    @:functionCode('
        int isDark = mode;
        HWND window = GetActiveWindow();
        if (S_OK != DwmSetWindowAttribute(window, 19, &isDark, sizeof(isDark))) {
            DwmSetWindowAttribute(window, 20, &isDark, sizeof(isDark));
        }
        UpdateWindow(window);
    ')
	@:noCompletion
	public static function _darkTitle(mode:Int) {}

	public static function darkTitle(isDark:Bool)
    {
        _darkTitle((isDark) ? 1 : 0);
    }

    /**
     * Tweens the window opacity to 0 then closes the game.
     *
     * @param time How long it takes to tween the window opacity.
     */
    public static function tweenClose(time:Float = 1):Void
    {
        if (windowOpacityTween != null && !windowOpacityTween.active)
        {
            windowOpacityTween = FlxTween.tween(FlxG.stage.window, { opacity: 0 }, time, { ease: FlxEase.sineOut, onComplete: function (twn:FlxTween) {
                Sys.exit(0);
            }});
        }
    }
}