import mx.events.EventDispatcher;
class com.bedrockframework.core.base.MovieClipWidget extends MovieClip
{
	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	public function MovieClipWidget()
	{
		EventDispatcher.initialize(this);
	}
}