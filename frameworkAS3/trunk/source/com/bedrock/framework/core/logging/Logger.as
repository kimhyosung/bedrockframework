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
	import com.bedrock.framework.core.base.StaticBase;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Logger extends StaticBase
	{
		/*
		Variable Declarations
		*/
		public static var errorsEnabled:Boolean = true;
		
		private static var __initialized:Boolean = false;
		private static var __available:Boolean;
		private static var __targets:Array;
		
		public static function initialize():void
		{
			Logger.__initialized = true;
			Logger.__targets = new Array;
			Logger.__available = Logger.__getAvailability();
		}
		private static function __getAvailability():Boolean
		{
			var error:Error = new Error;
			return ( error.getStackTrace() != null );
		}
		
		public static function log( $trace:*=null, $level:int = 0 ):void
		{
			if ( !Logger.__initialized ) Logger.initialize();
			
			if ( Logger.available ) {
				var data:LogData = new LogData( new Error, $level );
				
				for each( var logger:ILogger in Logger.__targets ) {
					if ( $level >= logger.level ) {
						logger.log( $trace, data );
					}
				}
			}
		}
		
		public static function addTarget( $target:ILogger ):void
		{
			Logger.__targets.push( $target );
		}
		
		public static function status( $trace:*=null ):void
		{
			Logger.log( $trace, LogLevel.STATUS );
		}
		public static function debug( $trace:*=null ):void
		{
			Logger.log( $trace, LogLevel.DEBUG );
		}
		public static function warning( $trace:*=null ):void
		{
			Logger.log( $trace, LogLevel.WARNING );
		}
		public static function error( $trace:*=null ):void
		{
			if ( Logger.errorsEnabled ) {
				Logger.log( $trace, LogLevel.ERROR );
				throw new Error( $trace.toString() );
			} else {
				Logger.log( $trace, LogLevel.ERROR );
			}
		}
		public static function fatal( $trace:*=null ):void
		{
			Logger.log( $trace, LogLevel.FATAL );
		}
		
		
		public static function get available():Boolean
		{
			return Logger.__available;
		}
	}
}
