import mx.events.EventDispatcher;
class com.bedrockframework.core.base.DispatcherWidget
{
	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	public function DispatcherWidget()
	{
		EventDispatcher.initialize(this);
	}
}