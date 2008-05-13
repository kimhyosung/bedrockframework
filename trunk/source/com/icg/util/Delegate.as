package com.icg.util
{
	import com.icg.madagascar.base.StaticWidget;
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