package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.IResourceController;
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderItem;
	
	import flash.system.LoaderContext;

	public class ResourceController extends StandardBase implements IResourceController
	{
		/*
		Variable Declarations
		*/
		private var _shellGroup:BedrockAssetGroupData;
		/*
		Constructor
	 	*/
		public function ResourceController()
		{
		}
		
		public function initialize():void
		{
			this._shellGroup = BedrockEngine.assetManager.getGroup( BedrockData.SHELL );
			BedrockEngine.data.dataBundleEnabled = this._isResourceEnabled( BedrockData.DATA_BUNDLE );
			BedrockEngine.data.libraryEnabled = this._isResourceEnabled( BedrockData.LIBRARY );
			BedrockEngine.data.fontsEnabled = this._isResourceEnabled( BedrockData.FONTS );
			BedrockEngine.data.stylesheetEnabled = this._isResourceEnabled( BedrockData.STYLESHEET );
		}
		
		public function queue( $autoLoad:Boolean = true ):void
		{
			var currentLocale:String = BedrockEngine.localeManager.currentLocale;
			
			this._prepareDataBundle();
			this._prepareLibrary();
			this._prepareFonts();
			this._prepareStylesheet();
			
			if ( $autoLoad ) BedrockEngine.loadController.load();
		}
		
		private function _isResourceEnabled( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this._shellGroup.assets, $id, "id" );
		}
		private function _getResourceData( $id:String ):BedrockAssetData
		{
			return ArrayUtil.findItem( this._shellGroup.assets, $id, "id" );
		}
		
		private function _prepareDataBundle():void
		{
			if ( this._isResourceEnabled( BedrockData.DATA_BUNDLE ) ) {
				var data:BedrockAssetData = this._getResourceData( BedrockData.DATA_BUNDLE );
				
				var loaderVars:Object = new Object;
				loaderVars.name = BedrockData.DATA_BUNDLE;
				loaderVars.alternateURL = data.alternateURL;
				
				var loader:LoaderItem = new XMLLoader( data.url, loaderVars );
				loader.addEventListener( LoaderEvent.COMPLETE, this._onDataBundleComplete, false, 10000 );
				
				BedrockEngine.loadController.appendLoader( loader );
			}
		}
		private function _prepareLibrary():void
		{
			if ( this._isResourceEnabled( BedrockData.LIBRARY ) ) {
				var data:BedrockAssetData = this._getResourceData( BedrockData.LIBRARY );
				
				var loaderVars:Object = new Object;
				loaderVars.name = BedrockData.LIBRARY;
				loaderVars.alternateURL = data.alternateURL;
				loaderVars.context = this._getLoaderContext();
				
				var loader:LoaderItem = new SWFLoader( data.url, loaderVars );
				loader.addEventListener( LoaderEvent.COMPLETE, this._onLibraryComplete, false, 10000 );
				
				BedrockEngine.loadController.appendLoader( loader );
			}
		}
		private function _prepareFonts():void
		{
			if ( this._isResourceEnabled( BedrockData.FONTS ) ) {
				var data:BedrockAssetData = this._getResourceData( BedrockData.FONTS );
				
				var loaderVars:Object = new Object;
				loaderVars.name = BedrockData.FONTS;
				loaderVars.alternateURL = data.alternateURL;
				loaderVars.context = this._getLoaderContext();
				
				var loader:LoaderItem = new SWFLoader( data.url, loaderVars );
				loader.addEventListener( LoaderEvent.COMPLETE, this._onFontsComplete, false, 10000 );
				
				BedrockEngine.loadController.appendLoader( loader );
			}
		}
		private function _prepareStylesheet():void
		{
			if ( this._isResourceEnabled( BedrockData.STYLESHEET ) ) {
				var data:BedrockAssetData = this._getResourceData( BedrockData.STYLESHEET );
				
				var loaderVars:Object = new Object;
				loaderVars.name = BedrockData.STYLESHEET;
				loaderVars.alternateURL = data.alternateURL;
				loaderVars.context = this._getLoaderContext();
				
				var loader:LoaderItem = new CSSLoader( data.url, loaderVars );
				loader.addEventListener( LoaderEvent.COMPLETE, this._onStylesheetComplete, false, 10000 );
				
				BedrockEngine.loadController.appendLoader( loader );
			}
		}
		
		private function _getLoaderContext():LoaderContext
		{
			return new LoaderContext( BedrockEngine.loadController.checkPolicyFile, BedrockEngine.loadController.applicationDomain );
		}
		/*
		Event Handlers
	 	*/
		private function _onDataBundleComplete( $event:LoaderEvent ):void
		{
			BedrockEngine.dataBundleManager.parse( BedrockEngine.loadController.getLoaderContent( BedrockData.DATA_BUNDLE ) );
		}
		private function _onStylesheetComplete( $event:LoaderEvent ):void
		{
			BedrockEngine.stylesheetManager.parse( BedrockEngine.loadController.getLoaderContent( BedrockData.STYLESHEET ) );
		}
		private function _onLibraryComplete( $event:LoaderEvent ):void
		{
			BedrockEngine.loadController.getLoaderContent( BedrockData.LIBRARY ).rawContent.initialize();
		}
		private function _onFontsComplete( $event:LoaderEvent ):void
		{
			BedrockEngine.loadController.getLoaderContent( BedrockData.FONTS ).rawContent.initialize();
		}
	}
}