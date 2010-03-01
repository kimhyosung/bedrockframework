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
	
	import flash.events.Event;
	
	public class ResourceManager extends StandardWidget implements IResourceManager, IResponder
	{
		/*
		Variable Declarations
		*/
		private var _clsDelegate:Class;
		private var _objDelegate:IDelegate;
		private var _objResourceMap:HashMap;
		private var _objDataLoader:DataLoader;
		/*
		Constructor
		*/
		public function ResourceManager()
		{
			this._objResourceMap = new HashMap;
			this.delegate = DefaultResourceDelegate;
			this.createLoader();
		}
		private function createLoader():void
		{
			this._objDataLoader = new DataLoader();
			this._objDataLoader.addEventListener(LoaderEvent.COMPLETE, this.onLoadComplete);
			this._objDataLoader.addEventListener(LoaderEvent.IO_ERROR, this.onLoadError);
			this._objDataLoader.addEventListener(LoaderEvent.SECURITY_ERROR, this.onLoadError);
		}
		public function load( $path:String ):void
		{
			this._objDataLoader.loadURL( $path );
		}
		
		private function createDelegate( $data:String ):void
		{
			this._objDelegate = new this._clsDelegate( this );
			this._objDelegate.parse( $data );
		}
		public function saveResource( $key:String, $data:* ):void
		{
			this._objResourceMap.saveValue( $key, $data );
		}
		public function getResource($key:String, $group:String = null):*
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
		public function getResourceArray( $prefix:String, $suffix:String = "", $startIndex:int = 1 ):Array
		{
			var arrResult:Array = new Array;
			var tmpValue:*;
			var numIndex:int = $startIndex;
			do {
				tmpValue = this._objResourceMap.getValue( $prefix + (new String(numIndex)) + $suffix );
				if ( tmpValue != null ) {
					arrResult.push( tmpValue );
					numIndex++;
				}
			} while ( tmpValue != null );
			
			return arrResult;
		}
		/*
		Responder Functions
		*/
		public function result($data:* = null):void
		{
			if ( $data != null && this._objResourceMap.isEmpty() ) {
				this._objResourceMap = $data as HashMap;
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_LOADED, this));
			} else if (  $data == null && !this._objResourceMap.isEmpty() ) {
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_LOADED, this));
			} else {
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_ERROR, this ));
			}
		}
		public function fault($data:*  = null):void
		{
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