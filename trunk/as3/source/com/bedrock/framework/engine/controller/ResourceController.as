package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.engine.api.IResourceController;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.core.base.StandardBase;
	
	import flash.system.LoaderContext;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.CSSLoader;

	public class ResourceController extends StandardBase implements IResourceController
	{
		/*
		Constructor
	 	*/
		public function ResourceController()
		{
			
		}
		
		public function queue( $autoLoad:Boolean = true ):void
		{
			BedrockEngine.loadManager.addEventListener( BedrockEvent.LOAD_COMPLETE, this._onLoadComplete );
			var currentLocale:String = BedrockEngine.localeManager.currentLocale;
			
			this._queueFonts( BedrockEngine.config.getSettingValue( BedrockData.FONTS_ENABLED ), BedrockEngine.localeManager.isFileLocalized( BedrockData.FONTS ), currentLocale );
			this._queueStylesheet( BedrockEngine.config.getSettingValue( BedrockData.STYLESHEET_ENABLED ), BedrockEngine.localeManager.isFileLocalized( BedrockData.STYLESHEET ), currentLocale );
			this._queueDataBundle( BedrockEngine.config.getSettingValue( BedrockData.DATA_BUNDLE_ENABLED ), BedrockEngine.localeManager.isFileLocalized( BedrockData.DATA_BUNDLE ), currentLocale );
			this._queueLibrary( BedrockEngine.config.getSettingValue( BedrockData.LIBRARY_ENABLED ), BedrockEngine.localeManager.isFileLocalized( BedrockData.LIBRARY ), currentLocale );
			
			if ( $autoLoad ) BedrockEngine.loadManager.load();
		}
		
		private function _queueFonts( $enabled:Boolean, $localized:Boolean, $locale:String = null ):void
		{
			if ( $enabled ) {
				var path:String;
				if ( $localized ) {
					path = BedrockEngine.resourceDelegate.getFontPath( $locale );
				} else {
					path = BedrockEngine.resourceDelegate.getFontPath();
				}
				BedrockEngine.loadManager.appendLoader( new SWFLoader( path, { name:BedrockData.FONTS, context:this._getLoaderContext() } ) );
			}
		}
		private function _queueStylesheet( $enabled:Boolean, $localized:Boolean, $locale:String = null ):void
		{
			if ( $enabled ) {
				var path:String;
				if ( $localized ) {
					path = BedrockEngine.resourceDelegate.getStylesheetPath( $locale );
				} else {
					path = BedrockEngine.resourceDelegate.getStylesheetPath();
				}
				BedrockEngine.loadManager.appendLoader( new CSSLoader( path, { name:BedrockData.STYLESHEET } ) );
			}
		}
		private function _queueDataBundle( $enabled:Boolean, $localized:Boolean, $locale:String = null ):void
		{
			if ( $enabled ) {
				var path:String;
				if ( $localized ) {
					path = BedrockEngine.resourceDelegate.getDataBundlePath( $locale );
				} else {
					path = BedrockEngine.resourceDelegate.getDataBundlePath();
				}
				BedrockEngine.loadManager.appendLoader( new XMLLoader( path, { name:BedrockData.DATA_BUNDLE } ) );
			}
		}
		private function _queueLibrary( $enabled:Boolean, $localized:Boolean, $locale:String = null ):void
		{
			if ( $enabled ) {
				var path:String;
				if ( $localized ) {
					path = BedrockEngine.resourceDelegate.getLibraryPath( $locale );
				} else {
					path = BedrockEngine.resourceDelegate.getLibraryPath();
				}
				BedrockEngine.loadManager.appendLoader( new SWFLoader( path, { name:BedrockData.LIBRARY, context:this._getLoaderContext() } ) );
			}
		}
		
		private function _getLoaderContext():LoaderContext
		{
			return new LoaderContext( BedrockEngine.loadManager.checkPolicyFile, BedrockEngine.loadManager.applicationDomain );
		}
		/*
		Event Handlers
	 	*/
	 	
		private function _onLoadComplete( $event:BedrockEvent ):void
		{
			BedrockEngine.loadManager.removeEventListener( BedrockEvent.LOAD_COMPLETE, this._onLoadComplete );
			if ( BedrockEngine.config.getSettingValue( BedrockData.DATA_BUNDLE_ENABLED ) ) BedrockEngine.dataBundleManager.parse( BedrockEngine.loadManager.getContent( BedrockData.DATA_BUNDLE ) );
			if ( BedrockEngine.config.getSettingValue( BedrockData.STYLESHEET_ENABLED ) ) BedrockEngine.stylesheetManager.parse( BedrockEngine.loadManager.getContent( BedrockData.STYLESHEET ) );
			if ( BedrockEngine.config.getSettingValue( BedrockData.LIBRARY_ENABLED ) ) BedrockEngine.loadManager.getContent( BedrockData.LIBRARY ).rawContent.initialize();
			if ( BedrockEngine.config.getSettingValue( BedrockData.FONTS_ENABLED ) ) BedrockEngine.loadManager.getContent( BedrockData.FONTS ).rawContent.initialize();
		}
	}
}