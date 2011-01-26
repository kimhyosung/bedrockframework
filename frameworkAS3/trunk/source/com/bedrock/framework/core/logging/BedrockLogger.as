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
package com.bedrock.framework.core.logging
{
	import com.bedrock.framework.plugin.logging.ILoggingService;
	import com.bedrock.framework.plugin.logging.TraceService;
	import com.bedrock.framework.plugin.storage.HashMap;
	
	public class BedrockLogger
	{
		/*
		Variable Declarations
		*/
		private static var __instance:BedrockLogger;
		public var errorsEnabled:Boolean = true;
		
		private var _initialized:Boolean = false;
		private var _available:Boolean;
		private var _servicesHash:HashMap;
		private var _servicesArray:Array;
		/*
		Constructor
	 	*/
	 	public function BedrockLogger( $singletonEnforcer:SingletonEnforcer )
		{
		}
		public static function get instance():BedrockLogger
		{
			if ( BedrockLogger.__instance == null ) {
				BedrockLogger.__instance = new BedrockLogger( new SingletonEnforcer );
			}
			return BedrockLogger.__instance;
		}
		public function initialize():void
		{
			this._initialized = true;
			this._servicesHash = new HashMap;
			
			var logger:ILoggingService = new TraceService;
			logger.initialize( LogLevel.ALL, 5 );
			this.addService( "trace", logger );
			
			this._available = this._getAvailability();
		}
		private function _getAvailability():Boolean
		{
			var error:Error = new Error;
			return ( error.getStackTrace() != null );
		}
		
		public function log( $trace:*=null, $level:int = 0 ):void
		{
			this._internalLog( $trace, $level );
		}
		private function _internalLog( $trace:*=null, $level:int = 0 ):void
		{
			if ( !this._initialized ) this.initialize();
			
			if ( this.available ) {
				var data:LogData = new LogData( new Error, $level );
				var loggerService:ILoggingService;
				
				for each( var item:Object in this._servicesHash ) {
					loggerService = item.service;
					if ( $level >= loggerService.level ) {
						loggerService.log( $trace, data );
					}
				}
			}
		}
		
		public function addService( $id:String, $service:ILoggingService ):void
		{
			if ( !this._initialized ) this.initialize();
			this._servicesHash.saveValue( $id, $service );
			this._servicesArray = this._servicesHash.getValues();
		}
		public function getService( $id:String ):ILoggingService
		{
			return this._servicesHash.getValue( $id );
		}
		public function hasService( $id:String ):Boolean
		{
			return this._servicesHash.containsKey( $id );
		}
		
		public function status( $trace:*=null ):void
		{
			this._internalLog( $trace, LogLevel.STATUS );
		}
		public function debug( $trace:*=null ):void
		{
			this._internalLog( $trace, LogLevel.DEBUG );
		}
		public function warning( $trace:*=null ):void
		{
			this._internalLog( $trace, LogLevel.WARNING );
		}
		public function error( $trace:*=null ):void
		{
			if ( this.errorsEnabled ) {
				this._internalLog( $trace, LogLevel.ERROR );
				throw new Error( $trace.toString() );
			} else {
				this._internalLog( $trace, LogLevel.ERROR );
			}
		}
		public function fatal( $trace:*=null ):void
		{
			this._internalLog( $trace, LogLevel.FATAL );
		}
		
		
		public function get available():Boolean
		{
			return this._available;
		}
	}
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}
