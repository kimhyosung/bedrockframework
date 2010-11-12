﻿/**
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
		private function log( $trace:*, $category:int ):String
		{
			return Logger.log( $trace, this, $category );
		}
		public function status($trace:*):String
		{
			return this.log( $trace, LogLevel.STATUS );
		}
		public function debug($trace:*):String
		{
			return this.log( $trace, LogLevel.DEBUG );
		}
		public function warning($trace:*):String
		{
			return this.log( $trace, LogLevel.WARNING );
		}
		public function error($trace:*):String
		{
			return this.log( $trace, LogLevel.ERROR );
		}
		public function fatal($trace:*):String
		{
			return this.log( $trace, LogLevel.FATAL );
		}
		
	}
}