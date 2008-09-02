package com.builtonbedrock.bedrock.model
{
	import com.builtonbedrock.bedrock.base.StaticWidget;
	import com.builtonbedrock.bedrock.output.Outputter;
	import com.builtonbedrock.util.StringUtil;
	import com.builtonbedrock.util.XMLUtil;
	import com.builtonbedrock.bedrock.logging.LogLevel;
	import com.builtonbedrock.bedrock.logging.Logger;
	import flash.display.Stage;
	import flash.system.Capabilities;	
	
	public class Config extends StaticWidget
	{
		/*
		Variable Declarations
		*/			
		private static var OBJ_FRAMEWORK_SETTINGS:Object;
		private static var OBJ_ENVIRONMENT_SETTINGS:Object;
		
		Logger.log(Config, LogLevel.CONSTRUCTOR, "Constructed");
		/*
		Initialize
		*/
		public static function initialize($data:String, $url:String, $stage:Stage):void
		{
			Config.OBJ_FRAMEWORK_SETTINGS = new Object;
			Config.OBJ_ENVIRONMENT_SETTINGS = new Object;
			//
			Config.saveSetting("url", $url);			
			Config.saveSetting("manufacturer", Capabilities.manufacturer);
			Config.saveSetting("language", Capabilities.language);
			Config.saveSetting("os", Capabilities.os);
			Config.saveSetting("stage", $stage);
			
			Config.parseXML($data);
		}

		
		private static function parseXML($data:String):void
		{
			var xmlConfig:XML = Config.getXML($data);			
			
			
			Config.saveSetting("layout", XMLUtil.getObjectArray(xmlConfig.layout));
			
			Config.saveSetting("default_section", Config.getDefaultSection(xmlConfig.sections));
			Config.saveSetting("environment", Config.getEnvironment(xmlConfig.environments, Config.getSetting("url")));
			Config.saveFrameworkSettings(xmlConfig.settings);
			Config.saveEnvironmentSettings(xmlConfig.environments, Config.getSetting("environment"));
			Config.saveCacheSettings();
			Config.saveLanguageSettings();
			
			Config.saveSetting("sections", Config.getSections(xmlConfig.sections));			
			
			Logger.status(Config, Config.OBJ_FRAMEWORK_SETTINGS);
			Logger.status(Config, Config.OBJ_ENVIRONMENT_SETTINGS);
			
			Logger.status(Config, "Environment - " + Config.getSetting("environment"));
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
			return "production";
		}
		/*
		Parsing Functions
		*/
		private static function saveFrameworkSettings($node:XMLList):void
		{
			var objData:Object = XMLUtil.getObject($node);
			for (var d in objData) {
				Config.saveSetting(d, objData[d]);
			}
		}
		
		private static function saveEnvironmentSettings($node:XMLList, $environment:String):void
		{
			var xmlData:XML = new XML($node);
			
			var xmlDefaultSettings:XMLList = XMLUtil.filterByAttribute(xmlData, "name", "default");
			var xmlEnvironmentSettings:XMLList = XMLUtil.filterByAttribute(xmlData, "name", $environment);
			
			Config.parseItems(xmlDefaultSettings);
			Config.parseItems(xmlEnvironmentSettings);
			
			delete Config.OBJ_ENVIRONMENT_SETTINGS["patterns"];
		} 
		
		private static function saveCacheSettings():void
		{
			if (Config.getSetting("cache_prevention")) {
				Config.saveSetting("cache_key", Config.createCacheKey());
			} else {
				Config.saveSetting("cache_key", "");
			}
		}		
		
		private static function saveLanguageSettings():void
		{
			var strLanguages:String = Config.getSetting("languages");
			var arrLanguages:Array = strLanguages.split(",")
			var numLength:int = arrLanguages.length;
			for (var i:int = 0; i < numLength; i ++) {
				arrLanguages[i] = StringUtil.trim(arrLanguages[i]);
			}
			Config.saveSetting("languages", arrLanguages);
			if (numLength>0) {
				Config.saveSetting("default_language", arrLanguages[0]);	
			}			
		}
		
		private static function parseItems($node:XMLList):void
		{
			var xmlTemp:XML=new XML($node);
			for (var s:String in xmlTemp.children()) {
				if (! xmlTemp.child(s).hasComplexContent()) {
					Config.saveValue(xmlTemp.child(s).name(), XMLUtil.sanitizeValue(xmlTemp.child(s)));
				} else {
					Config.saveValue(xmlTemp.child(s).name(), XMLUtil.getObjectArray(xmlTemp.child(s)));
				}
			}
		}

		private static function getSections($node:XMLList):Array
		{
			var arrSections:Array=new Array  ;
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
				arrSections.push(objSection);
			}
			return arrSections;
		}
		
		private static function getDefaultSection($node:XMLList):String
		{
			var xmlData:XML = new XML($node);
			var xmlDefaultSection:XMLList = XMLUtil.filterByAttribute(xmlData, "default", "true")
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
		private static function saveSetting($key:String, $value:*):void
		{
			Config.OBJ_FRAMEWORK_SETTINGS[$key] = $value;
		}
		private static function saveValue($key:String, $value:*):void
		{
			Config.OBJ_ENVIRONMENT_SETTINGS[$key] = $value;
		}		
		/*
		Getters
		*/
		public static function getSetting($key:String):*
		{
			return Config.OBJ_FRAMEWORK_SETTINGS[$key];
		}
		public static function getValue($key:String):*
		{
			return Config.OBJ_ENVIRONMENT_SETTINGS[$key]; 
		}
	}
}

