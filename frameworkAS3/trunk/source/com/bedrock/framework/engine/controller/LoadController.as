package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.core.base.DispatcherBase;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.ILoadController;
	import com.bedrock.framework.engine.builder.BedrockBuilder;
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockContentData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockContentDisplay;
	import com.bedrock.framework.plugin.storage.HashMap;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	public class LoadController extends DispatcherBase implements ILoadController
	{
		/*
		Variable Declarations
		*/
		private var _loader:LoaderMax;
		private var _checkPolicyFile:Boolean;
		private var _applicationDomain:ApplicationDomain;
		private var _securityDomain:SecurityDomain;
		private var _builder:BedrockBuilder;
		/*
		Constructor
		*/	
		public function LoadController():void
		{
		}
		
		public function initialize( $builder:*, $applicationDomain:ApplicationDomain ):void
		{
			this._builder = $builder;
			this._applicationDomain = $applicationDomain;
			
			this._loader = new LoaderMax;
			this._loader.addEventListener( LoaderEvent.COMPLETE, this._onLoadComplete );
			this._loader.addEventListener( LoaderEvent.PROGRESS, this._onLoadProgress );
			this._loader.addEventListener( LoaderEvent.ERROR, this._onLoadError );
			this._loader.skipFailed = true;
		}
		public function load():void
		{
			this._loader.load();
		}
		
		public function appendLoader( $loader:* ):void
		{
			if ( $loader is LoaderCore ) {
				this._loader.append( $loader );
			}
		}
		
		public function appendContent( $content:BedrockContentData ):void
		{
			if ( !this.hasLoader( $content.id ) || ( this.hasLoader( $content.id ) && this.getLoader( $content.id ).status >= LoaderStatus.FAILED ) ) {
				var loader:LoaderItem = this.getLoader( $content.id );
				
				if ( BedrockEngine.assetManager.hasGroup( $content.assetGroup || $content.id ) ) {
					this.appendAssets( BedrockEngine.assetManager.getGroup( $content.assetGroup || $content.id ).assets );
				}
				
				LoaderMax.contentDisplayClass = BedrockContentDisplay;
				loader = new SWFLoader( BedrockEngine.config.getPathValue( BedrockData.SWF_PATH ) + $content.id + ".swf", { name:$content.id, context:this._getLoaderContext() } );
				LoaderMax.contentDisplayClass = ContentDisplay;
				this.appendLoader( loader );
			} else {
				switch ( this.getLoader( $content.id ).status ) {
					case LoaderStatus.LOADING :
						this.status( "Content \"" + $content.id + "\" loading." );
						break;
					case LoaderStatus.COMPLETED :
						this.status( "Content \"" + $content.id + "\" loaded." );
						break;
				}
			}
		}
		
		
 	 	
 	 	
		public function disposeContent( $id:String ):void
		{
			if ( !this.hasLoader( $id ) ) {
				var content:BedrockContentData = BedrockEngine.contentManager.getContent( $id );
				
				this.getLoader( content.id ).dispose();
				if ( content.autoDisposeAssets ) {
					if ( BedrockEngine.assetManager.hasGroup( content.assetGroup ) ) {
						for each ( var assetData:BedrockAssetData in BedrockEngine.assetManager.getGroup( content.assetGroup ) ) {
							BedrockEngine.loadController.getLoader( assetData.id ).dispose();
						}
					}
				}
				
			}
		}
		
		public function hasLoader( $nameOrURL:String ):Boolean
		{
			return ( this.getLoader( $nameOrURL ) != null );
		}
		
		public function appendAssets( $assets:Array ):void
		{
			for each( var assetObj:BedrockAssetData in $assets ) {
				
				this.appendAsset( assetObj );
			}
		}
		public function appendAsset( $asset:BedrockAssetData ):void
		{
			if ( !this.hasLoader( $asset.id ) ) {
				
				var url:String;
				if ( $asset.path != BedrockData.NONE && $asset.path != null ) {
					url = ( BedrockEngine.config.getPathValue( $asset.path ) + $asset.url );
				} else {
					url = $asset.url;
				}
				
				var loader:LoaderItem;
				var vars:Object = { name:$asset.id };
				switch( $asset.type ) {
					case "swf" :
						vars.context = this._getLoaderContext();
						loader = new SWFLoader( url, vars );
						break;
					case "xml" :
						loader = new XMLLoader( url, vars );
						break;
					case "stylesheet" :
						loader = new CSSLoader( url, vars );
						break;
					case "image" :
						loader = new ImageLoader( url, vars );
						break;
					case "video" :
						loader = new VideoLoader( url, vars );
						break;
					case "audio" :
						loader = new MP3Loader( url, vars );
						break;
					case "data" :
						loader = new DataLoader( url, vars );
						break;
				}
				this.appendLoader( loader );
			} else {
				this.status( "Asset \"" + $asset.id + "\" already loaded." );
			}
		}
		/*
		Getters
		*/
		public function getLoader( $nameOrURL:String ):*
		{
			return this._loader.getLoader( $nameOrURL );
		}
		public function getLoaderContent( $nameOrURL:String ):*
		{
			return this._loader.getContent( $nameOrURL );
		}
		private function _getLoaderContext():LoaderContext
		{
			return new LoaderContext( this._checkPolicyFile, this._applicationDomain );
		}
		
		public function getAssetGroup( $id:String ):HashMap
		{
			var assetsHash:HashMap = new HashMap;
			if ( BedrockEngine.assetManager.hasGroup( $id ) ) {
				for each( var assetObj:Object in BedrockEngine.assetManager.getGroup( $id ).assets ) {
					assetsHash.saveValue( assetObj.id, this.getLoaderContent( assetObj.id ) );
				}
			}
			return assetsHash;
		}
		/*
		Event Handlers
		*/
		private function _onLoadProgress( $event:LoaderEvent ):void
		{
			this.dispatchEvent( new BedrockEvent( BedrockEvent.LOAD_PROGRESS, this, { progress:this._loader.progress } ) );
		}
		private function _onLoadComplete( $event:LoaderEvent ):void
		{
			this.dispatchEvent( new BedrockEvent( BedrockEvent.LOAD_COMPLETE, this ) );
		}
		private function _onLoadError( $event:LoaderEvent ):void
		{
			this.dispatchEvent( new BedrockEvent( BedrockEvent.LOAD_ERROR, this ) );
		}
		/*
		Property Definitions
		*/
		public function set checkPolicyFile( $status:Boolean ):void
		{
			this._checkPolicyFile = $status;	
		}
		public function get checkPolicyFile():Boolean
		{
			return this._checkPolicyFile;	
		}
		
		public function set maxConnections( $count:uint ):void
		{
			this._loader.maxConnections = $count;			
		}
		public function get maxConnections():uint
		{
			return this._loader.maxConnections;	
		}
		
		public function set applicationDomain( $applicationDomain:ApplicationDomain ):void
		{
			this._applicationDomain =$applicationDomain;			
		}
		public function get applicationDomain():ApplicationDomain
		{
			return this._applicationDomain;	
		}
		
	}

}