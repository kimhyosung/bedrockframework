package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.ILocaleManager;
	import com.bedrock.framework.engine.bedrock;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.bedrock.framework.plugin.util.XMLUtil2;
	
	public class LocaleManager extends StandardBase implements ILocaleManager
	{
		/*
		Variable Declarations
		*/
		private var _defaultLocale:String;
		private var _currentLocale:String;
		private var _data:Array;
		/*
		Constructor
		*/
		public function LocaleManager()
		{
			this._data = new Array;
		}
		public function initialize( $data:XML, $defaultLocale:String, $currentLocale:String ):void
		{
			this.parse( $data );
			this._defaultLocale = $defaultLocale;
			this._currentLocale = $currentLocale;
		}
		private function parse( $data:XML ):void
		{
			this._data = new Array;
			for each( var xmlItem:XML in $data.children() ) {
				this._data.push( XMLUtil2.getAttributesAsObject( xmlItem ) );
			}
		}
		public function load($locale:String = null ):void
		{
			if ( !this.hasLocale($locale) ) {
				this.warning( "Locale not available - " + $locale );
			} else {
				this.status( "Loading Locale - " + $locale );
				this._currentLocale = $locale;
				BedrockEngine.bedrock::fileManager.load( this._currentLocale );
			}
		}
		
		public function getLocale( $id:String ):Object
		{
			return ArrayUtil.findItem( this._data, $id, "id" );
		}
		
		public function hasLocale($locale:String):Boolean
		{
			return ArrayUtil.containsItem( this._data, $locale );
		}
		/*
		Property Definitions
		*/
		public function get data():Array
		{
			return this._data;
		}
		public function get currentLocale():String
		{
			return this._currentLocale;
		}
		public function get defaultLocale():String
		{
			return this._defaultLocale;
		}
	}
}