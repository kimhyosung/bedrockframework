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
	import com.bedrock.framework.core.logging.IRemoteLogger;
	import com.bedrock.framework.core.logging.LogData;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class RemoteLogger implements IRemoteLogger
	{
		/*
		Variable Declarations
		*/
		public var connection:URLLoader;
		public var request:URLRequest;
		private var _level:uint;
		/*
		Constructor
		*/
		public function RemoteLogger( $logLevel:uint, $loggerURL:String )
		{
			this.level = $logLevel;
			this.connection = new URLLoader;
			this.request = new URLRequest();
			this.loggerURL = $loggerURL;
		}

		public function log( $trace:*, $data:LogData ):void
		{
			if (this.request.url != null) {
				this.connection.load( this.request );
			}
		}
		/*
		Property Definitions
	 	*/
		public function set loggerURL($url:String):void
		{
			this.request.url = $url;
		}
		public function get loggerURL():String
		{
			return this.request.url;
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