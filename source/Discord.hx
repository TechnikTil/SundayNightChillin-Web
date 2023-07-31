package;

import Sys.sleep;
import discord_rpc.DiscordRpc;

#if LUA_ALLOWED
import llua.Lua;
import llua.State;
#end

using StringTools;

class DiscordClient
{
	public static var isInitialized:Bool = false;
	public function new()
	{
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: "1116504588963545230",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			//trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
	}
	
	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}
	
	static function onReady()
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'image_normal',
			largeImageText: "Mod Version: " + MainMenuState.modVersion,
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
		isInitialized = true;
	}

	public static function changePresence(details:String, state:Null<String>, ?imageKeyThing : Bool, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		var funnyThings = 'image';
		if(!imageKeyThing) funnyThings = 'hi chat';
		funnyThings = 'leakers'; //nuh uh

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}
		switch(funnyThings) {
			case 'image':
				DiscordRpc.presence({
					details: details,
					state: state,
					largeImageKey: PlayState.instance.dad.curCharacter,
					smallImageKey : 'image_normal',
					largeImageText: PlayState.instance.dad.curCharacter,
					smallImageText: "Mod Version: " + MainMenuState.modVersion,
					// Obtained times are in milliseconds so they are divided so Discord can use it
					startTimestamp : Std.int(startTimestamp / 1000),
					endTimestamp : Std.int(endTimestamp / 1000)
				});
			case 'leakers':
				DiscordRpc.presence({
					details: 'nuh uh fuckers',
					state: 'no leaks for you',
					largeImageKey: 'image_leakers',
					smallImageKey: 'gb',
					smallImageText: 'nuh uh nothing here either',
					largeImageText: "Dont you even try.",
					// Obtained times are in milliseconds so they are divided so Discord can use it while people are modding this mod or something
					startTimestamp : Std.int(startTimestamp / 1000),
					endTimestamp : Std.int(endTimestamp / 800)
				});
			default:
				DiscordRpc.presence({
					details: details,
					state: state,
					largeImageKey: 'image_normal',
					smallImageKey: '',
					smallImageText: '',
					largeImageText: "Mod Version: " + MainMenuState.modVersion,
					// Obtained times are in milliseconds so they are divided so Discord can use it while people are modding this mod or something
					startTimestamp : Std.int(startTimestamp / 1000),
					endTimestamp : Std.int(endTimestamp / 1000)
				});
		}

		trace('Discord RPC Updated. Arguments: $details, $state, $imageKeyThing, $hasStartTimestamp, $endTimestamp, It is now live I think');
	}

	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State) {
		Lua_helper.add_callback(lua, "changePresence", function(details:String, state:Null<String>, ?imageKeyThing:Bool = false, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
			changePresence(details, state, imageKeyThing, hasStartTimestamp, endTimestamp);
		});
	}
	#end
}
