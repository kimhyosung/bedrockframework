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
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.plugin.util.StringUtil;
	import com.bedrockframework.plugin.util.XMLUtil;
	
	import flash.display.Stage;
	import flash.system.Capabilities;	
	
	public class Config extends StaticWidget
	{
		/*
		Variable Declarations
		*/		
		private static var __objFrameworkSettings:Object;
		private static var __objEnvironmentSettings:Object;
		private static var __objPageSettings:Object;
		/*
		Constructor
		*/
		Logger.log(Config, LogLevel.CONSTRUCTOR, "Constructed");
		/*
		Initialize
		*/
		public static function initialize($data:String, $url:String, $stage:Stage):void
		{
			Config.__objFrameworkSettings = new Object;
			Config.__objEnvironmentSettings = new Object;
			Config.__objPageSettings = new Object;
			//
			Config.saveSetting(BedrockData.URL, $url);
			Config.saveSetting("manufacturer", Capabilities.manufacturer);
			Config.saveSetting(BedrockData.DEFAULT_LANGUAGE, Capabilities.language);
			Config.saveSetting(BedrockData.OS, Capabilities.os);
			Config.saveSetting("stage", $stage);
			
			Config.parseXML($data);
		}

		
		private static function parseXML($data:String):void
		{
			var xmlConfig:XML = Config.getXML($data);
			
			Config.saveSetting(BedrockData.LAYOUT, XMLUtil.getObjectArray(xmlConfig.layout));
			
			Config.saveSetting(BedrockData.DEFAULT_PAGE, Config.getDefaultPage(xmlConfig.pages));
			Config.saveSetting(BedrockData.ENVIRONMENT, Config.getEnvironment(xmlConfig.environments, Config.getSetting(BedrockData.URL)));
			Config.saveFrameworkSettings(xmlConfig.settings);
			Config.saveEnvironmentSettings(xmlConfig.environments, Config.getSetting(BedrockData.ENVIRONMENT));
			Config.saveCacheSettings();
			Config.saveLanguageSettings();
			
			Config.savePages(Config.getPages(xmlConfig.pages));			
			
			Logger.status(Config, Config.__objFrameworkSettings);
			Logger.status(Config, Config.__objEnvironmentSettings);
			
			Logger.status(Config, "Environment - " + Config.getSetting(BedrockData.ENVIRONMENT));
		}
		private static function getXML($data:String):XML
		{
			var xmlConfig:XML = new XML($data);
			xmlConfig.ignoreComments=true;
			xmlConfig.ignoreWhitespace=true;
			return xmlConfig;
		}		
		/*
		Environment Determination
	 	*/
	 	private static function getEnvironment($node:XMLList, $url:String):String
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
		private static function saveFrameworkSettings($node:XMLList):void
		{
			var objData:Object = XMLUtil.getObject($node);
			for (var d:String in objData) {
				Config.saveSetting(d, objData[d]);
			}
		}
		
		private static function saveEnvironmentSettings($node:XMLList, $environment:String):void
		{
			var xmlData:XML = new XML($node);
			
			Config.parseItems(XMLUtil.filterByAttribute(xmlData, "name", BedrockData.DEFAULT));
			Config.parseItems(XMLUtil.filterByAttribute(xmlData, "name", $environment));
			
			delete Config.__objEnvironmentSettings["patterns"];
		} 
		
		private static function saveCacheSettings():void
		{
			if (Config.getSetting(BedrockData.CACHE_PREVENTION_ENABLED)) {
				Config.saveSetting(BedrockData.CACHE_KEY, Config.createCacheKey());
			} else {
				Config.saveSetting(BedrockData.CACHE_KEY, "");
			}
		}		
		
		private static function saveLanguageSettings():void
		{
			var strLanguages:String = Config.getSetting(BedrockData.LANGUAGES);
			var arrLanguages:Array = strLanguages.split(",")
			var numLength:int = arrLanguages.length;
			for (var i:int = 0; i < numLength; i ++) {
				arrLanguages[i] = StringUtil.trim(arrLanguages[i]);
			}
			Config.saveSetting(BedrockData.LANGUAGES, arrLanguages);
			if (numLength>0) {
				Config.saveSetting(BedrockData.DEFAULT_LANGUAGE, arrLanguages[0]);	
			}			
		}
		
		private static function parseItems($xml:XML):void
		{
			var xmlTemp:XML= $xml;
			for (var s:String in xmlTemp.children()) {
				if (! xmlTemp.child(s).hasComplexContent()) {
					Config.saveValue(xmlTemp.child(s).name(), XMLUtil.sanitizeValue(xmlTemp.child(s)));
				} else {
					Config.saveValue(xmlTemp.child(s).name(), XMLUtil.getObjectArray(xmlTemp.child(s)));
				}
			}
		}

		private static function getPages($node:XMLList):Object
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
							objPage[xmlPage.child(d).name()]=Config.sanitizePaths(xmlPage.child(d));
						} else {
							objPage[xmlPage.child(d).name()]=XMLUtil.getArray(xmlPage.child(d));
						}
					}
				}
				objPages[objPage.alias] = objPage;
			}
			return objPages;
		}
		
		private static function getDefaultPage($node:XMLList):String
		{
			var xmlData:XML = new XML($node);
			var xmlDefaultPage:XML = XMLUtil.filterByAttribute($node, BedrockData.DEFAULT_PAGE, "true");
			return XMLUtil.sanitizeValue(xmlDefaultPage.alias);
		}
		
		/*
		Internal string replacement functions
		*/
		private static function sanitizePaths($node:XMLList):Array
		{
			var arrFiles:Array=XMLUtil.getArray($node);
			var numLength:Number=arrFiles.length;
			for (var i:Number=0; i < numLength; i++) {
				arrFiles[i]=Config.replacePathFlag(arrFiles[i]);
			}
			return arrFiles;
		}
		private static function replacePathFlag($path:String):String
		{
			var numLastIndex:int=$path.lastIndexOf("]");
			var strName:String=$path.substring(1,numLastIndex);
			var strFile:String=$path.substring(numLastIndex + 1,$path.length);
			var strPath:String=Config.getValue(strName) + strFile;
			return strPath;
		}
		/*
		Create Cache Key
		*/
		private static function createCacheKey():String
		{
			return StringUtil.generateUniqueKey(10);
		}
		/*
		Setters
		*/
		/*
		Save the page information for later use.
		*/
		public static function addPage($alias:String, $data:Object):void
		{
			Config.__objPageSettings[$alias] = $data;
		}
		private static function savePages($value:*):void
		{
			Config.__objPageSettings = $value;
		}
		private static function saveSetting($key:String, $value:*):void
		{
			Config.__objFrameworkSettings[$key] = $value;
		}
		private static function saveValue($key:String, $value:*):void
		{
			Config.__objEnvironmentSettings[$key] = $value;
		}		
		/*
		Getters
		*/
		/**
		 * Returns a framework setting independent of environment.
	 	*/
		public static function getSetting($key:String):*
		{
			return Config.__objFrameworkSettings[$key];
		}
		/**
		 * Returns a environment value that will change depending on the current environment.
		 * Environment values are declared in the config xml file.
	 	*/
		public static function getValue($key:String):*
		{
			return Config.__objEnvironmentSettings[$key]; 
		}
		/*
		Pull the information for a specific page.
		*/
		public static function getPage($key:String):Object
		{
			var objPage:Object= Config.__objPageSettings[$key];
			if (objPage == null) {
				Logger.warning(Config, "Page \'" + $key + "\' does not exist!");
			}
			return objPage;
		}
	}
}

