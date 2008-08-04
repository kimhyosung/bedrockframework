import com.bedrockframework.core.dispatcher.EventDispatcher;
class com.bedrockframework.core.base.DispatcherWidget extends com.bedrockframework.core.base.StandardWidget
{
	private var _strClassName:String = "DispatcherWidget";
	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	public function DispatcherWidget()
	{
		EventDispatcher.initialize(this);
	}
}