package com.autumntactics.bedrock.base
{
	import com.autumntactics.bedrock.logging.ILogable;
	import com.autumntactics.bedrock.logging.LogLevel;
	import com.autumntactics.bedrock.logging.Logger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class DispatcherWidget extends EventDispatcher implements IEventDispatcher, ILogable
	{
		/*
		Variable Declarations
		*/	
		private var bolSilenceLogging:Boolean;
		/*
		Constructor
		*/
		public function DispatcherWidget($silenceConstruction:Boolean = true)
		{
			this.bolSilenceLogging = false;
			if ($silenceConstruction) {
				this.log(LogLevel.CONSTRUCTOR, "Constructed");
			}
		}
		/*
		Overrides adding additional functionality
		*/
		override public  function dispatchEvent($event:Event):Boolean
		{
			return super.dispatchEvent($event);
		}
		override public  function addEventListener($type:String,$listener:Function,$capture:Boolean=false,$priority:int=0,$weak:Boolean=true):void
		{
			super.addEventListener($type,$listener,$capture,$priority,$weak);
		}
		/*
		Logging Functions
	 	*/
		public function log($level:int, ...$arguments):void
		{
			if (!this.bolSilenceLogging) {
				Logger.log(this, $level, $arguments);
			}
		}
		
		public function debug(...$arguments):void
		{
			this.log(LogLevel.DEBUG, $arguments);
		}
		
		public function error(...$arguments):void
		{
			this.log(LogLevel.ERROR, $arguments);
		}
		
		public function fatal(...$arguments):void
		{
			this.log(LogLevel.FATAL, $arguments);
		}
		
		public function status(...$arguments):void
		{
			this.log(LogLevel.STATUS, $arguments);
		}
		
		public function warning(...$arguments):void
		{
			this.log(LogLevel.WARNING, $arguments);
		}
		/*
		Property Definitions
	 	*/
		public function set silenceLogging($value:Boolean):void
		{
			this.bolSilenceLogging=$value;
		}
		public function get silenceLogging():Boolean
		{
			return this.bolSilenceLogging;
		}
	}
}