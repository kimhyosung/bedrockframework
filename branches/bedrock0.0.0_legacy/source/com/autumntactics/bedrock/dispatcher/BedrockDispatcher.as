package com.autumntactics.bedrock.dispatcher
{
	import com.autumntactics.bedrock.base.StaticWidget;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.logging.LogLevel;
	import com.autumntactics.bedrock.logging.Logger;
	
	import flash.events.EventDispatcher;

	public class BedrockDispatcher extends StaticWidget
	{
		Logger.log(BedrockDispatcher, LogLevel.CONSTRUCTOR, "Constructed");
		/*
		Variable Declarations
		*/
		private static  var OBJ_EVENT_DISPATCHER:EventDispatcher = new EventDispatcher();
		/*
		Dispatch Event
		*/
		public static function dispatchEvent($event:GenericEvent):Boolean
		{			
			return BedrockDispatcher.OBJ_EVENT_DISPATCHER.dispatchEvent($event);
		}
		/*
		Write something descriptive.
		*/
		public static function addEventListener($type:String, $listener:Function, $capture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void
		{
			BedrockDispatcher.OBJ_EVENT_DISPATCHER.addEventListener($type, $listener, $capture, $priority, $weak);
		}
		public static function removeEventListener($type:String, $listener:Function, $capture:Boolean = false):void
		{
			BedrockDispatcher.OBJ_EVENT_DISPATCHER.removeEventListener($type, $listener, $capture);
		}
		public static function hasEventListener($type:String):void
		{
			BedrockDispatcher.OBJ_EVENT_DISPATCHER.hasEventListener($type);
		}
		public static function willTrigger($type:String):void
		{
			BedrockDispatcher.OBJ_EVENT_DISPATCHER.willTrigger($type);
		}
	}
}