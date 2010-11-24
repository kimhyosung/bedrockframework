class com.bedrockframework.plugin.util.FormValidator extends com.bedrockframework.core.base.StaticWidget
{
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "FormValidator";
	/*
	Validate E-mail
	*/
	public static function isEmail($email):Boolean
	{
		if (typeof $email == "string") {
			if ($email.length < 6 || $email.indexOf(".") <= 0 || $email.indexOf(",") >= 0 || $email.indexOf(";") >= 0 || $email.indexOf(":") >= 0 || $email.indexOf("/") >= 0 || $email.indexOf(" ") >= 0 || $email.indexOf("@") <= 0 || $email.indexOf("@") != $email.lastIndexOf("@") || $email.lastIndexOf(".") < $email.indexOf("@") || $email.lastIndexOf(".") + 3 > $email.length) {
				return false;
			} else {
				return true;
			}
		} else {
			return false;
		}
	}
	/*
	Validate Number
	*/
	public static function isNumber($number):Boolean
	{
		var numNumber:Number = Number($number);
		if (isNaN($number)) {
			return false;
		} else {
			return true;
		}
	}
	/*
	Validate String
	*/
	public static function isString($string):Boolean
	{
		if (typeof $string != "string") {
			return false;
		} else {
			return true;
		}
	}
	/*
	Validate if a field is blank
	*/
	public static function isBlank($var):Boolean
	{
		var strCheck:String = String($var);
		if (strCheck.length >= 1) {
			return false;
		} else {
			return true;
		}
	}
	/*
	Validate Number Range
	*/
	public static function isInRange($number:Number, $min:Number, $max:Number):Boolean
	{
		if ($number >= $min && $number <= $max) {
			return true;
		} else {
			return false;
		}
	}
	/*
	Validate String
	*/
	public static function isLength($var, $length:Number):Boolean
	{
		var strCheck:String = String($var);
		if (strCheck.length == $length) {
			return true;
		} else {
			return false;

		}
	}
}