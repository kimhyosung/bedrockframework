class com.bedrockframework.plugin.event.TimeoutTriggerEvent extends com.bedrockframework.core.event.GenericEvent
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "TimeoutTriggerEvent";
	
	public static var START:String = "TimeoutTriggerEvent.onStart";
	public static var STOP:String = "TimeoutTriggerEvent.onStop";
	public static var TRIGGER:String = "TimeoutTriggerEvent.onTimeoutTrigger";
	/*
	Constructor
	*/
	public function TimeoutTriggerEvent($type:String, $target:Object, $details:Object)
	{
		super($type, $target, $details);
	}
}
