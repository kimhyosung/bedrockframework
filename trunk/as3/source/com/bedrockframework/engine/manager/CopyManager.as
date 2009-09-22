package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.api.ICopyManager;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.XMLUtil;
	
	import flash.events.Event;
	
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
			this.createLoader();
		}
		private function createLoader():void
		{
			this._objBackgroundLoader = new BackgroundLoader();
			this._objBackgroundLoader.addEventListener(LoaderEvent.COMPLETE, this.onLoadComplete);
			this._objBackgroundLoader.addEventListener(LoaderEvent.IO_ERROR, this.onLoadError);
			this._objBackgroundLoader.addEventListener(LoaderEvent.SECURITY_ERROR, this.onLoadError);
		}
		public function load( $path:String ):void
		{
			this._objBackgroundLoader.loadURL( $path );
		}
		
		private function parseXML($xml:String):void
		{
			var xmlCopy:XML = new XML($xml);
			this._objCopyMap = XMLUtil.convertToHashMap(xmlCopy);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.COPY_LOADED, this));
		}
		
		public function getCopy($key:String, $group:String = null):String
		{
			try {
				if ( $group != null ) {
					return this._objCopyMap.getValue($group)[ $key ];
				} else {
					return this._objCopyMap.getValue($key);
				}
			} catch ($error:Error) {
			}
			return null;
		}
		public function getCopyGroup($group:String, $key:String = null ):*
		{
			try {
				if ( $key != null ) {
					return this._objCopyMap.getValue($group)[ $key ];
				} else {
					return this._objCopyMap.getValue($group);
				}
			} catch ($error:Error) {
			}
			return null;
		}
		/*
		Event Handlers
		*/
		private function onLoadComplete($event:LoaderEvent):void
		{
			this.status("Copy Loaded");
			this.parseXML(this._objBackgroundLoader.data);
		}
		private function onLoadError($event:Event):void
		{
			this.warning("Could not parse copy!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.COPY_ERROR, this ));
		}
		/*
		Property Definitions
		*/
		public function get loader():BackgroundLoader
		{
			return this._objBackgroundLoader;
		}
	}
}