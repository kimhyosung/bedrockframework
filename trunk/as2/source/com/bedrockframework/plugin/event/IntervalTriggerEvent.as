class com.bedrockframework.plugin.event.TriggerEvent extends com.bedrockframework.core.event.GenericEvent
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "TriggerEvent";
	
	public static var START:String = "TriggerEvent.onStart";
	public static var STOP:String = "TriggerEvent.onStop";
	public static var TRIGGER:String = "TriggerEvent.onTrigger";
	/*
	Constructor
	*/
	public function TriggerEvent($type:String, $target:Object, $details:Object)
	{
		super($type, $target, $details)
	}
}
