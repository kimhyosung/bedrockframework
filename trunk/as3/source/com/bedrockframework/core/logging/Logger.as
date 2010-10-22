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
package com.bedrockframework.core.logging
{
	import com.bedrockframework.core.base.StaticWidget;
	
	import flash.utils.Dictionary;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Logger extends StaticWidget
	{
		/*
		Variable Declarations
		*/
		public static var traceLevel:int = LogLevel.ALL;
		public static var eventLevel:int = LogLevel.ERROR;
		public static var remoteLevel:int = LogLevel.FATAL;
		public static var monsterLevel:int = LogLevel.NONE;
		
		public static var traceLogger:ILogger;
		public static var eventLogger:ILogger;
		public static var remoteLogger:IRemoteLogger;
		
		public static var errorsEnabled:Boolean = true;
		public static var detailDepth:uint = 10;
		
		private static var __bolInitialized:Boolean = false;
		private static var __dicColors:Dictionary;
		private static var __dicLabels:Dictionary;
		
		
		
		public static function initialize():void
		{
			Logger.__bolInitialized = true;
			Logger.createCategoryColors();
			Logger.createCategoryLabels();
			Logger.traceLogger = new TraceLogger( Logger.detailDepth );
			Logger.eventLogger = new EventLogger;
			Logger.remoteLogger = new RemoteLogger;
		}
		
		private static function createCategoryColors():void
		{
			Logger.__dicColors = new Dictionary;
			Logger.__dicColors[ LogLevel.STATUS.toString() ] = 0x33cc33;
			Logger.__dicColors[ LogLevel.DEBUG.toString() ] = 0x0033cc;
			Logger.__dicColors[ LogLevel.WARNING.toString() ] = 0xff9900;
			Logger.__dicColors[ LogLevel.ERROR.toString() ] = 0xcc0000;
			Logger.__dicColors[ LogLevel.FATAL.toString() ] = 0xff00ff;
		}
		private static function createCategoryLabels():void
		{
			Logger.__dicLabels = new Dictionary;
			Logger.__dicLabels[ LogLevel.STATUS.toString() ] = "Status";
			Logger.__dicLabels[ LogLevel.DEBUG.toString() ] = "Debug";
			Logger.__dicLabels[ LogLevel.WARNING.toString() ] = "Warning";
			Logger.__dicLabels[ LogLevel.ERROR.toString() ] = "Error";
			Logger.__dicLabels[ LogLevel.FATAL.toString() ] = "Fatal";
		}
		
		public static function log( $trace:*=null, $target:* = null, $category:int = 0 ):String
		{
			if ( !Logger.__bolInitialized ) Logger.initialize();
			if ($category >= Logger.remoteLevel) {
				Logger.remoteLogger.log( $trace, $target, $category );
			}
			if ($category >= Logger.eventLevel) {
				Logger.eventLogger.log( $trace, $target, $category );
			}
			if ($category >= Logger.monsterLevel ) {
				MonsterDebugger.trace( $target, $trace, Logger.getCategoryColor( $category ) );
			}
			
			if ($category >= Logger.traceLevel) {
				return Logger.traceLogger.log( $trace, $target, $category );
			}
			return null;
		}
		public static function status($trace:*=null, $target:* = null):String
		{
			return Logger.log($trace, $target, LogLevel.STATUS );
		}
		public static function debug($trace:*=null, $target:* = null):String
		{
			return Logger.log($trace, $target, LogLevel.DEBUG);
		}
		public static function warning($trace:*=null, $target:* = null):String
		{
			return Logger.log($target, LogLevel.WARNING, $trace );
		}
		public static function error($trace:*=null, $target:* = null):String
		{
			if ( Logger.errorsEnabled ) {
				Logger.log($trace, $target, LogLevel.ERROR);
				throw new Error( $trace.toString() );
			} else {
				return Logger.log($trace, $target, LogLevel.ERROR);
			}
		}
		public static function fatal($trace:*=null, $target:* = null):String		{
			return Logger.log($trace, $target, LogLevel.FATAL);
		}
		
		private static function getCategoryColor( $category:int ):Number
		{
			return Logger.__dicColors[ $category.toString() ];
		}
		public static function getCategoryLabel( $category:int ):String
		{
			return Logger.__dicLabels[ $category.toString() ];
		}
		
		public static function set remoteLogURL($url:String):void
		{
			Logger.remoteLogger.loggerURL = $url;
		}
	}
}
