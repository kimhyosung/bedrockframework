package com.bedrockframework.plugin.util
{
	import com.bedrockframework.core.base.StaticWidget;

	public class TimeUtil extends StaticWidget
	{
		public static function getDisplayTime($time:Object):Object
		{
			var objTemp:Object=new Object;
			objTemp.minutes=TimeUtil.getDisplayMinutes($time.minutes);
			objTemp.seconds=TimeUtil.getDisplaySeconds($time.seconds);
			objTemp.milliseconds=TimeUtil.getDisplayMilliseconds($time.milliseconds);
			return objTemp;
		}
		/*
		Returns formatted minutes as a string.
		*/
		public static function getDisplayMinutes($minutes:Number):String
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
		public static function getDisplaySeconds($seconds:Number):String
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
		public static function getDisplayMilliseconds($milliseconds:Number):String
		{
			var strMilliseconds:String=$milliseconds.toString();
			if ($milliseconds < 10) {
				strMilliseconds=TimeUtil.getZeros(2) + strMilliseconds;
			} else if ($milliseconds < 100) {
				strMilliseconds=TimeUtil.getZeros(1) + strMilliseconds;
			} else if ($milliseconds < 1000) {
				strMilliseconds=TimeUtil.getZeros(0) + strMilliseconds;
			}
			return strMilliseconds;
		}
		private static function getZeros($total:Number = 0):String
		{
			var strZeros:String = "";
			var numLength:int = $total;
			for (var i:int = 0 ; i < numLength; i++) {
				strZeros += "0";
			}
			return strZeros;
		}
		/*
		Parse getTimer() function into minutes, seconds and millseconds.
		Returns parsed time within an object in numerical format.
		*/
		public static function parseMilliseconds($milliseconds:uint):Object
		{
			var numElapsedTime:uint=$milliseconds;
			// Calculate Milliseconds
			var numElapsedMilliseconds:uint=numElapsedTime % 1000;
			// Calculate Minutes
			var numElapsedMinutes:uint=Math.floor(Math.floor(numElapsedTime / 1000) / 60);
			// Calculate Seconds
			var numElapsedSeconds:uint
			if (numElapsedMinutes != 0) {
				numElapsedSeconds=Math.floor(Math.floor(numElapsedTime / 1000) - numElapsedMinutes * 60);
			} else {
				numElapsedSeconds=Math.floor(numElapsedTime / 1000);
			}
			// Return the resulting object
			return {minutes:numElapsedMinutes,seconds:numElapsedSeconds,milliseconds:numElapsedMilliseconds,total:numElapsedTime};
		}
		
		public static function parseSeconds( $seconds:Number ):Object
		{
			var numElapsedTime:Number = $seconds;
			
			var numElapsedSeconds:uint=numElapsedTime % 60;
			var numElapsedMinutes:uint=Math.floor( numElapsedTime / 60);
			var numElapsedMilliseconds:uint=numElapsedTime - Math.round( numElapsedTime );
			return {minutes:numElapsedMinutes,seconds:numElapsedSeconds,milliseconds:numElapsedMilliseconds,total:numElapsedTime};
		}
	}
}