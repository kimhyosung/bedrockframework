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
	import com.bedrock.framework.core.event.LogEvent;
	import com.bedrock.framework.core.logging.LogData;
	import com.bedrock.framework.core.logging.LogLevel;
	import com.bedrock.framework.Bedrock;
	
	import flash.utils.Dictionary;

	public class EventService implements ILoggingService
	{
		private var _categoryDictionary:Dictionary;
		private var _level:uint;
		
		public function EventService()
		{
			this._createCategoryLabels();
			
		}
		
		private function _createCategoryLabels():void
		{
			this._categoryDictionary = new Dictionary;
			this._categoryDictionary[LogLevel.DEBUG.toString()] = LogEvent.DEBUG;
			this._categoryDictionary[LogLevel.ERROR.toString()] = LogEvent.ERROR;
			this._categoryDictionary[LogLevel.FATAL.toString()] = LogEvent.FATAL;
			this._categoryDictionary[LogLevel.STATUS.toString()] = LogEvent.STATUS;
			this._categoryDictionary[LogLevel.WARNING.toString()] = LogEvent.WARNING;
		}
		
		public function initialize( $logLevel:uint, $detailDepth:uint ):void
		{
			this.level = $logLevel;
		}
		public function log( $trace:*, $data:LogData ):void
		{
			Bedrock.dispatcher.dispatchEvent( new LogEvent( this._categoryDictionary[ $data.category ], this, $data ) );
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