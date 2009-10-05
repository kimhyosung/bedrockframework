package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.api.IResourceManager;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.XMLUtil;
	
	import flash.events.Event;
	
	public class ResourceManager extends StandardWidget implements IResourceManager
	{
		/*
		Variable Declarations
		*/
		private var _objResourceMap:HashMap;
		private var _objBackgroundLoader:BackgroundLoader;
		/*
		Constructor
		*/
		public function ResourceManager()
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
			var xmlData:XML = new XML($xml);
			this._objResourceMap = XMLUtil.convertToHashMap(xmlData);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_LOADED, this));
		}
		
		public function getResource($key:String, $group:String = null):String
		{
			try {
				if ( $group != null ) {
					return this._objResourceMap.getValue($group)[ $key ] || "";
				} else {
					return this._objResourceMap.getValue($key) || "";
				}
			} catch ($error:Error) {
			}
			return null;
		}
		public function getResourceGroup($group:String, $key:String = null ):*
		{
			try {
				if ( $key != null ) {
					return this._objResourceMap.getValue($group)[ $key ] || "";
				} else {
					return this._objResourceMap.getValue($group) || "";
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
			this.status("Resource Bundle Loaded");
			this.parseXML(this._objBackgroundLoader.data);
		}
		private function onLoadError($event:Event):void
		{
			this.warning("Error Parsing Resource Bundle!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_ERROR, this ));
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