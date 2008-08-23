/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@autumntactics.com
 * website: http://www.autumntactics.com/
 * blog: http://blog.autumntactics.com/
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
		private static var __objSectionSettings:Object;
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
			Config.__objSectionSettings = new Object;
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
			
			Config.saveSetting(BedrockData.DEFAULT_SECTION, Config.getDefaultSection(xmlConfig.sections));
			Config.saveSetting(BedrockData.ENVIRONMENT, Config.getEnvironment(xmlConfig.environments, Config.getSetting(BedrockData.URL)));
			Config.saveFrameworkSettings(xmlConfig.settings);
			Config.saveEnvironmentSettings(xmlConfig.environments, Config.getSetting(BedrockData.ENVIRONMENT));
			Config.saveCacheSettings();
			Config.saveLanguageSettings();
			
			Config.saveSections(Config.getSections(xmlConfig.sections));			
			
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

		private static function getSections($node:XMLList):Object
		{
			var objSections:Object = new Object  ;
			var xmlSections:XML=new XML($node);
			var xmlSection:XMLList;
			//
			var objSection:Object;
			for (var s:String in xmlSections.children()) {
				objSection=new Object();
				xmlSection=xmlSections.child(s);
				for (var d:String in xmlSection.children()) {
					if (! xmlSection.child(d).hasComplexContent()) {
						objSection[xmlSection.child(d).name()]=XMLUtil.sanitizeValue(xmlSection.child(d));
					} else {
						if (xmlSection.child(d).name() == "files") {
							objSection[xmlSection.child(d).name()]=Config.sanitizePaths(xmlSection.child(d));
						} else {
							objSection[xmlSection.child(d).name()]=XMLUtil.getArray(xmlSection.child(d));
						}
					}
				}
				objSections[objSection.alias] = objSection;
			}
			return objSections;
		}
		
		private static function getDefaultSection($node:XMLList):String
		{
			var xmlData:XML = new XML($node);
			var xmlDefaultSection:XML = XMLUtil.filterByAttribute($node, BedrockData.DEFAULT_SECTION, "true");
			return XMLUtil.sanitizeValue(xmlDefaultSection.alias);
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
		private static function saveSections($value:*):void
		{
			Config.__objSectionSettings = $value;
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
		public static function getSection($key:String):Object
		{
			var objSection:Object= Config.__objSectionSettings[$key];
			if (objSection == null) {
				Logger.warning(Config, "Section \'" + $key + "\' does not exist!");
			}
			return objSection;
		}
	}
}

