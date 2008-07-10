﻿/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@autumntactics.com
 * website: http://www.autumntactics.com/
 * blog: http://blog.autumntactics.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.core.base
{
	import com.bedrockframework.core.logging.ILogable;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.core.logging.LogLevel;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MovieClipWidget extends MovieClip implements ILogable
	{
		/*
		Variable Declarations
		*/	
		private var _bolSilenceLogging:Boolean;
		/*
		Constructor
		*/
		public function MovieClipWidget($silenceConstruction:Boolean = false)
		{
			super();
			this._bolSilenceLogging = false;
			if (!$silenceConstruction) {
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
	 	private function sendLogMessage($level:int, $arguments:Array):void
		{
			if (!this._bolSilenceLogging) {
				Logger.send(this, $level, $arguments);
			}
		}
		public function log($level:int, ...$arguments:Array):void
		{
			this.sendLogMessage($level, $arguments);
		}
		
		public function debug(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.DEBUG, $arguments);
		}
		
		public function error(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.ERROR, $arguments);
		}
		
		public function fatal(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.FATAL, $arguments);
		}
		
		public function status(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.STATUS, $arguments);
		}
		
		public function warning(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.WARNING, $arguments);
		}
		/*
		Property Definitions
	 	*/
		public function set silenceLogging($value:Boolean):void
		{
			this._bolSilenceLogging=$value;
		}
		public function get silenceLogging():Boolean
		{
			return this._bolSilenceLogging;
		}
	}
}