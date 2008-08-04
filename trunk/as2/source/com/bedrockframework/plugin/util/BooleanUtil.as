class com.bedrockframework.plugin.util.BooleanUtil extends com.bedrockframework.core.base.StaticWidget
{
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "BooleanUtil";
	/*
	Sanitize Boolean
	*/
	static function sanitize($boolean):Boolean
	{
		switch ($boolean.toLowerCase()) {
			case "true" :
				return true;
				break;
			case "false" :
				return false;
				break;
			default :
				trace("[" + this._strClassName + "] : No Change to Boolean!!!");
				break;
		}
	}
	/*
	Toggle Boolean
	*/
	static function toggle($boolean:Boolean):Boolean
	{
		if ($boolean == true) {
			return false;
		} else {
			return true;
		}
	}
}