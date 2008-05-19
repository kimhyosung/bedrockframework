package com.autumntactics.bedrock.base
{
	import com.autumntactics.bedrock.logging.ILogable;
	import com.autumntactics.bedrock.logging.ILogable;
	import com.autumntactics.bedrock.logging.LogLevel;
	import com.autumntactics.bedrock.logging.Logger;
	import com.autumntactics.util.ClassUtil;

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