class com.bedrockframework.plugin.util.StringUtil extends com.bedrockframework.core.base.StaticWidget {
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "StringUtil";
	/*
	Splits a string into an array according to a specified length.
	*/
	public static function segment($text:String, $linelength:Number):Array {
		var strFullText:String = $text;
		var numLineLength:Number = $linelength;
		var arrLines:Array = new Array();
		var arrText:Array = strFullText.split(" ");
		var numLine:Number = 0;
		var strTemp:String = arrText[0];
		var numLength:Number = strTemp.length + 1;
		arrLines[numLine] = arrText[0];
		for (var t:Number = 1; t < arrText.length; t++) {
			if ((numLength + arrText[t].length) > numLineLength) {
				arrLines.push(strTemp);
				numLine++;
				strTemp = arrText[t];
				numLength = strTemp.length + 1;
				arrLines[numLine] = arrText[t];
			} else {
				strTemp = strTemp + " " + arrText[t];
				numLength = strTemp.length + 1;
				arrLines[numLine] = arrLines[numLine] + " " + arrText[t];
			}
		}
		return arrLines;
	}
	/*
	Replace charaters in a string.
	*/
	public static function replace($string:String, $find:String, $replace:String):String {
		var strResult:String = $string;
		return strResult.split($find).join($replace);
	}
	/*
	Capitalizes a word
	*/
	public static function capitalize($text:String):String {
		var strText:String = $text;
		var strFirst:String = strText.charAt(0).toUpperCase();
		var strRest:String = (strText.substring(1, strText.length));
		return strFirst + strRest;
	}
	/*
	Convert number to string
	*/
	public static function generateString($number:Number, $places:Number):String {
		var strNumber:String = $number.toString();
		var numLength:Number = $places - strNumber.length;
		//
		for (var i = 0; i < numLength; i++) {
			strNumber = "0" + strNumber;
		}
		return strNumber;
	}
	/*
	
	*/
	public static function elipse($string:String, $index:Number) {
		return $string.substr(0, $index) + "...";
	}
	/*
	
	*/
	public static function generatePossessiveNoun($noun:String):String {
		if ($noun.charAt($noun.length - 1).toLowerCase() != "s") {
			return $noun + "'s";
		} else {
			return $noun + "'";
		}
	}
}
