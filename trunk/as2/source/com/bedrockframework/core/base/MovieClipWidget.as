import mx.events.EventDispatcher;
class com.bedrockframework.core.base.MovieClipWidget extends MovieClip
{
	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	private var _strClassName:String = "MovieClipWidget";
	
	public function MovieClipWidget()
	{
		EventDispatcher.initialize(this);
		this.output("Constructed");
	}
	
	public function output($trace, $category:String):Void
	{
		if ($category != undefined) {
			trace(this.toStringInternal() + " [" + $category + "]" + " : " + $trace);
		} else {
			trace(this.toStringInternal() + " : " + $trace);
		}
		
	}
	
	public function toStringInternal():String
	{
		return "[" + this._strClassName + "]";
	}
}
