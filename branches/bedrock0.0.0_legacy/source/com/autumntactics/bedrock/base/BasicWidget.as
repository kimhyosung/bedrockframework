package com.builtonbedrock.bedrock.base
{
	import com.builtonbedrock.bedrock.logging.ILogable;
	import com.builtonbedrock.bedrock.logging.LogLevel;
	import com.builtonbedrock.bedrock.logging.Logger;

	public class BasicWidget implements ILogable
	{
		/*
		Variable Declarations
		*/	
		private var bolSilenceLogging:Boolean;
		/*
		Constructor
		*/
		public function BasicWidget()
		{
			this.bolSilenceLogging=false;
		}
		/*
		Logging Functions
	 	*/
		private function sendLogMessage($level:int, $arguments:Array):void
		{
			if (!this.bolSilenceLogging) {
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
			this.bolSilenceLogging=$value;
		}
		public function get silenceLogging():Boolean
		{
			return this.bolSilenceLogging;
		}
	}
}