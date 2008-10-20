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
		private var _objFrameworkSettings:Object;
		private var _objEnvironmentSettings:Object;
		private var _objPageSettings:Object;
		private var _objParamSettings:Object;
		/*
		Constructor
		*/
		public function Config()
		{
			this._objFrameworkSettings = new Object;
			this._objEnvironmentSettings = new Object;
			this._objPageSettings = new Object;
			this._objParamSettings = new Object;
		}
		/*
		Initialize
		*/
		public function initialize($data:String, $url:String, $stage:Stage):void
		{
			this.saveSetting(BedrockData.URL, $url);
			this.saveSetting("manufacturer", Capabilities.manufacturer);
			this.saveSetting(BedrockData.DEFAULT_LANGUAGE, Capabilities.language);
			this.saveSetting(BedrockData.OS, Capabilities.os);
			this.saveSetting("stage", $stage);
			
			this.parseXML($data);
		}

		
		private function parseXML($data:String):void
		{
			var xmlConfig:XML = this.getXML($data);
			
			this.saveSetting(BedrockData.LAYOUT, XMLUtil.getObjectArray(xmlConfig.layout));
			
			this.saveSetting(BedrockData.DEFAULT_PAGE, this.getDefaultPage(xmlConfig.pages));
			this.saveSetting(BedrockData.ENVIRONMENT, this.getEnvironment(xmlConfig.environments, this.getSetting(BedrockData.URL)));
			this.saveFrameworkSettings(xmlConfig.settings);
			this.saveEnvironmentSettings(xmlConfig.environments, this.getSetting(BedrockData.ENVIRONMENT));
			this.saveCacheSettings();
			this.saveLanguageSettings();
			
			this.savePages(this.parsePages(xmlConfig.pages));			
			
			this.status(this._objFrameworkSettings);
			this.status(this._objEnvironmentSettings);
			
			this.status("Environment - " + this.getSetting(BedrockData.ENVIRONMENT));
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
			var arrEnvironments:Array = XMLUtil.getObjectArray(xmlEnvironments);
			var arrPatterns:Array;
			var strEnvironmentName:String;
			var numLength:int = arrEnvironments.length;

			for (var i:int = 0 ; i < numLength; i ++) {
				strEnvironmentName = XMLUtil.getAttributeObject(xmlEnvironments.environment[i]).name;
				try { 
					arrPatterns = arrEnvironments[i].patterns || new Array;
					for (var p: int =0; p < arrPatterns.length; p++) {
						if (strURL.indexOf(arrPatterns[p]) > -1) {
							return strEnvironmentName;
						}
					}
				} catch ($e:Error) {}
			}			
			return BedrockData.PRODUCTION;
		}
		/*
		Parsing Functions
		*/
		private function saveFrameworkSettings($node:XMLList):void
		{
			var objData:Object = XMLUtil.getObject($node);
			for (var d:String in objData) {
				this.saveSetting(d, objData[d]);
			}
		}
		
		private function saveEnvironmentSettings($node:XMLList, $environment:String):void
		{
			var xmlData:XML = new XML($node);
			
			this.parseItems(XMLUtil.filterByAttribute(xmlData, "name", BedrockData.DEFAULT));
			this.parseItems(XMLUtil.filterByAttribute(xmlData, "name", $environment));
			
			delete this._objEnvironmentSettings["patterns"];
		} 
		
		private function saveCacheSettings():void
		{
			if (this.getSetting(BedrockData.CACHE_PREVENTION_ENABLED)) {
				this.saveSetting(BedrockData.CACHE_KEY, this.createCacheKey());
			} else {
				this.saveSetting(BedrockData.CACHE_KEY, "");
			}
		}		
		
		private function saveLanguageSettings():void
		{
			var strLanguages:String = this.getSetting(BedrockData.LANGUAGES);
			var arrLanguages:Array = strLanguages.split(",")
			var numLength:int = arrLanguages.length;
			for (var i:int = 0; i < numLength; i ++) {
				arrLanguages[i] = StringUtil.trim(arrLanguages[i]);
			}
			this.saveSetting(BedrockData.LANGUAGES, arrLanguages);
			if (numLength>0) {
				this.saveSetting(BedrockData.DEFAULT_LANGUAGE, arrLanguages[0]);	
			}			
		}
		/*
		Parse Functions
		*/
		private function parseItems($xml:XML):void
		{
			var xmlTemp:XML= $xml;
			for (var s:String in xmlTemp.children()) {
				if (! xmlTemp.child(s).hasComplexContent()) {
					this.saveValue(xmlTemp.child(s).name(), XMLUtil.sanitizeValue(xmlTemp.child(s)));
				} else {
					this.saveValue(xmlTemp.child(s).name(), XMLUtil.getObjectArray(xmlTemp.child(s)));
				}
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
						objPage[xmlPage.child(d).name()]=XMLUtil.sanitizeValue(xmlPage.child(d));
					} else {
						if (xmlPage.child(d).name() == "files") {
							objPage[xmlPage.child(d).name()]=this.sanitizePaths(xmlPage.child(d));
						} else {
							objPage[xmlPage.child(d).name()]=XMLUtil.getArray(xmlPage.child(d));
						}
					}
				}
				objPages[objPage.alias] = objPage;
			}
			return objPages;
		}
		public function parseParamString($values:String, $variableSeparator:String ="&", $valueSeparator:String =  "="):void
		{
			if ($values != null) {
				var strValues:String = $values;
				var strVariableSeparator:String = $variableSeparator;
				var strValueSeparator:String = $valueSeparator;
				//
				var arrValues:Array = strValues.split(strVariableSeparator);
				//
				var strOutput:String = "Parse Result";
				//				
				for (var v:int = 0; v < arrValues.length; v++) {
					var arrVariable:Array = arrValues[v].split(strValueSeparator);
					this._objParamSettings[arrVariable[0]] =   arrVariable[1];
					strOutput += ("\n   - " + arrVariable[0] + " = " + arrVariable[1]);
				}
				this.status(strOutput);
			} else {
				this.warning("Nothing to parse!");
			}
		}
		
		
		/*
		Internal string replacement functions
		*/
		private function sanitizePaths($node:XMLList):Array
		{
			var arrFiles:Array=XMLUtil.getArray($node);
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
			var strPath:String=this.getValue(strName) + strFile;
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
			this._objPageSettings[$alias] = $data;
		}
		private function savePages($value:*):void
		{
			this._objPageSettings = $value;
		}
		private function saveSetting($key:String, $value:*):void
		{
			this._objFrameworkSettings[$key] = $value;
		}
		private function saveValue($key:String, $value:*):void
		{
			this._objEnvironmentSettings[$key] = $value;
		}
		public function saveParams($data:Object):void
		{
			for (var d:String in $data){
				this._objParamSettings[d] =VariableUtil.sanitize($data[d]);
			}
		}
		/*
		Getters
		*/
		/**
		 * Returns a framework setting independent of environment.
	 	*/
		public function getSetting($key:String):*
		{
			return this._objFrameworkSettings[$key];
		}
		/**
		 * Returns a environment value that will change depending on the current environment.
		 * Environment values are declared in the config xml file.
	 	*/
		public function getValue($key:String):*
		{
			return this._objEnvironmentSettings[$key]; 
		}
		/*
		Pull the information for a specific page.
		*/
		public function getPage($key:String):Object
		{
			var objPage:Object= this._objPageSettings[$key];
			if (objPage == null) {
				this.warning("Page \'" + $key + "\' does not exist!");
			}
			return objPage;
		}
		public function getParam($key:String):*
		{
			return this._objParamSettings[$key];
		}
		
		
		private function getDefaultPage($node:XMLList):String
		{
			var xmlData:XML = new XML($node);
			var xmlDefaultPage:XML = XMLUtil.filterByAttribute($node, BedrockData.DEFAULT_PAGE, "true");
			return XMLUtil.sanitizeValue(xmlDefaultPage.alias);
		}
	}
}

