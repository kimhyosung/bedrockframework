package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.ILocaleManager;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.plugin.util.ArrayUtil;
	
	public class LocaleManager extends StandardWidget implements ILocaleManager
	{
		/*
		Variable Declarations
		*/
		private var _strDefaultLocale:String;
		private var _strSystemLocale:String;
		private var _strCurrentLocale:String;
		private var _arrLocales:Array;
		/*
		Constructor
		*/
		public function LocaleManager()
		{
		}
		public function initialize($locales:Array, $defaultLocale:String = null):void
		{
			this._arrLocales = $locales;
			this._strDefaultLocale = $defaultLocale;
		}
		
		public function load($locale:String = null ):void
		{
			if ( !this.isLocaleAvailable($locale) ) {
				this.warning( "Locale not available - " + $locale );
			} else {
				this.status( "Loading Locale - " + $locale );
				this._strCurrentLocale = $locale;
				BedrockEngine.bedrock::fileManager.load( this._strCurrentLocale );
				BedrockEngine.config.switchLocale( this._strCurrentLocale );
			}
		}
		
		public function isLocaleAvailable($locale:String):Boolean
		{
			return ArrayUtil.containsItem( this._arrLocales, $locale );
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