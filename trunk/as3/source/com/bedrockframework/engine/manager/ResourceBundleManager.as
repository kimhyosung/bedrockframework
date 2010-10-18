package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.api.IResourceManager;
	import com.bedrockframework.engine.delegate.DefaultResourceDelegate;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.delegate.IDelegate;
	import com.bedrockframework.plugin.delegate.IResponder;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.DataLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.storage.IMap;
	
	import flash.events.Event;
	
	public class ResourceBundleManager extends StandardWidget implements IResourceManager, IResponder
	{
		/*
		Variable Declarations
		*/
		private var _clsDelegate:Class;
		private var _objDelegate:IDelegate;
		private var _mapData:HashMap;
		private var _objDataLoader:DataLoader;
		/*
		Constructor
		*/
		public function ResourceBundleManager()
		{
			this._mapData = new HashMap;
			this.delegate = DefaultResourceDelegate;
			this.createLoader();
		}
		/*
		Creation Functions
		*/
		private function createLoader():void
		{
			this._objDataLoader = new DataLoader();
			this._objDataLoader.addEventListener(LoaderEvent.COMPLETE, this.onLoadComplete);
			this._objDataLoader.addEventListener(LoaderEvent.IO_ERROR, this.onLoadError);
			this._objDataLoader.addEventListener(LoaderEvent.SECURITY_ERROR, this.onLoadError);
		}
		private function createDelegate( $data:String ):void
		{
			this._objDelegate = new this._clsDelegate( this );
			this._objDelegate.parse( $data );
		}
		public function load( $path:String ):void
		{
			this._objDataLoader.loadURL( $path );
		}

		
		/*
		Responder Functions
		*/
		public function result($data:* = null):void
		{
			if ( $data != null && ( $data is HashMap ) && this._mapData.isEmpty ) {
				this._mapData = $data as HashMap;
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_LOADED, this));
			} else if (  $data == null && !this._mapData.isEmpty ) {
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_LOADED, this));
			} else {
				this.fault();
			}
		}
		public function fault($data:*  = null):void
		{
			this.warning("Error Parsing Resource Bundle!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_ERROR, this ));
		}
		/*
		Event Handlers
		*/
		private function onLoadComplete($event:LoaderEvent):void
		{
			this.status("Resource Bundle Loaded");
			this.createDelegate( this._objDataLoader.data );
		}
		private function onLoadError($event:Event):void
		{
			this.warning("Error Parsing Resource Bundle!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_ERROR, this ));
		}
		/*
		Property Definitions
		*/
		public function get data():HashMap
		{
			return this._mapData;
		}
		public function get loader():DataLoader
		{
			return this._objDataLoader;
		}
		public function get delegate():Class
		{
			return this._clsDelegate;
		}
		public function set delegate( $class:Class ):void
		{
			this._clsDelegate = $class;
		}
	}
}