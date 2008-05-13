package com.icg.madagascar.manager
{
	import com.icg.events.ChainLoaderEvent;
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.output.Outputter;
	import com.icg.storage.SimpleMap;
	import com.icg.tools.ChainLoader;
	import com.icg.tools.VisualLoader;
	
	import flash.events.Event;

	public class LoadManager extends StaticWidget
	{
		/*
		Variable Declarations
		*/
		private static var OBJ_CHAIN_LOADER:ChainLoader;
		private static  var OUTPUT:Outputter = new Outputter(LoadManager);
		
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
				LoadManager.OBJ_EVENT_MAP.set(ChainLoaderEvent[arrChainEvents[i]],MadagascarEvent[arrManagerEvents[i]]);
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
				MadagascarDispatcher.dispatchEvent(new MadagascarEvent(LoadManager.OBJ_EVENT_MAP.get($event.type),LoadManager,GenericEvent($event).details));
			} catch ($e:Error) {
				LoadManager.OBJ_CHAIN_LOADER.output("Unable to find matching event name replacement!", "warning");
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