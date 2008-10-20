package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.api.ILoadManager;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.ChainLoaderEvent;
	import com.bedrockframework.plugin.loader.ChainLoader;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	
	import flash.events.Event;

	public class LoadManager extends StandardWidget implements ILoadManager
	{
		/*
		Variable Declarations
		*/
		private var _objChainLoader:ChainLoader;
		private static var __objEventMap:HashMap;
		/*
		Constructor
		*/		
		
		
		public function LoadManager():void
		{
			this._objChainLoader = new ChainLoader();
			this.setupReplacements();
		}
		/*
		ChainLoader wrappers
		*/
		public function reset():void
		{
			this._objChainLoader.reset();
		}
		public function close():void
		{
			this._objChainLoader.close();
		}
		public function loadQueue():void
		{
			this._objChainLoader.loadQueue();
		}
		public function addToQueue($path:String,$loader:VisualLoader=null,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			this._objChainLoader.addToQueue($path,$loader,$completeHandler, $errorHandler);
		}
		public function getFile($index:int):String
		{
			return this._objChainLoader.getFile($index);
		}
		public function getLoader($index:int):*
		{
			return this._objChainLoader.getLoader($index);
		}
		/*
		Event Replacements
		*/
		private function setupReplacements():void
		{
			if (LoadManager.__objEventMap == null) {
				var arrChainEvents:Array=new Array("BEGIN","ERROR","COMPLETE","CLOSE","PROGRESS","NEXT","RESET", "FILE_ADDED", "FILE_OPEN","FILE_PROGRESS","FILE_COMPLETE","FILE_INIT","FILE_UNLOAD","FILE_ERROR","FILE_SECURITY_ERROR","FILE_HTTP_STATUS");
				var arrManagerEvents:Array=new Array("LOAD_BEGIN","LOAD_ERROR","LOAD_COMPLETE","LOAD_CLOSE","LOAD_PROGRESS","LOAD_NEXT","LOAD_RESET", "FILE_ADDED","FILE_OPEN","FILE_PROGRESS","FILE_COMPLETE","FILE_INIT","FILE_UNLOAD","FILE_ERROR","FILE_SECURITY_ERROR","FILE_HTTP_STATUS");
				LoadManager.__objEventMap=new HashMap;
				//
				var numLength:Number=arrChainEvents.length;
				for (var i:Number=0; i < numLength; i++) {
					LoadManager.__objEventMap.saveValue(ChainLoaderEvent[arrChainEvents[i]],BedrockEvent[arrManagerEvents[i]]);
				}
				this.setupListeners(arrChainEvents);
			}			
		}
		private function setupListeners($events:Array):void
		{
			var numLength:int = $events.length;
			for (var i:int = 0 ; i < numLength; i++) {
				this._objChainLoader.addEventListener(ChainLoaderEvent[$events[i]], this.onGenericHandler);
			}
		}
		private function onGenericHandler($event:Event):void
		{
			try {
				BedrockDispatcher.dispatchEvent(new BedrockEvent(LoadManager.__objEventMap.getValue($event.type),this,GenericEvent($event).details));
			} catch ($e:Error) {
				Logger.warning(this, "Unable to find matching event name replacement!");
			}
		}
		/*
		Property Definitions
		*/
		public function get running():Boolean 
		{
			return this._objChainLoader.running;
		}
	}

}