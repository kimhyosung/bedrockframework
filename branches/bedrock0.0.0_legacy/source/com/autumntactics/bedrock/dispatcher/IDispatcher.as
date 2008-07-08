package com.autumntactics.bedrock.dispatcher
{
	import flash.events.Event;
	public interface IDispatcher
	{
		function dispatchEvent($event:Event):Boolean;
		function addEventListener($type:String, $listener:Function, $capture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void;
		function removeEventListener($type:String, $listener:Function, $capture:Boolean = false):void;
		function hasEventListener($type:String):void;
		function willTrigger($type:String):void;
	}
}