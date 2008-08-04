import com.bedrockframework.core.dispatcher.EventDispatcher;
import com.bedrockframework.core.event.GenericEvent;

class com.bedrockframework.core.dispatcher.BedrockDispatcher
{
	/*
	Variable Decarations
	*/
	private static var __bolInitialized:Boolean;
	private static var __objDispatcher:Object;
	/*
	Initialize
	*/
	public static function initialize():Void
	{
		if (!BedrockDispatcher.__bolInitialized) {
			BedrockDispatcher.createDispatcher();
			BedrockDispatcher.__bolInitialized = true;
			trace("[BedrockDispatcher] : Initialized");
		}
	}
	
	private static function createDispatcher():Void
	{
		BedrockDispatcher.__objDispatcher = new Object();
		EventDispatcher.initialize(BedrockDispatcher.__objDispatcher);
		BedrockDispatcher.__objDispatcher.toString = function  () {
				return "[BedrockDispatcher]"
		}
	}

	public static function dispatchEvent($event:GenericEvent):Void
	{
		if (!BedrockDispatcher.__bolInitialized) {
			BedrockDispatcher.initialize();
		}
		BedrockDispatcher.__objDispatcher.dispatchEvent($event);
	}

	public static function addEventListener($event:String, $scope:Object, $handler:Function):Void
	{
		if (!BedrockDispatcher.__bolInitialized) {
			BedrockDispatcher.initialize();
		}
		BedrockDispatcher.__objDispatcher.addEventListener($event, $scope, $handler);
	}

	public static function removeEventListener($event:String, $scope:Object, $handler:Function):Void
	{
		if (!BedrockDispatcher.__bolInitialized) {
			BedrockDispatcher.initialize();
		}
		BedrockDispatcher.__objDispatcher.removeEventListener($event, $scope, $handler);
	}
	
	public function toString():String
	{
		return "[BedrockDispatcher]"
	}
}