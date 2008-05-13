package com.icg.madagascar.dispatcher
{
	import flash.events.EventDispatcher;
	import com.icg.madagascar.events.GenericEvent;
	import flash.events.Event;
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.madagascar.output.Outputter;

	public class MadagascarDispatcher extends StaticWidget
	{
		/*
		Variable Declarations
		*/
		private static  var OBJ_EVENT_DISPATCHER:EventDispatcher = new EventDispatcher();
		private static  var BOL_OUTPUT_EVENTS:Boolean = false;
		private static  var OUTPUT:Outputter;
		/*
		
		
		Static wrappers for public EventDispatcher functions
		
		
		*/
		public static function initialize():void
		{
			MadagascarDispatcher.OUTPUT = new Outputter(MadagascarDispatcher);
		}
		/*
		Dispatch Event
		*/
		public static function dispatchEvent($event:GenericEvent):Boolean
		{			
			return OBJ_EVENT_DISPATCHER.dispatchEvent($event);
		}
		/*
		Write something descriptive.
		*/
		public static function addEventListener($type:String, $listener:Function, $capture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void
		{
			OBJ_EVENT_DISPATCHER.addEventListener($type, $listener, $capture, $priority, $weak);
		}
		public static function removeEventListener($type:String, $listener:Function, $capture:Boolean = false):void
		{
			OBJ_EVENT_DISPATCHER.removeEventListener($type, $listener, $capture);
		}
		public static function hasEventListener($type:String):void
		{
			OBJ_EVENT_DISPATCHER.hasEventListener($type);
		}
		public static function willTrigger($type:String):void
		{
			OBJ_EVENT_DISPATCHER.willTrigger($type);
		}
		/*
		Output Events
		*/
		public static function set outputEvents($status:Boolean):void
		{
			BOL_OUTPUT_EVENTS = $status;
		}
		public static function get outputEvents():Boolean
		{
			return BOL_OUTPUT_EVENTS;
		}
	}
}