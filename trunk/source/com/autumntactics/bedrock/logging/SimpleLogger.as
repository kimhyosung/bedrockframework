package com.autumntactics.bedrock.logging
{
	import com.autumntactics.bedrock.logging.ILogable;
	import com.autumntactics.bedrock.logging.LogLevel;
	import com.autumntactics.bedrock.logging.Logger;

	public class SimpleLogger implements ILogable
	{
		public function SimpleLogger()
		{
		}

		public function log($level:int, ...$arguments):void
		{
			Logger.log(this, $level, $arguments);
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
		
		public function set silenceLogging($value:Boolean):void
		{
		}
		public function get silenceLogging():Boolean
		{
			return false;
		}
	}
}