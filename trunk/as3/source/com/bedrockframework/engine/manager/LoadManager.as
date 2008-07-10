package com.bedrockframework.engine.manager
{
	import com.bedrockframework.plugin.event.ChainLoaderEvent;
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.plugin.storage.SimpleMap;
	import com.bedrockframework.plugin.loader.ChainLoader;
	import com.bedrockframework.plugin.loader.VisualLoader;
	
	import flash.events.Event;

	public class LoadManager extends StaticWidget
	{
		/*
		Variable Declarations
		*/
		private static var OBJ_CHAIN_LOADER:ChainLoader;
		
		Logger.log(LoadManager, LogLevel.CONSTRUCTOR, "Constructed");
		
		private static var OBJ_EVENT_MAP:SimpleMap;

		public static function initialize():void
		{
			LoadManager.OBJ_CHAIN_LOADER = new ChainLoader();
			LoadManager.setupReplacements();
		}
		/*
		ChainLoader wrappers
		*/
		public static function reset():void
		{
			LoadManager.OBJ_CHAIN_LOADER.reset();
		}
		public static function close():void
		{
			LoadManager.OBJ_CHAIN_LOADER.close();
		}
		public static function loadQueue():void
		{
			LoadManager.OBJ_CHAIN_LOADER.loadQueue();
		}
		public static function addToQueue($path:String,$loader:VisualLoader=null,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			LoadManager.OBJ_CHAIN_LOADER.addToQueue($path,$loader,$completeHandler, $errorHandler);
		}
		public static function getFile($index:int):String
		{
			return LoadManager.OBJ_CHAIN_LOADER.getFile($index);
		}
		public static function getLoader($index:int):*
		{
			return LoadManager.OBJ_CHAIN_LOADER.getLoader($index);
		}
		/*
		Event Replacements
		*/
		private static function setupReplacements():void
		{
			var arrChainEvents:Array=new Array("BEGIN","ERROR","COMPLETE","CLOSE","PROGRESS","NEXT","RESET", "FILE_ADDED", "FILE_OPEN","FILE_PROGRESS","FILE_COMPLETE","FILE_INIT","FILE_UNLOAD","FILE_ERROR","FILE_SECURITY_ERROR","FILE_HTTP_STATUS");
			var arrManagerEvents:Array=new Array("LOAD_BEGIN","LOAD_ERROR","LOAD_COMPLETE","LOAD_CLOSE","LOAD_PROGRESS","LOAD_NEXT","LOAD_RESET", "FILE_ADDED","FILE_OPEN","FILE_PROGRESS","FILE_COMPLETE","FILE_INIT","FILE_UNLOAD","FILE_ERROR","FILE_SECURITY_ERROR","FILE_HTTP_STATUS");
			LoadManager.OBJ_EVENT_MAP=new SimpleMap;
			//
			var numLength:Number=arrChainEvents.length;
			for (var i:Number=0; i < numLength; i++) {
				LoadManager.OBJ_EVENT_MAP.saveValue(ChainLoaderEvent[arrChainEvents[i]],BedrockEvent[arrManagerEvents[i]]);
			}
			LoadManager.setupListeners(arrChainEvents);
		}
		private static function setupListeners($events:Array):void
		{
			var numLength:int = $events.length;
			for (var i:int = 0 ; i < numLength; i++) {
				LoadManager.OBJ_CHAIN_LOADER.addEventListener(ChainLoaderEvent[$events[i]], LoadManager.onGenericHandler);
			}
		}
		private static function onGenericHandler($event:Event):void
		{
			try {
				BedrockDispatcher.dispatchEvent(new BedrockEvent(LoadManager.OBJ_EVENT_MAP.getValue($event.type),LoadManager,GenericEvent($event).details));
			} catch ($e:Error) {
				Logger.warning(LoadManager, "Unable to find matching event name replacement!");
			}
		}
		/*
		Property Definitions
		*/
		public static function get running():Boolean 
		{
			return LoadManager.OBJ_CHAIN_LOADER.running;
		}
	}

}