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
package com.bedrock.framework.plugin.logging
{
	import com.bedrock.framework.core.logging.LogData;
	
	public class TraceService implements ILoggingService
	{
		/*
		Variable Delcarations
		*/
		private var _level:uint;
		private var _formatter:LogFormatter;
		/*
		Constructor
		*/
		public function TraceService()
		{
			
		}
		/*
		Creation Functions
		*/
		public function initialize( $logLevel:uint, $detailDepth:uint ):void
		{
			this.level = $logLevel;
			this._formatter = new LogFormatter( $detailDepth );
		}
		public function log( $trace:*, $data:LogData ):void
		{
			trace( this._formatter.format( $trace, $data ) );
		}
		
		
		public function set level( $level:uint ):void
		{
			this._level = $level;
		}
		public function get level():uint
		{
			return this._level;
		}
	}
}