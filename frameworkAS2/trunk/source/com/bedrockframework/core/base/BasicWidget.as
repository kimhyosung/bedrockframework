class com.bedrockframework.core.base.BasicWidget
{
	/*
	Variable Definitions
	*/
	private var _strClassName:String = "BasicWidget";
	/*
	Constructor
	*/
	public function BasicWidget()
	{
		
		
	}
	public function output($trace, $category:String):Void
	{
		if ($category != undefined) {
			trace(this + " [" + $category + "]" + " : " + $trace);
		} else {
			trace(this + " : " + $trace);
		}
		
	}
	
	public function toString():String
	{
		return "[" + this._strClassName + "]";
	}
}
