package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.api.IResourceBundleManager;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.DataLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.VariableUtil;
	import com.bedrockframework.plugin.util.XMLUtil2;
	
	import flash.events.Event;
	
	public class ResourceBundleManager extends BasicWidget implements IResourceBundleManager
	{
		/*
		Variable Declarations
		*/
		private var _objDataLoader:DataLoader;
		private var _xmlData:XML;
		/*
		Constructor
		*/
		public function ResourceBundleManager()
		{
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
		}
		public function initialize():void
		{
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
		public function parse( $data:String ):void
		{
			this._xmlData = new XML( $data );
		}
		public function load( $path:String ):void
		{
			this._objDataLoader.loadURL( $path );
		}
		/*
		Get Functions
		*/
		public function getBundleAsXML( $id:String ):XML
		{
			return XMLUtil2.filterByAttribute( this._xmlData, "id", $id );
		}
		public function getBundleAsObject( $id:String ):Object
		{
			return XMLUtil2.getAsObject( this.getBundleAsXML( $id ) );
		}
		public function getBundleAsHashMap( $id:String ):HashMap
		{
			var objData:Object = this.getBundleAsObject( $id );
			var mapData:HashMap = new HashMap();
			mapData.importObject( objData );
			return mapData;
		}
		public function getBundleAsArray( $id:String ):Array
		{
			var arrData:Array = new Array;
			var xmlData:XML = this.getBundleAsXML( $id );
			for each ( var xmlItem:XML in xmlData.children() ) {
				if ( xmlItem.hasComplexContent() ) {
					arrData.push( XMLUtil2.getAsObject( xmlItem ) );
				} else {
					if ( xmlItem.attributes().length() > 0 ) {
						arrData.push( XMLUtil2.getAsObject( xmlItem ) );
					} else {
						arrData.push( VariableUtil.sanitize( xmlItem.toString() ) );
					}
				}
			}
			return arrData;
		}
		/*
		Event Handlers
		*/
		private function onLoadComplete($event:LoaderEvent):void
		{
			this.status( "Resource Bundle Loaded" );
			this.parse( $event.details.data );
			BedrockDispatcher.dispatchEvent( new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_LOADED, this ) );
		}
		private function onLoadError($event:Event):void
		{
			this.warning( "Error Parsing Resource Bundle!" );
			BedrockDispatcher.dispatchEvent( new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_ERROR, this ) );
		}
		/*
		Property Definitions
		*/
		public function get data():XML
		{
			return this._xmlData;
		}
		public function get loader():DataLoader
		{
			return this._objDataLoader;
		}
	}
}