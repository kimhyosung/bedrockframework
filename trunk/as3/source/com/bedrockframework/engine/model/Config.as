/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@builtonbedrock.com
 * website: http://www.builtonbedrock.com/
 * blog: http://blog.builtonbedrock.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.engine.model
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.engine.api.IConfig;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.StringUtil;
	import com.bedrockframework.plugin.util.VariableUtil;
	import com.bedrockframework.plugin.util.XMLUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.system.Capabilities;	
	
	public class Config extends StandardWidget implements IConfig
	{
		/*
		Variable Declarations
		*/		
		private var _objSettingValues:Object;
		private var _objEnvironmentValues:Object;
		private var _objPageValues:Object;
		private var _objParamValues:Object;
		private var _objLocaleValues:Object;
		private var _objPathValues:Object;
		private var _objLocaleValueHash:HashMap;
		/*
		Constructor
		*/
		public function Config()
		{
			this._objSettingValues = new Object;
			this._objEnvironmentValues = new Object;
			this._objPageValues = new Object;
			this._objParamValues = new Object;
			this._objLocaleValues = new Object;
			this._objPathValues = new Object;
		}
		/*
		Initialize
		*/
		public function initialize( $data:String, $url:String, $root:DisplayObjectContainer ):void
		{
			this.saveSettingValue(BedrockData.URL, $url);
			this.saveSettingValue(BedrockData.MANUFACTURER, Capabilities.manufacturer);
			this.saveSettingValue(BedrockData.SYSTEM_LANGUAGE, Capabilities.language);
			this.saveSettingValue(BedrockData.OS, Capabilities.os);
			
			this.saveSettingValue( BedrockData.ROOT, $root );
			this.saveSettingValue( BedrockData.ROOT_WIDTH, $root.width );
			this.saveSettingValue( BedrockData.ROOT_HEIGHT, $root.height );
			
			this.parseXML($data);
		}

		
		private function parseXML($data:String):void
		{
			var xmlConfig:XML = this.getXML($data);
			
			this.saveSettingValue( BedrockData.LAYOUT, XMLUtil.convertToArray( xmlConfig.layout, true ) );
			this.saveSettingValue( BedrockData.DEFAULT_PAGE, this.getDefaultPage(xmlConfig.pages) );
			this.saveSettingValue( BedrockData.ENVIRONMENT, this.getEnvironment(xmlConfig.environments, this.getSettingValue(BedrockData.URL)));
			
			this.parseSettingsValues( xmlConfig.settings.general );
			this.parseSettingsValues( xmlConfig.settings.file_names );
			this.saveEnvironmentValues( xmlConfig.environments, this.getSettingValue( BedrockData.ENVIRONMENT ) );
			this.saveLocaleSettings( xmlConfig.settings.locale );
			this.parseLocaleValues( xmlConfig.locales );
			this.saveCacheSettings();
			
			this.savePages( this.parsePages(xmlConfig.pages) );
			
			this.status( this._objParamValues );
			this.status( this._objSettingValues );
			this.status( this._objEnvironmentValues );
			this.status( this._objLocaleValues );
			
			this.status("Environment - " + this.getSettingValue(BedrockData.ENVIRONMENT));
		}
		private function getXML($data:String):XML
		{
			var xmlConfig:XML = new XML($data);
			XML.ignoreComments=true;
			XML.ignoreWhitespace=true;
			return xmlConfig;
		}		
		/*
		Settings Functions
		*/
		private function parseSettingsValues($node:XMLList):void
		{
			var objData:Object = XMLUtil.convertToObject($node);
			for (var d:String in objData) {
				this.saveSettingValue(d, objData[d]);
			}
		}
		private function saveCacheSettings():void
		{
			if (this.getSettingValue(BedrockData.CACHE_PREVENTION_ENABLED)) {
				this.saveSettingValue(BedrockData.CACHE_KEY, StringUtil.generateUniqueKey(10) );
			} else {
				this.saveSettingValue(BedrockData.CACHE_KEY, "");
			}
		}
		private function saveSettingValue($key:String, $value:*):void
		{
			this._objSettingValues[ $key ] = $value;
		}
		/**
		 * Returns a framework setting independent of environment.
	 	*/
		public function getSettingValue($key:String):*
		{
			return this._objSettingValues[ $key ];
		}
		/*
		Environment Functions
		*/
		private function getEnvironment($node:XMLList, $url:String):String
		{
			var strURL:String = $url;
			var xmlEnvironments:XML=new XML($node);
			var xmlPatterns:XML
			var strEnvironmentName:String;
			var numOuterLength:int = xmlEnvironments.children().length();
			var numInnerLength:int;
			var strPattern:String
			for (var i:int = 0 ; i < numOuterLength; i ++) {
				strEnvironmentName = XMLUtil.getAttributeObject(xmlEnvironments.environment[i]).name;
				try {
					xmlPatterns = new XML(xmlEnvironments.environment[i].patterns);
					numInnerLength = xmlPatterns.children().length();
				} catch($error:Error){
					numInnerLength =0;
				}
				for (var p: int =0; p < numInnerLength; p++) {
					strPattern = xmlPatterns.child(p).toString();
					if (strURL.indexOf(strPattern) > -1) {
						return strEnvironmentName;
					}
				}
			}			
			return BedrockData.PRODUCTION;
		}
		private function saveEnvironmentValues($node:XMLList, $environment:String):void
		{
			var xmlData:XML = new XML($node);
			
			this.parseEnvironmentValues(XMLUtil.filterByAttribute(xmlData, "name", BedrockData.DEFAULT));
			this.parseEnvironmentValues(XMLUtil.filterByAttribute(xmlData, "name", $environment));
			
			delete this._objEnvironmentValues["patterns"];
		}
		
		private function parseEnvironmentValues( $xml:XML ):void
		{
			var objData:Object = XMLUtil.convertToObject($xml);
			for (var d:String in objData) {
				this.saveEnvironmentValue(d, objData[d]);
			}
		}
		private function saveEnvironmentValue($key:String, $value:*):void
		{
			this._objEnvironmentValues[ $key ] = $value;
		}
		/**
		 * Returns a environment value that will change depending on the current environment.
		 * Environment values are declared in the config xml file.
	 	*/
		public function getEnvironmentValue($key:String):*
		{
			return this._objEnvironmentValues[ $key ]; 
		}
		/*
		Path Functions
		*/
		public function setPathValue( $key:String, $value:String ):void
		{
			this._objPathValues[ $key ] = $value;
		}
		public function getPathValue( $key:String ):String
		{
			return this._objPathValues[ $key ];
		}
		/*
		Pages Functions
		*/
		private function parsePages($node:XMLList):Object
		{
			var objPages:Object = new Object  ;
			var xmlPages:XML=new XML($node);
			var xmlPage:XMLList;
			//
			var objPage:Object;
			for (var s:String in xmlPages.children()) {
				objPage=new Object();
				xmlPage=xmlPages.child(s);
				for (var d:String in xmlPage.children()) {
					if (! xmlPage.child(d).hasComplexContent()) {
						objPage[xmlPage.child(d).name()]=XMLUtil.convertValue(xmlPage.child(d));
					} else {
						if (xmlPage.child(d).name() == "files") {
							objPage[xmlPage.child(d).name()]=this.sanitizePaths(xmlPage.child(d));
						} else {
							objPage[xmlPage.child(d).name()]=XMLUtil.convertToArray(xmlPage.child(d));
						}
					}
				}
				objPages[objPage.alias] = objPage;
			}
			return objPages;
		}
		public function addPage($alias:String, $data:Object):void
		{
			this._objPageValues[$alias] = $data;
		}
		private function savePages($value:*):void
		{
			this._objPageValues = $value;
		}
		public function getPage($key:String):Object
		{
			var objPage:Object= this._objPageValues[ $key ];
			if (objPage == null) {
				this.warning("Page \'" + $key + "\' does not exist!");
			}
			return objPage;
		}
		public function getPages():Array
		{
			var arrPages:Array = new Array;
			for (var p in this._objPageValues) {
				arrPages.push(this._objPageValues[p]);
			}
			return arrPages;
		}
		
		private function getDefaultPage($node:XMLList):String
		{
			var xmlData:XML = new XML($node);
			var xmlDefaultPage:XML = XMLUtil.filterByAttribute($node, BedrockData.DEFAULT_PAGE, "true");
			return XMLUtil.convertValue(xmlDefaultPage.alias);
		}
		/*
		Locales
		*/
		private function saveLocaleSettings( $node:XMLList ):void
		{
			if ( this.getSettingValue( BedrockData.LOCALE_ENABLED ) ) {
				
				var objData:Object = XMLUtil.convertToObject($node);
				for (var d:String in objData) {
					this.saveLocaleValue(d, objData[d]);
				}
				
				var strLocales:String = objData[ BedrockData.LOCALES ];
				var arrLocales:Array = strLocales.split(",")
				var numLength:int = arrLocales.length;
				for (var i:int = 0; i < numLength; i ++) {
					arrLocales[i] = StringUtil.trim(arrLocales[i]);
				}
				this.saveLocaleValue(BedrockData.LOCALES, arrLocales);
				
				if (numLength > 0 && this.getLocaleValue( BedrockData.DEFAULT_LOCALE ) == null ) {
					this.saveLocaleValue( BedrockData.DEFAULT_LOCALE, arrLocales[0]);	
				}
				this.saveLocaleValue( BedrockData.CURRENT_LOCALE, this.getLocaleValue( BedrockData.DEFAULT_LOCALE ) );
				
			}
		}
		public function switchLocale( $locale:String ):void
		{
			this.saveLocaleValue( BedrockData.CURRENT_LOCALE, $locale );
			var objData:Object = this._objLocaleValueHash.getValue( $locale );

			for (var d:String in objData) {
				this.saveLocaleValue( d, objData[d] );
			}
		}
		
		private function parseLocaleValues( $node:XMLList ):void
		{
			this._objLocaleValueHash = XMLUtil.convertToHashMap( $node );
		}
		
		private function saveLocaleValue($key:String, $value:*):void
		{
			this._objLocaleValues[ $key ] = $value;
		}
		/**
		 * Returns a environment value that will change depending on the current locale.
		 * Locale values are declared in the config xml file.
	 	*/
		public function getLocaleValue($key:String):*
		{
			return this._objLocaleValues[ $key ]; 
		}
		/*
		Param Functions
		*/
		public function parseParamObject($data:Object):void
		{
			for (var d:String in $data){
				this.saveParamValue( d, VariableUtil.sanitize($data[d]) ); 
			}
		}
		public function parseParamString($values:String, $variableSeparator:String ="&", $valueSeparator:String =  "="):void
		{
			if ($values != null) {
				var strValues:String = $values;
				var strVariableSeparator:String = $variableSeparator;
				var strValueSeparator:String = $valueSeparator;
				//
				var arrValues:Array = strValues.split( strVariableSeparator );
				var numLength:int = arrValues.length;
				for (var v:int = 0; v < numLength; v++) {
					var arrVariable:Array = arrValues[v].split(strValueSeparator);
					this.saveParamValue( arrVariable[0], arrVariable[1] ); 
				}
			} else {
				this.warning("No params to parse!");
			}
		}
		private function saveParamValue($key:String, $value:*):void
		{
			this._objParamValues[ $key ] = $value;
		}
		public function getParamValue($key:String):*
		{
			return this._objParamValues[ $key ];
		}
		/*
		Get Available
		*/
		public function getAvailableValue( $key:String ):*
		{
			return this.getParamValue( $key ) || this.getLocaleValue( $key ) || this.getEnvironmentValue( $key ) || this.getSettingValue( $key ) || "";
		}
		/*
		Internal string replacement functions
		*/
		private function sanitizePaths($node:XMLList):Array
		{
			var arrFiles:Array=XMLUtil.convertToArray( $node );
			var numLength:Number=arrFiles.length;
			for (var i:Number=0; i < numLength; i++) {
				arrFiles[ i ] = this.replacePathFlag( arrFiles[ i ] );
			}
			return arrFiles;
		}
		private function replacePathFlag($path:String):String
		{
			var numLastIndex:int=$path.lastIndexOf( "]" );
			var strName:String=$path.substring( 1, numLastIndex );
			var strFile:String=$path.substring( numLastIndex + 1, $path.length );
			var strPath:String=this.getEnvironmentValue( strName ) + strFile;
			return strPath;
		}
		/*
		Property Definitions
		*/
		public function get localePrefix():String
		{
			return this.getParamValue(BedrockData.FILE_PREFIX) || this.getLocaleValue( BedrockData.FILE_PREFIX ) || this.getEnvironmentValue(BedrockData.FILE_PREFIX) || "";
		}
		public function get localeSuffix():String
		{
			return this.getParamValue(BedrockData.FILE_SUFFIX) || this.getLocaleValue( BedrockData.FILE_SUFFIX ) || this.getEnvironmentValue(BedrockData.FILE_SUFFIX) || "";
		}
	}
}

