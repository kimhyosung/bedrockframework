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
	import com.bedrockframework.plugin.util.ArrayUtil;
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
		private var _strDefaultLanguage:String;
		private var _strSystemLanguage:String;
		private var _strCurrentLanguage:String;
		private var _arrLanguages:Array;
		/*
		Constructor
		*/
		public function CopyManager()
		{
			this.createLoader();
		}
		public function initialize($languages:Array, $defaultLanguage:String = null):void
		{
			this._arrLanguages = $languages;
			this._strDefaultLanguage = $defaultLanguage;
			this.load(this._strDefaultLanguage);
		}
		private function createLoader():void
		{
			this._objBackgroundLoader = new BackgroundLoader();
			this._objBackgroundLoader.addEventListener(LoaderEvent.COMPLETE, this.onXMLComplete);
			this._objBackgroundLoader.addEventListener(LoaderEvent.IO_ERROR, this.onXMLError);
			this._objBackgroundLoader.addEventListener(LoaderEvent.SECURITY_ERROR, this.onXMLError);
		}
		public function load($language:String = null):void
		{
			this._objBackgroundLoader.load(new URLRequest(this.determinePath($language)));
		}
		
		private function parseXML($xml:String):void
		{
			var xmlCopy:XML = new XML($xml);
			this._objCopyMap = XMLUtil.convertToHashMap(xmlCopy);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.COPY_LOADED, this));
		}
		
		private function determinePath($language:String = null):String
		{
			if ($language != null && $language != "" && this.languageAvailable($language)) {
				this._strCurrentLanguage = $language;
				return BedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + "_" + this._strCurrentLanguage + ".xml";
			} else {
				this._strCurrentLanguage = null;
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
		
		private function languageAvailable($language:String):Boolean
		{
			return ArrayUtil.containsItem(this._arrLanguages, $language);
		}
		
		/*
		Event Handlers
		*/
		private function onXMLComplete($event:LoaderEvent):void
		{
			this.status("Copy Loaded : " + this._strCurrentLanguage);
			this.parseXML(this._objBackgroundLoader.data);
		}
		private function onXMLError($event:Event):void
		{
			this.warning("Could not parse copy!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.COPY_ERROR, this, {language:this._strCurrentLanguage}));
		}
		/*
		Property Definitions
		*/
		public function get languages():Array
		{
			return this._arrLanguages;
		}
		public function get currentLanguage():String
		{
			return this._strCurrentLanguage;
		}
		public function get defaultLanguage():String
		{
			return this._strDefaultLanguage;
		}
	}
}