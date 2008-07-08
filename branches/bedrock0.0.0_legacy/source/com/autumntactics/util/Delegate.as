package com.autumntactics.util
{
	import com.autumntactics.bedrock.base.StaticWidget;
	import flash.events.Event;
	public class Delegate extends StaticWidget
	{
		public static function create($function:Function, ... $arguments):Function
		{
			var fnTemp:Function = function($event:Event):void{
				$function.apply(null, [$event].concat($arguments));
			};
			return fnTemp;
		}
	}
}