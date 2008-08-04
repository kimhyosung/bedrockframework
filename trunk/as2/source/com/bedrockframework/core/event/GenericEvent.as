/**

GenericEvent

This class serves  as a data type for all event broadcasts.

*/
class com.bedrockframework.core.event.GenericEvent
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "GenericEvent";
	public var type:String;
	public var target:Object;
	public var details:Object;
	/*
	Constructor
	*/
	public function GenericEvent($type:String, $target:Object, $details:Object)
	{
		this.type = $type;
		this.target = $target;	
		this.details = $details;
	}
	public function toString():String
	{
		return "[" + this._strClassName + "]";
	}
}
