package com.autumntactics.util
{
	import com.autumntactics.bedrock.base.StaticWidget;

	public class DateUtil extends StaticWidget
	{
		public static function isLeapYear($year:Number):Boolean
  		{
			if( $year % 100 == 0 ){
				return $year % 400 == 0;
			}
			return $year % 4 == 0;
		}
	}
}