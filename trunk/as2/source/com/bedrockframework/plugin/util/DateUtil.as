class com.bedrockframework.plugin.util.DateUtil extends com.bedrockframework.core.base.StaticWidget {
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "DateUtil";
	/*
	Is Past
	*/
	public static function isPast($compare, $current:Date) {
		var objCurrent:Date = $current || new Date();
		//
		if (typeof ($compare) == "string") {
			var strDate:String = $compare.charAt(3) + $compare.charAt(4);
			var strMonth:String = $compare.charAt(0) + $compare.charAt(1);
			var strYear:String = $compare.substring(6, $compare.length);
			//
			var numDate:Number = new Number(strDate);
			var numMonth:Number = (new Number(strMonth)) - 1;
			var numYear:Number = new Number(strYear);
			//
			var objCompare:Date = new Date(numYear, numMonth, numDate);
		} else {
			var objCompare:Date = $compare;
		}
		// 
		if (objCompare.getFullYear() <= objCurrent.getFullYear()) {
			if (objCompare.getMonth() <= objCurrent.getMonth()) {
				if (objCompare.getDate() <= objCurrent.getDate()) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
}
