package com.bedrock.framework.plugin.util
{
	import flash.utils.*;
	
	public class MathUtil
	{
		/*
		Get angle between 2 points
		*/
		public static function maintainRange( $value:Number, $min:Number, $max:Number, $wrap:Boolean = true ) {
			var offset:Number = ( $min < 0 ) ? Math.abs( $min ) : -$min;
			var result:Number;
			
			var comparisonValue:Number = $value + offset;
			var maxValue:Number;
			var minValue:Number;
			if ( $wrap ) {
				maxValue = ( $max + offset ) + 1;
				minValue = -1;
				if (comparisonValue >= maxValue) {
					result = ( comparisonValue % maxValue );
				} else if ( comparisonValue <= minValue ) {
					result = ( maxValue + ( comparisonValue % maxValue ) );
				} else {
					result = comparisonValue;
				}
			} else {
				maxValue = ( $max + offset );
				minValue = 0;
				if (comparisonValue >= maxValue) {
					result = maxValue;
				} else if ( comparisonValue <= minValue ) {
					result = minValue;
				} else {
					result = comparisonValue;
				}
			}
			result -= offset;
			return result;
		}
		/*
		Get angle between 2 points
		*/
		public static  function getAngle($x1:Number,$y1:Number,$x2:Number,$y2:Number):Number
		{
			var deltaX:Number=$x2 - $x1;
			var deltaY:Number=$y2 - $y1;
			var angle:Number=-180 * Math.atan2(deltaY,deltaX) / Math.PI;
			return ( Math.round(angle) );
		}
		/*
		Get distance between 2 points
		*/
		public static  function getDistance($xPoint1:Number,$yPoint1:Number,$xPoint2:Number,$yPoint2:Number):Number
		{
			var distanceX:Number=$xPoint2 - $xPoint1;
			var distanceY:Number=$yPoint2 - $yPoint1;
			return Math.sqrt(distanceX * distanceX + distanceY * distanceY);
		}
		/*
		Convert Degrees to Radians
		*/
		public static  function degreesToRadians($angle:Number):Number
		{
			return $angle * Math.PI / 180;
		}
		/*
		Convert Radians to Degrees
		*/
		public static  function radiansToDegrees($angle:Number):Number
		{
			return $angle * 180 / Math.PI;
		}
		/*
		Is Odd
		*/
		public static  function isOdd($number:Number):Boolean
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
		public static  function isEven($number:Number):Boolean
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
		public static  function getSign($number:Number):Number
		{
			return ($number == 0) ? 1 : $number / Math.abs($number);
		}
		/*
		Generate a random number in range
		*/
		public static  function random($maximum:Number,$minimum:Number=0,$decimal:Boolean=false):Number
		{
			var numRandom:Number = ($decimal) ? (Math.random() * ($maximum - $minimum)) + $minimum : Math.floor(Math.random() * ($maximum - $minimum)) + $minimum;
			return numRandom;
		}
		public static  function randomRange($minimum:Number,$maximum:Number,$decimal:Boolean=false):Number
		{
			return MathUtil.random($maximum, $minimum, $decimal);
		}
		/*
		Random no repeat
		*/
		public static  function randomNoRepeat($current:Number,$maximum:Number,$minimum:Number=0,$decimal:Boolean=false):Number
		{
			var numTemp:Number=$current;
			if( $maximum <= 1 ) return $current;
			do {
				numTemp=MathUtil.random($maximum, $minimum, $decimal);
			} while (numTemp == $current);
			return numTemp;
		}

		public static  function calculatePercentage($smaller:Number,$larger:Number):Number
		{
			return Math.round( ($smaller / $larger) * 100 );
		}
		
		public static function getPercentageOfValue(  $value:Number, $percentage:Number ):Number
		{
			return ( $value * ( $percentage / 100 ) );
		}
		
		public static function calculateRatio($value1:Number,$value2:Number):Number
		{
			return ($value1 / $value2);
		}
		
		
	}
}