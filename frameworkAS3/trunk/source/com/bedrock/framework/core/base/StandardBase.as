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
package com.bedrock.framework.core.base
{
	import com.bedrock.framework.core.logging.ILogable;
	import com.bedrock.framework.core.logging.LogLevel;
	import com.bedrock.framework.core.logging.Logger;

	public class StandardBase implements ILogable
	{
		/*
		Constructor
		*/
		public function StandardBase()
		{
		}
		/*
		Logging Functions
	 	*/
		private function _log( $trace:*, $category:int ):void
		{
			Logger.log( $trace, $category );
		}
		public function status($trace:*):void
		{
			this._log( $trace, LogLevel.STATUS );
		}
		public function debug($trace:*):void
		{
			this._log( $trace, LogLevel.DEBUG );
		}
		public function warning($trace:*):void
		{
			this._log( $trace, LogLevel.WARNING );
		}
		public function error($trace:*):void
		{
			this._log( $trace, LogLevel.ERROR );
		}
		public function fatal($trace:*):void
		{
			this._log( $trace, LogLevel.FATAL );
		}
		
	}
}