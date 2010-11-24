class com.bedrockframework.plugin.util.TimeUtil extends com.bedrockframework.core.base.StaticWidget
{
	/*
	Class identifier string.
	*/
	private var _strClassName:String="TimeUtil";
	/*
	Returns formatted time within an object in string format.
	*/
	public static  function getDisplayTime($time:Object):Object
	{
		var objTemp:Object=new Object  ;
		objTemp.minutes=TimeUtil.getDisplayMinutes($time.minutes);
		objTemp.seconds=TimeUtil.getDisplaySeconds($time.seconds);
		objTemp.milliseconds=TimeUtil.getDisplayMilliseconds($time.milliseconds);
		return objTemp;
	}
	/*
	Returns formatted minutes as a string.
	*/
	public static  function getDisplayMinutes($minutes:Number):String
	{
		var strMinutes:String=$minutes.toString();
		if ($minutes < 10) {
			strMinutes="0" + strMinutes;
		} else if (strMinutes == "60") {
			strMinutes="00";
		}
		return strMinutes;
	}
	/*
	Returns formatted seconds as a string.
	*/
	public static  function getDisplaySeconds($seconds:Number):String
	{
		var strSeconds:String=$seconds.toString();
		if ($seconds < 10) {
			strSeconds="0" + strSeconds;
		} else if (strSeconds == "60") {
			strSeconds="00";
		}
		return strSeconds;
	}
	/*
	Returns formatted milliseconds as a string.
	*/
	public static  function getDisplayMilliseconds($milliseconds:Number):String
	{
		var strMilliseconds:String=$milliseconds.toString();
		if ($milliseconds < 10) {
			strMilliseconds="000" + strMilliseconds;
		} else if ($milliseconds < 100) {
			strMilliseconds="00" + strMilliseconds;
		} else if ($milliseconds < 1000) {
			strMilliseconds="0" + strMilliseconds;
		}
		return strMilliseconds;
	}
	/*
	Parse getTimer() function into minutes, seconds and millseconds.
	Returns parsed time within an object in numerical format.
	*/
	public static function parseMilliseconds($milliseconds:Number):Object
	{
		var numElapsedTime:Number=$milliseconds;
		// Calculate Milliseconds
		var numElapsedMilliseconds:Number=numElapsedTime % 1000;
		// Calculate Minutes
		var numElapsedMinutes:Number=Math.floor(Math.floor(numElapsedTime / 1000) / 60);
		// Calculate Seconds
		if (numElapsedMinutes != 0) {
			var numElapsedSeconds:Number=Math.floor(Math.floor(numElapsedTime / 1000) - numElapsedMinutes * 60);
		} else {
			var numElapsedSeconds:Number=Math.floor(numElapsedTime / 1000);
		}
		// Return the resulting object
		return {minutes:numElapsedMinutes,seconds:numElapsedSeconds,milliseconds:numElapsedMilliseconds,total:numElapsedTime};
	}
}