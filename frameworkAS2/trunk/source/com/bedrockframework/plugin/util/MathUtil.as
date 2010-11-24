class com.bedrockframework.plugin.util.MathUtil extends com.bedrockframework.core.base.StaticWidget
{
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "MathUtil";
	/*
	Handle Array Indexing
	*/
	public static function wrapIndex($index:Number, $total:Number, $wrap:Boolean)
	{
		var numTotal:Number = $total;
		var bolWrap:Boolean = ($wrap != undefined) ? $wrap : true;
		if (bolWrap) {
			if ($index >= $total) {
				var numIndex:Number = $index;
				var numDifference:Number = Math.floor(numIndex / numTotal);
				//
				if (numDifference > 1) {
					var numRemainder:Number = numIndex % numTotal;
					return numRemainder;
				}
				return numIndex - numTotal;
			} else if ($index < 0) {
				var numIndex:Number = Math.abs($index);
				var numDifference:Number = Math.ceil(numIndex / numTotal);
				if (numDifference > 1) {
					var numRemainder:Number = numIndex % numTotal;
					if (numRemainder == 0) {
						return (numRemainder);
					} else {
						return (numTotal - numRemainder);
					}
				}
				return Math.abs((numTotal - numIndex));
			} else {
				return $index;
			}
		} else {
			if ($index >= numTotal) {
				return (numTotal - 1);
			} else if ($index < 0) {
				return 0;
			} else {
				return $index;
			}
		}
	}
	/*
	Get angle between 2 points
	*/
	public static function getAngle($x1:Number, $y1:Number, $x2:Number, $y2:Number):Number
	{
		var numXdelta:Number = $x2 - $x1;
		var numYdelta:Number = $y2 - $y1;
		var numAngle:Number = -(180 * Math.atan2(numYdelta, numXdelta)) / Math.PI;
		return (Math.round(numAngle));
	}
	/*
	Get distance between 2 points
	*/
	public static function distance($xPoint1:Number, $yPoint1:Number, $xPoint2:Number, $yPoint2:Number):Number
	{
		var distanceX:Number = $xPoint2 - $xPoint1;
		var distanceY:Number = $yPoint2 - $yPoint1;
		return Math.sqrt((distanceX * distanceX) + (distanceY * distanceY));
	}
	/*
	Convert Degrees to Radians
	*/
	public static function degreesToRadians($angle:Number):Number
	{
		return $angle * (Math.PI / 180);
	}
	/*
	Convert Radians to Degrees
	*/
	public static function radiansToDegrees($angle:Number):Number
	{
		return $angle * (180 / Math.PI);
	}
	

	/*
	Is Odd
	*/
	public static function isOdd($number:Number):Boolean
	{
		if ($number % 2 == 0) {
			return false;
		} else {
			return true;
		}
	}
	/*
	Is Even
	*/
	public static function isEven($number:Number):Boolean
	{
		if ($number % 2 == 0) {
			return true;
		} else {
			return false;
		}
	}
	/*
	Get sign
	*/
	public static function getSign($number:Number):Number
	{
		return $number / Math.abs($number);
	}
	/*
	Generate a random number in range
	*/
	public static function random($maximum:Number, $minimum:Number):Number
	{
		var numMinimum:Number = $minimum || 0;
		var numRandom:Number = Math.floor(Math.random() * ((($maximum - 1) - numMinimum) + 1)) + numMinimum;
		return numRandom;
	}
	public static function randomWithDecimal($maximum:Number, $minimum:Number)
	{
		var numRandom:Number = MathUtil.random($maximum, $minimum);
		
		return numRandom + Math.random();
	}

	/*
	Random no repeat
	*/
	public static function randomNoRepeat($current:Number, $maximum:Number, $minimum:Number):Number
	{
		var numTemp:Number = $current;
		do {
			numTemp = MathUtil.random($maximum, $minimum);
		} while (numTemp == $current);
		return numTemp;
	}
	/* 
	Extracts numbers from a string. Returns a number. 
	*/
	public static function extractNumbers($str:String):Number
	{
		var strLength:Number = $str.length;
		var strNumber:String = "";
		for (var i = 0; i < strLength; i++) {
			if (isNaN($str.charAt(i)) == false) {
				strNumber += $str.charAt(i);
			}
		}
		return Number(strNumber);
	}
}