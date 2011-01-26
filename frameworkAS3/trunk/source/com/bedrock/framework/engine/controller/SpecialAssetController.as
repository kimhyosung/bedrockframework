package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.api.ISpecialAssetController;
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderItem;
	/**
	 * @private
	 */
	public class SpecialAssetController implements ISpecialAssetController
	{
		/*
		Variable Declarations
		*/
		private var _shellGroup:BedrockAssetGroupData;
		/*
		Constructor
	 	*/
		public function SpecialAssetController()
		{
		}
		
		public function initialize():void
		{
			this._shellGroup = Bedrock.engine::assetManager.getGroup( BedrockData.SHELL );
			
			this._saveEnabledSetting( BedrockData.RESOURCE_BUNDLE );
			this._saveEnabledSetting( BedrockData.LIBRARY );
			this._saveEnabledSetting( BedrockData.FONTS );
			this._saveEnabledSetting( BedrockData.STYLESHEET );
			
			this._queue();
		}
		
		private function _saveEnabledSetting( $id:String ):void
		{
			Bedrock.engine::configModel.saveSettingValue( $id + "Enabled", this._isAssetEnabled( $id ) ); 
		}
		
		private function _queue():void
		{
			this._prepareResourceBundle();
			this._prepareLibrary();
			this._prepareFonts();
			this._prepareStylesheet();
		}
		
		private function _isAssetEnabled( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this._shellGroup.contents, $id, "id" );
		}
		private function _getAssetData( $id:String ):BedrockAssetData
		{
			return ArrayUtil.findItem( this._shellGroup.contents, $id, "id" );
		}
		
		private function _prepareResourceBundle():void
		{
			if ( this._isAssetEnabled( BedrockData.RESOURCE_BUNDLE ) ) {
				var data:BedrockAssetData = this._getAssetData( BedrockData.RESOURCE_BUNDLE );
				
				var loaderVars:Object = new Object;
				loaderVars.name = BedrockData.RESOURCE_BUNDLE;
				loaderVars.alternateURL = data.alternateURL;
				
				var loader:LoaderItem = new XMLLoader( data.url, loaderVars );
				loader.addEventListener( LoaderEvent.COMPLETE, this._onDataBundleComplete, false, 10000 );
				
				Bedrock.engine::loadController.appendLoader( loader );
			}
		}
		private function _prepareLibrary():void
		{
			if ( this._isAssetEnabled( BedrockData.LIBRARY ) ) {
				var data:BedrockAssetData = this._getAssetData( BedrockData.LIBRARY );
				
				var loaderVars:Object = new Object;
				loaderVars.name = BedrockData.LIBRARY;
				loaderVars.alternateURL = data.alternateURL;
				loaderVars.context = Bedrock.engine::loadController.getLoaderContext();
				
				var loader:LoaderItem = new SWFLoader( data.url, loaderVars );
				loader.addEventListener( LoaderEvent.COMPLETE, this._onLibraryComplete, false, 10000 );
				
				Bedrock.engine::loadController.appendLoader( loader );
			}
		}
		private function _prepareFonts():void
		{
			if ( this._isAssetEnabled( BedrockData.FONTS ) ) {
				var data:BedrockAssetData = this._getAssetData( BedrockData.FONTS );
				
				var loaderVars:Object = new Object;
				loaderVars.name = BedrockData.FONTS;
				loaderVars.alternateURL = data.alternateURL;
				loaderVars.context = Bedrock.engine::loadController.getLoaderContext();
				
				var loader:LoaderItem = new SWFLoader( data.url, loaderVars );
				loader.addEventListener( LoaderEvent.COMPLETE, this._onFontsComplete, false, 10000 );
				
				Bedrock.engine::loadController.appendLoader( loader );
			}
		}
		private function _prepareStylesheet():void
		{
			if ( this._isAssetEnabled( BedrockData.STYLESHEET ) ) {
				var data:BedrockAssetData = this._getAssetData( BedrockData.STYLESHEET );
				
				var loaderVars:Object = new Object;
				loaderVars.name = BedrockData.STYLESHEET;
				loaderVars.alternateURL = data.alternateURL;
				
				var loader:LoaderItem = new CSSLoader( data.url, loaderVars );
				loader.addEventListener( LoaderEvent.COMPLETE, this._onStylesheetComplete, false, 10000 );
				
				Bedrock.engine::loadController.appendLoader( loader );
			}
		}
		
		/*
		Event Handlers
	 	*/
		private function _onDataBundleComplete( $event:LoaderEvent ):void
		{
			Bedrock.engine::resourceBundleManager.parse( Bedrock.engine::loadController.getLoaderContent( BedrockData.RESOURCE_BUNDLE ) );
		}
		private function _onStylesheetComplete( $event:LoaderEvent ):void
		{
			Bedrock.engine::stylesheetManager.initialize( Bedrock.engine::loadController.getLoaderContent( BedrockData.STYLESHEET ) );
		}
		private function _onLibraryComplete( $event:LoaderEvent ):void
		{
			Bedrock.engine::loadController.getLoaderContent( BedrockData.LIBRARY ).rawContent.initialize();
		}
		private function _onFontsComplete( $event:LoaderEvent ):void
		{
			Bedrock.engine::loadController.getLoaderContent( BedrockData.FONTS ).rawContent.initialize();
		}
	}
}