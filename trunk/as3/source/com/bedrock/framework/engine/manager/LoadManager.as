package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.core.base.DispatcherBase;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.ILoadManager;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockContentDisplay;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	public class LoadManager extends DispatcherBase implements ILoadManager
	{
		/*
		Variable Declarations
		*/
		private var _loader:LoaderMax;
		private var _checkPolicyFile:Boolean;
		private var _applicationDomain:ApplicationDomain;
		private var _securityDomain:SecurityDomain;
		/*
		Constructor
		*/	
		public function LoadManager():void
		{
		}
		
		public function initialize( $applicationDomain:ApplicationDomain ):void
		{
			this._applicationDomain = $applicationDomain;
			
			this._loader = new LoaderMax;
			this._loader.addEventListener( LoaderEvent.ERROR, this._onLoadError );
			this._loader.addEventListener( LoaderEvent.PROGRESS, this._onLoadProgress );
			this._loader.addEventListener( LoaderEvent.COMPLETE, this._onLoadComplete );
			this._loader.skipFailed = true;
		}
		public function load():void
		{
			this._loader.load();
		}
		
		public function appendLoader( $loader:* ):void
		{
			if ( $loader is LoaderCore ) this._loader.append( $loader );
		}
		
		public function appendContent( $page:Object ):void
		{
			LoaderMax.contentDisplayClass = BedrockContentDisplay;
			this.appendLoader( new SWFLoader( BedrockEngine.config.getPathValue( BedrockData.SWF_PATH ) + $page.id + ".swf", { name:$page.id, context:this._getLoaderContext() } ) );
			LoaderMax.contentDisplayClass = ContentDisplay;
			for each( var assetObj:Object in $page.assets ) {
				this.appendAsset( assetObj );
			}
		}
		public function appendAsset( $asset:Object ):void
		{
			var url:String = $asset.url || ( BedrockEngine.config.getPathValue( $asset.path ) + $asset.file );
			switch( $asset.path ) {
				case BedrockData.SWF_PATH :
				case BedrockData.SHARED_ASSETS_PATH :
				case BedrockData.FONTS_PATH :
					this.appendLoader( new SWFLoader( url, { name:$asset.id, context:this._getLoaderContext() } ) );
					break;
				case BedrockData.XML_PATH :
				case BedrockData.DATA_BUNDLE_PATH :
					this.appendLoader( new XMLLoader( url, { name:$asset.id } ) );
					break;
				case BedrockData.STYLESHEET_PATH :
					this.appendLoader( new CSSLoader( url, { name:$asset.id } ) );
					break;
				case BedrockData.IMAGE_PATH :
					this.appendLoader( new ImageLoader( url, { name:$asset.id } ) );
					break;
				case BedrockData.VIDEO_PATH :
					this.appendLoader( new VideoLoader( url, { name:$asset.id } ) );
					break;
				case BedrockData.AUDIO_PATH :
					this.appendLoader( new MP3Loader( url, { name:$asset.id } ) );
					break;
				default :
					LoaderMax.parse( url, { name:$asset.id } );
					break;
			}
		}
		/*
		Getters
		*/
		public function getLoader( $nameOrURL:String ):*
		{
			return this._loader.getLoader( $nameOrURL );
		}
		public function getContent( $nameOrURL:String ):*
		{
			return this._loader.getContent( $nameOrURL );
		}
		private function _getLoaderContext():LoaderContext
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