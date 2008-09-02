package com.builtonbedrock.util
{
	import com.builtonbedrock.bedrock.base.StaticWidget;

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