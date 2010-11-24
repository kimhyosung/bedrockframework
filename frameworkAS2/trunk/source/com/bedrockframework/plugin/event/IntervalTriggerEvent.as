class com.bedrockframework.plugin.event.IntervalTriggerEvent extends com.bedrockframework.core.event.GenericEvent
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "IntervalTriggerEvent";
	
	public static var START:String = "IntervalTriggerEvent.onStart";
	public static var STOP:String = "IntervalTriggerEvent.onStop";
	public static var TRIGGER:String = "IntervalTriggerEvent.onIntervalTrigger";
	/*
	Constructor
	*/
	public function IntervalTriggerEvent($type:String, $target:Object, $details:Object)
	{
		super($type, $target, $details)
	}
}
