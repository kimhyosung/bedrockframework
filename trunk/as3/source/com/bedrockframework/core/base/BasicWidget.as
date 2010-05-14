/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@builtonbedrock.com
 * website: http://www.builtonbedrock.com/
 * blog: http://blog.builtonbedrock.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.core.base
{
	import com.bedrockframework.core.logging.ILogable;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;

	public class BasicWidget implements ILogable
	{
		/*
		Variable Declarations
		*/	
		private var _bolSilenceLogging:Boolean;
		/*
		Constructor
		*/
		public function BasicWidget()
		{
			this._bolSilenceLogging=false;
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
		
		protected function log($level:int, ...$arguments:Array):void
		{
			this.sendLogMessage($level, $arguments);
		}
		protected function status(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.STATUS, $arguments);
		}
		protected function debug(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.DEBUG, $arguments);
		}
		protected function attention(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.ATTENTION, $arguments);
		}
		protected function warning(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.WARNING, $arguments);
		}
		protected function error(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.ERROR, $arguments);
		}
		protected function fatal(...$arguments:Array):void
		{
			this.sendLogMessage(LogLevel.FATAL, $arguments);
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