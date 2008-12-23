package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.ICopyManager;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.XMLUtil;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class CopyManager extends StandardWidget implements ICopyManager
	{
		/*
		Variable Declarations
		*/
		private var _objCopyMap:HashMap;
		private var _objBackgroundLoader:BackgroundLoader;
		/*
		Constructor
		*/
		public function CopyManager()
		{
		}
		public function initialize($language:String = null):void
		{
			this._objBackgroundLoader = new BackgroundLoader();
			this._objBackgroundLoader.addEventListener(LoaderEvent.COMPLETE, this.onXMLProcess);
			this._objBackgroundLoader.addEventListener(LoaderEvent.IO_ERROR, this.onXMLError);
			this._objBackgroundLoader.addEventListener(LoaderEvent.SECURITY_ERROR, this.onXMLError);
			this.loadXML($language);
		}
		public function loadXML($language:String = null):void
		{
			this._objBackgroundLoader.load(new URLRequest(this.getPath($language)));
		}
		
		private function parseXML($xml:String):void
		{
			var xmlCopy:XML = new XML($xml);
			this._objCopyMap = XMLUtil.convertToHashMap(xmlCopy);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.COPY_LOADED, this));
		}
		
		private function getPath($language:String = null):String
		{
			if ($language != null) {
				return BedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + "_" + $language + ".xml";
			} else {
				return BedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + ".xml";
			}
		}
		
		public function getCopy($key:String):String
		{
			try {
				return this._objCopyMap.getValue($key);
			} catch ($error:Error) {
			}
			return null;
		}
		public function getCopyGroup($key:String):Object
		{
			try {
				return this._objCopyMap.getValue($key);
			} catch ($error:Error) {
			}
			return null;
		}
		/*
		Event Handlers
		*/
		private function onXMLProcess($event:LoaderEvent):void
		{
			this.parseXML(this._objBackgroundLoader.data);
		}
		private function onXMLError($event:Event):void
		{
			this.warning("Could not parse copy!")
		}
	}
}