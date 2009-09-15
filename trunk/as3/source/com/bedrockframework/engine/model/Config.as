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
	import com.bedrockframework.plugin.util.StringUtil;
	import com.bedrockframework.plugin.util.VariableUtil;
	import com.bedrockframework.plugin.util.XMLUtil;
	
	import flash.display.Stage;
	import flash.system.Capabilities;	
	
	public class Config extends StandardWidget implements IConfig
	{
		/*
		Variable Declarations
		*/		
		private var _objFrameworkValues:Object;
		private var _objEnvironmentValues:Object;
		private var _objPageValues:Object;
		private var _objParamValues:Object;
		private var _objLocaleValues:Object;
		/*
		Constructor
		*/
		public function Config()
		{
			this._objFrameworkValues = new Object;
			this._objEnvironmentValues = new Object;
			this._objPageValues = new Object;
			this._objParamValues = new Object;
			this._objLocaleValues = new Object;
		}
		/*
		Initialize
		*/
		public function initialize($data:String, $url:String, $stage:Stage):void
		{
			this.saveFrameworkValue(BedrockData.URL, $url);
			this.saveFrameworkValue(BedrockData.MANUFACTURER, Capabilities.manufacturer);
			this.saveFrameworkValue(BedrockData.SYSTEM_LANGUAGE, Capabilities.language);
			this.saveFrameworkValue(BedrockData.OS, Capabilities.os);
			this.saveFrameworkValue("stage", $stage);
			
			this.parseXML($data);
		}

		
		private function parseXML($data:String):void
		{
			var xmlConfig:XML = this.getXML($data);
			
			this.saveFrameworkValue( BedrockData.LAYOUT, XMLUtil.convertToArray( xmlConfig.layout, true ) );
			this.saveFrameworkValue( BedrockData.DEFAULT_PAGE, this.getDefaultPage(xmlConfig.pages) );
			this.saveFrameworkValue( BedrockData.ENVIRONMENT, this.getEnvironment(xmlConfig.environments, this.getFrameworkValue(BedrockData.URL)));
			
			this.saveFrameworkValues( xmlConfig.settings );
			this.saveEnvironmentValues( xmlConfig.environments, this.getFrameworkValue( BedrockData.ENVIRONMENT ) );
			this.saveCacheSettings();
			this.saveLanguageSettings();
			
			this.savePages( this.parsePages(xmlConfig.pages) );			
			
			this.status( this._objParamValues );
			this.status( this._objFrameworkValues );
			this.status( this._objEnvironmentValues );
			
			this.status("Environment - " + this.getFrameworkValue(BedrockData.ENVIRONMENT));
		}
		private function getXML($data:String):XML
		{
			var xmlConfig:XML = new XML($data);
			XML.ignoreComments=true;
			XML.ignoreWhitespace=true;
			return xmlConfig;
		}		
		/*
		Environment Determination
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
		/*
		Parsing Functions
		*/
		private function saveFrameworkValues($node:XMLList):void
		{
			var objData:Object = XMLUtil.convertToObject($node);
			for (var d:String in objData) {
				this.saveFrameworkValue(d, objData[d]);
			}
		}
		
		private function saveEnvironmentValues($node:XMLList, $environment:String):void
		{
			var xmlData:XML = new XML($node);
			
			this.parseEnvironmentValues(XMLUtil.filterByAttribute(xmlData, "name", BedrockData.DEFAULT));
			this.parseEnvironmentValues(XMLUtil.filterByAttribute(xmlData, "name", $environment));
			
			delete this._objEnvironmentValues["patterns"];
		}
		
		private function saveLocaleValues( $node:XMLList, $locale:String ):void
		{
			
		}
		
		private function parseEnvironmentValues($xml:XML):void
		{
			var objData:Object = XMLUtil.convertToObject($xml);
			for (var d:String in objData) {
				this.saveEnvironmentValue(d, objData[d]);
			}
		}
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
		/*
		Param Parsing Functions
		*/
		public function parseParamObject($data:Object):void
		{
			for (var d:String in $data){
				this._objParamValues[d] =VariableUtil.sanitize($data[d]);
			}
		}
		public function parseParamString($values:String, $variableSeparator:String ="&", $valueSeparator:String =  "="):void
		{
			if ($values != null) {
				var strValues:String = $values;
				var strVariableSeparator:String = $variableSeparator;
				var strValueSeparator:String = $valueSeparator;
				//
				var arrValues:Array = strValues.split(strVariableSeparator);
				var numLength:int = arrValues.length;
				for (var v:int = 0; v < numLength; v++) {
					var arrVariable:Array = arrValues[v].split(strValueSeparator);
					this._objParamValues[arrVariable[0]] =   arrVariable[1];
				}
			} else {
				this.warning("No params to parse!");
			}
		}
		
		/*
		Settings
		*/
		private function saveCacheSettings():void
		{
			if (this.getFrameworkValue(BedrockData.CACHE_PREVENTION_ENABLED)) {
				this.saveFrameworkValue(BedrockData.CACHE_KEY, this.createCacheKey());
			} else {
				this.saveFrameworkValue(BedrockData.CACHE_KEY, "");
			}
		}		
		
		private function saveLanguageSettings():void
		{
			var strLanguages:String = this.getFrameworkValue(BedrockData.LANGUAGES);
			var arrLanguages:Array = strLanguages.split(",")
			var numLength:int = arrLanguages.length;
			for (var i:int = 0; i < numLength; i ++) {
				arrLanguages[i] = StringUtil.trim(arrLanguages[i]);
			}
			this.saveFrameworkValue(BedrockData.LANGUAGES, arrLanguages);
			if (numLength > 0 && this.getFrameworkValue( BedrockData.DEFAULT_LANGUAGE ) == null ) {
				this.saveFrameworkValue( BedrockData.DEFAULT_LANGUAGE, arrLanguages[0]);	
			}			
		}
		
		/*
		Internal string replacement functions
		*/
		private function sanitizePaths($node:XMLList):Array
		{
			var arrFiles:Array=XMLUtil.convertToArray($node);
			var numLength:Number=arrFiles.length;
			for (var i:Number=0; i < numLength; i++) {
				arrFiles[i]=this.replacePathFlag(arrFiles[i]);
			}
			return arrFiles;
		}
		private function replacePathFlag($path:String):String
		{
			var numLastIndex:int=$path.lastIndexOf("]");
			var strName:String=$path.substring(1,numLastIndex);
			var strFile:String=$path.substring(numLastIndex + 1,$path.length);
			var strPath:String=this.getEnvironmentValue(strName) + strFile;
			return strPath;
		}
		/*
		Create Cache Key
		*/
		private function createCacheKey():String
		{
			return StringUtil.generateUniqueKey(10);
		}
		/*
		Setters
		*/
		/*
		Save the page information for later use.
		*/
		public function addPage($alias:String, $data:Object):void
		{
			this._objPageValues[$alias] = $data;
		}
		private function savePages($value:*):void
		{
			this._objPageValues = $value;
		}
		private function saveFrameworkValue($key:String, $value:*):void
		{
			this._objFrameworkValues[$key] = $value;
		}
		private function saveEnvironmentValue($key:String, $value:*):void
		{
			this._objEnvironmentValues[$key] = $value;
		}
		/*
		Getters
		*/
		/**
		 * Returns a framework setting independent of environment.
	 	*/
		public function getFrameworkValue($key:String):*
		{
			return this._objFrameworkValues[$key];
		}
		/**
		 * Returns a environment value that will change depending on the current environment.
		 * Environment values are declared in the config xml file.
	 	*/
		public function getEnvironmentValue($key:String):*
		{
			return this._objEnvironmentValues[$key]; 
		}
		/*
		Pull the information for a specific page.
		*/
		public function getPage($key:String):Object
		{
			var objPage:Object= this._objPageValues[$key];
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
		public function getParamValue($key:String):*
		{
			return this._objParamValues[$key];
		}
		
		
		private function getDefaultPage($node:XMLList):String
		{
			var xmlData:XML = new XML($node);
			var xmlDefaultPage:XML = XMLUtil.filterByAttribute($node, BedrockData.DEFAULT_PAGE, "true");
			return XMLUtil.convertValue(xmlDefaultPage.alias);
		}
		/*
		Property Definitions
		*/
		public function get localePrefix():String
		{
			return this.getParamValue(BedrockData.LOCALE_PREFIX) || this.getEnvironmentValue(BedrockData.LOCALE_PREFIX) || "";
		}
		public function get localeSuffix():String
		{
			return this.getParamValue(BedrockData.LOCALE_SUFFIX) || this.getEnvironmentValue(BedrockData.LOCALE_SUFFIX) || "";
		}
	}
}

