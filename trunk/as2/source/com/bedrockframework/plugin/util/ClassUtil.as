class com.bedrockframework.plugin.util.ClassUtil extends com.bedrockframework.core.base.StaticWidget {
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "ClassUtil";
	/*
	Sets property flags for properties of an object.
	
	Can be used to...
	- Hide objects children from the for..in loop construct
	- Un-hide objects children to the mercy of the for..in loop construct
	- Protect objects children from being over-written
	- Un-Protect objects children from being over-written
	- Protect objects children from being deleted
	- Un-Protect objects children from being deleted
	
	*/
	public static function setFlags($target:Object, $properties:Array, $flags:Object, $override:Boolean):Void {
		var numFlag:Number = ClassUtil.getVisibility($flags);
		var bolAllowOverride:Boolean = $override || false;
		_global.ASSetPropFlags($target, $properties, numFlag, bolAllowOverride);
	}
	private static function getVisibility($flags:Object):Number {
		var numFlag:Number;
		var objFlags:Object = $flags;
		//
		if (objFlags.overwrite == undefined) {
			objFlags.overwrite = true;
		}
		//    
		if (objFlags.overwrite && objFlags.invisible) {
			numFlag = 3;
		} else if (!objFlags.overwrite && !objFlags.invisible) {
			numFlag = 6;
		} else if (objFlags.overwrite && !objFlags.invisible) {
			numFlag = 2;
		} else if (!objFlags.overwrite && objFlags.invisible) {
			numFlag = 7;
		}
		return numFlag;
	}
}
