package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.ILocaleManager;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.BulkLoaderEvent;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.BulkLoader;
	import com.bedrockframework.plugin.util.ArrayUtil;
	
	import flash.events.Event;
	
	public class LocaleManager extends StandardWidget implements ILocaleManager
	{
		/*
		Variable Declarations
		*/
		private var _objBulkLoader:BulkLoader;
		private var _strDefaultLocale:String;
		private var _strSystemLocale:String;
		private var _strCurrentLocale:String;
		private var _arrLocales:Array;
		/*
		Constructor
		*/
		public function LocaleManager()
		{
			this.createLoader();
		}
		private function createLoader():void
		{
			this._objBulkLoader = new BulkLoader;
			this._objBulkLoader.addEventListener( BulkLoaderEvent.COMPLETE, this.onLocaleComplete );
		}
		public function initialize($locales:Array, $defaultLocale:String = null):void
		{
			this._arrLocales = $locales;
			this._strDefaultLocale = $defaultLocale;
		}
		
		public function load($locale:String = null, $useLoadManager:Boolean = false):void
		{
			this.status( "Loading Locale - " + $locale );
			if ( $locale != null && $locale != "" && this.isLocaleAvailable($locale) ) {
				this._strCurrentLocale = $locale;
				if ( BedrockEngine.config.getLocaleValue( BedrockData.FONTS_ENABLED ) ) {
					this.addToQueue( this.determineFontsPath( $locale ), BedrockEngine.fontManager.loader, $useLoadManager );
				}
				if ( BedrockEngine.config.getLocaleValue( BedrockData.RESOURCE_BUNDLE_ENABLED ) ) {
					this.addToQueue( this.determineResourceBundlePath( $locale ), BedrockEngine.resourceManager.loader, $useLoadManager );
				}
				if ( BedrockEngine.config.getLocaleValue( BedrockData.STYLESHEET_ENABLED ) ) {
					this.addToQueue( this.determineCSSPath( $locale ), BedrockEngine.styleManager.loader, $useLoadManager );
				}
				if ( !$useLoadManager ) this._objBulkLoader.loadQueue();
				BedrockEngine.config.switchLocale( this._strCurrentLocale );
			}
			if ( !this.isLocaleAvailable($locale) ) {
				this.warning( "Locale not available : " + $locale );
			}
		}
		
		private function addToQueue( $path:String, $loader:*, $useLoadManager:Boolean = false ):void
		{
			if ( !$useLoadManager ) {
				this._objBulkLoader.addToQueue( $path, $loader );
			} else {
				BedrockEngine.loadManager.addToQueue( $path, $loader );
			}
		}
		
		private function determineFontsPath( $locale:String = null ):String
		{
			return BedrockEngine.config.getEnvironmentValue(BedrockData.SWF_PATH) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX ) + BedrockEngine.config.getSettingValue( BedrockData.FONTS_FILE_NAME ) + "_" + this._strCurrentLocale + ".swf";
		}
		private function determineResourceBundlePath( $locale:String = null ):String
		{
			return BedrockEngine.config.getEnvironmentValue(BedrockData.XML_PATH) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX ) + BedrockEngine.config.getSettingValue( BedrockData.RESOURCE_BUNDLE_FILE_NAME )  + "_" + this._strCurrentLocale + ".xml";
		}
		private function determineCSSPath( $locale:String = null ):String
		{
			return BedrockEngine.config.getEnvironmentValue(BedrockData.CSS_PATH) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX ) + BedrockEngine.config.getSettingValue( BedrockData.STYLE_SHEET_FILE_NAME )  + "_" + this._strCurrentLocale + ".css";
		}
		
		public function isLocaleAvailable($locale:String):Boolean
		{
			return ArrayUtil.containsItem(this._arrLocales, $locale);
		}
		
		/*
		Event Handlers
		*/
		private function onLocaleComplete($event:LoaderEvent):void
		{
			this.status( "Completed Locale Load : " + this._strCurrentLocale );
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.LOCALE_LOADED, this ) );
		}
		private function onLocaleError($event:Event):void
		{
			this.warning( "Error Loading Locale : " + this._strCurrentLocale );
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.LOCALE_ERROR, this ) );
		}
		/*
		Property Definitions
		*/
		public function get locales():Array
		{
			return this._arrLocales;
		}
		public function get currentLocale():String
		{
			return this._strCurrentLocale;
		}
		public function get defaultLocale():String
		{
			return this._strDefaultLocale;
		}
	}
}