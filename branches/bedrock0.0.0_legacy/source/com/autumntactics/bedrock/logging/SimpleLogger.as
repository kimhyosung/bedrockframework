package com.builtonbedrock.bedrock.logging
{
	import com.builtonbedrock.bedrock.logging.ILogable;
	import com.builtonbedrock.bedrock.logging.LogLevel;
	import com.builtonbedrock.bedrock.logging.Logger;

	public class SimpleLogger implements ILogable
	{
		public function SimpleLogger()
		{
		}

		public function log($level:int, ...$arguments):void
		{
			Logger.send(this, $level, $arguments);
		}
		
		public function debug(...$arguments):void
		{
			Logger.send(this, LogLevel.DEBUG, $arguments);
		}
		
		public function error(...$arguments):void
		{
			Logger.send(this, LogLevel.ERROR, $arguments);
		}
		
		public function fatal(...$arguments):void
		{
			Logger.send(this, LogLevel.FATAL, $arguments);
		}
		
		public function status(...$arguments):void
		{
			Logger.send(this, LogLevel.STATUS, $arguments);
		}
		
		public function warning(...$arguments):void
		{
			Logger.send(this, LogLevel.WARNING, $arguments);
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