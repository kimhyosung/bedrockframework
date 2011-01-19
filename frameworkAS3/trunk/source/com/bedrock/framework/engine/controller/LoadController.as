package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.core.base.DispatcherBase;
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.builder.BedrockBuilder;
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockModuleDisplay;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	/**
	 * @private
	 */
	public class LoadController extends DispatcherBase
	{
		/*
		Variable Declarations
		*/
		private var _loader:LoaderMax;
		private var _checkPolicyFile:Boolean;
		private var _applicationDomain:ApplicationDomain;
		private var _securityDomain:SecurityDomain;
		private var _builder:BedrockBuilder;
		private var _empty:Boolean;
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
			
			this._empty = true;
		}
		public function load():void
		{
			this._loader.load();
			this.dispatchEvent( new BedrockEvent( BedrockEvent.LOAD_BEGIN, this ) );
		}
		public function pause():void
		{
			this._loader.pause();
		}
		public function resume():void
		{
			this._loader.resume();
		}
		
		public function appendLoader( $loader:* ):void
		{
			if ( $loader is LoaderItem ) {
				this._empty = false;
				this._loader.append( $loader );
			}
		}
		
		public function appendModule( $module:BedrockModuleData ):void
		{
			if ( !this.hasLoader( $module.id ) || ( this.hasLoader( $module.id ) && this.getLoader( $module.id ).status >= LoaderStatus.FAILED ) ) {
				
				if ( Bedrock.engine::assetManager.hasGroup( $module.assetGroup ) ) {
					this.appendAssetGroup( Bedrock.engine::assetManager.getGroup( $module.assetGroup ) );
				}
				
				LoaderMax.contentDisplayClass = BedrockModuleDisplay;
				this.appendLoader( this._getModuleLoader( $module ) );
				LoaderMax.contentDisplayClass = ContentDisplay;
			} else {
				switch ( this.getLoader( $module.id ).status ) {
					case LoaderStatus.LOADING :
						Bedrock.logger.status( "Module \"" + $module.id + "\" loading." );
						break;
					case LoaderStatus.COMPLETED :
						Bedrock.logger.status( "Module \"" + $module.id + "\" already loaded." );
						break;
				}
			}
		}
		
		
		private function _getModuleLoader( $module:BedrockModuleData ):LoaderItem
		{
			var loaderVars:Object = $module.export();
			delete loaderVars.autoDispose;
			loaderVars.context = this.getLoaderContext();
			
			if ( Bedrock.engine::containerManager.hasContainer( $module.container ) ) {
				loaderVars.container = Bedrock.engine::containerManager.getContainer( $module.container );
			} else if ( $module.container != BedrockData.NONE ) {
				Bedrock.logger.warning( "Container \"" + $module.container + "\" not found for module \"" + $module.id + "\"!" );
			}
			return new SWFLoader( $module.url, loaderVars );
		}
		
		
 	 	
		public function disposeModule( $id:String ):void
		{
			if ( this.hasLoader( $id ) ) {
				var module:BedrockModuleData = Bedrock.engine::moduleManager.getModule( $id );
				
				this.getLoader( module.id ).dispose();
				if ( module.autoDisposeAssets ) {
					if ( Bedrock.engine::assetManager.hasGroup( module.assetGroup ) ) {
						for each ( var assetData:BedrockAssetData in Bedrock.engine::assetManager.getGroup( module.assetGroup ) ) {
							this.getLoader( assetData.id ).dispose();
						}
					}
				}
			} else {
				Bedrock.logger.warning( "Loader \"" + $id + "\" not found!" );
			}
		}
		
		public function hasLoader( $nameOrURL:String ):Boolean
		{
			return ( this.getLoader( $nameOrURL ) != null );
		}
		
		public function appendAssetGroup( $assetGroup:BedrockAssetGroupData ):void
		{
			for each( var assetObj:BedrockAssetData in $assetGroup.contents ) {
				this.appendAsset( assetObj );
			}
		}
		public function appendAsset( $asset:BedrockAssetData ):void
		{
			if ( !this.hasLoader( $asset.id ) || ( this.hasLoader( $asset.id ) && this.getLoader( $asset.id ).status >= LoaderStatus.FAILED ) ) {
				this.appendLoader( this._getAssetLoader( $asset ) );
			} else {
				switch ( this.getLoader( $asset.id ).status ) {
					case LoaderStatus.LOADING :
						Bedrock.logger.status( "Asset \"" + $asset.id + "\" loading." );
						break;
					case LoaderStatus.COMPLETED :
						Bedrock.logger.status( "Asset \"" + $asset.id + "\" already loaded." );
						break;
				}
				
			}
		}
		private function _getAssetLoader( $asset:BedrockAssetData ):LoaderItem
		{
			var loaderVars:Object = $asset.export();
			delete loaderVars.autoDispose;
			
			var loader:LoaderItem;
			switch( $asset.type ) {
				case BedrockAssetData.SWF :
					if ( Bedrock.engine::containerManager.hasContainer( $asset.container ) ) {
						loaderVars.container = Bedrock.engine::containerManager.getContainer( $asset.container );
					} else if ( $asset.container != BedrockData.NONE && $asset.container != null && $asset.container != undefined ) {
						Bedrock.logger.warning( "Container \"" + $asset.container + "\" not found for asset \"" + $asset.id + "\"!" );
					}
					loaderVars.context = this.getLoaderContext();
					loader = new SWFLoader( $asset.url, loaderVars );
					break;
				case BedrockAssetData.XML :
					loader = new XMLLoader( $asset.url, loaderVars );
					break;
				case BedrockAssetData.STYLESHEET :
					loader = new CSSLoader( $asset.url, loaderVars );
					break;
				case BedrockAssetData.IMAGE :
					loader = new ImageLoader( $asset.url, loaderVars );
					break;
				case BedrockAssetData.VIDEO :
					loaderVars.autoPlay = $asset.autoPlay || false;
					loader = new VideoLoader( $asset.url, loaderVars );
					break;
				case BedrockAssetData.AUDIO :
					loader = new MP3Loader( $asset.url, loaderVars );
					break;
				case BedrockAssetData.DATA :
					loader = new DataLoader( $asset.url, loaderVars );
					break;
			}
			return loader;
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
		public function getRawLoaderContent( $nameOrURL:String ):*
		{
			return this._loader.getContent( $nameOrURL ).rawContent;
		}
		public function getLoaderContext():LoaderContext
		{
			return new LoaderContext( this._checkPolicyFile, this._applicationDomain );
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
			this._empty = true;
			this.dispatchEvent( new BedrockEvent( BedrockEvent.LOAD_COMPLETE, this ) );
		}
		private function _onLoadError( $event:LoaderEvent ):void
		{
			this.dispatchEvent( new BedrockEvent( BedrockEvent.LOAD_ERROR, this ) );
		}
		/*
		Property Definitions
		*/
		
		public function set maxConnections( $count:uint ):void
		{
			this._loader.maxConnections = $count;			
		}
		public function get maxConnections():uint
		{
			return this._loader.maxConnections;	
		}
		
		public function get empty():Boolean
		{
			return this._empty;	
		}
		
	}

}