class com.bedrockframework.plugin.event.DelayEvent extends com.bedrockframework.core.event.GenericEvent
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "DelayEvent";
	
	public static var START:String = "DelayEvent.onStart";
	public static var STOP:String = "DelayEvent.onStop";
	public static var TRIGGER:String = "DelayEvent.onDelay";
	/*
	Constructor
	*/
	public function DelayEvent($type:String, $target:Object, $details:Object)
	{
		super($type, $target, $details)
	}
}
