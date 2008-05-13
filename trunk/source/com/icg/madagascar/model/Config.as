package com.icg.madagascar.model
{
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.madagascar.output.Outputter;
	import com.icg.util.StringUtil;
	import com.icg.util.XMLUtil;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;	
	
	public class Config extends StaticWidget
	{
		/*
		Constants
		*/
		public static const ENVIRONMENT:String = "environment";
		public static const CACHE_KEY:String = "cache_key";
		public static const CACHE_PREVENTION:String = "cache_prevention";
		/*
		Variable Declarations
		*/
		
		private static var OUTPUT:Outputter = new Outputter(Config);
		private static var OBJ_URL_LOADER:URLLoader;	
		private static var OBJ_FRAMEWORK_SETTINGS:ConfigData;
		private static var OBJ_ENVIRONMENT_SETTINGS:ConfigData;
		private static var FN_CALLBACK:Function;
		/*
		Constructor
		*/
		public static function initialize($path:String,$url:String, $callback:Function, $stage:Stage):void
		{
			Config.OBJ_FRAMEWORK_SETTINGS = new ConfigData();
			Config.OBJ_ENVIRONMENT_SETTINGS = new ConfigData();
			Config.FN_CALLBACK = $callback;
			//
			Config.saveSetting("url", $url);
			Config.saveSetting("manufacturer", Capabilities.manufacturer);
			Config.saveSetting("language", Capabilities.language);
			Config.saveSetting("os", Capabilities.os);
			Config.saveSetting("stage", $stage);
			//
			Config.loadXML($path);
		}

		/*
		XML Functions
		*/
		private static function loadXML($path:String):void
		{
			Config.OBJ_URL_LOADER = new URLLoader();
			Config.OBJ_URL_LOADER.addEventListener(Event.COMPLETE, Config.onXMLProcess,false,0,true);
			Config.OBJ_URL_LOADER.addEventListener(IOErrorEvent.IO_ERROR, Config.onXMLError,false,0,true);
			Config.OBJ_URL_LOADER.addEventListener(SecurityErrorEvent.SECURITY_ERROR, Config.onXMLError,false,0,true);
			Config.OBJ_URL_LOADER.load(new URLRequest($path));
		}
		private static function parseXML($data:String):void
		{
			var xmlConfig:XML = Config.getXML($data);			
			
			Config.saveSetting("environment", Config.getEnvironment(xmlConfig.environments, Config.getSetting("url")));
			Config.saveSetting("layout", XMLUtil.getObjectArray(xmlConfig.layout));
			
			Config.saveSetting("default_section", Config.getDefaultSection(xmlConfig.sections));
			
			Config.saveFrameworkSettings(xmlConfig.settings);
			Config.saveEnvironmentSettings(xmlConfig.environments, Config.getSetting("environment"));
			Config.saveCacheSettings();
			Config.saveLanguageSettings();
			
			Config.saveSetting("sections", Config.getSections(xmlConfig.sections));			
			
			Config.OUTPUT.output(Config.OBJ_FRAMEWORK_SETTINGS);
			Config.OUTPUT.output(Config.OBJ_ENVIRONMENT_SETTINGS);
			
			Config.OUTPUT.output("Environment - " + Config.getSetting("environment"));
			
			Config.FN_CALLBACK();
		}
		private static function getXML($data:String):XML
		{
			var xmlConfig:XML = new XML($data);
			xmlConfig.ignoreComments=true;
			xmlConfig.ignoreWhitespace=true;
			return xmlConfig;
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
			
			Config.OBJ_ENVIRONMENT_SETTINGS.deleteValue("patterns");
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
		private static function getEnvironment($node:XMLList, $url:String):String
		{
			var strURL:String = $url;
			
			var xmlEnvironments:XML=new XML($node);
			var arrEnvironments:Array = XMLUtil.getObjectArray(xmlEnvironments);
			
			var arrPatterns:Array;
			var strEnvironmentName:String;
			var numLength:int = arrEnvironments.length;
			var numMatchIndex:int;

			for (var i:int = 0 ; i < numLength; i ++) {
				strEnvironmentName = XMLUtil.getAttributeObject(xmlEnvironments.environment[i]).name;
				try { 
					arrPatterns = arrEnvironments[i].patterns || new Array;
					for (var p: int =0 ; i < arrPatterns.length; i++) {
						numMatchIndex = strURL.indexOf(arrPatterns[p]);
						if (numMatchIndex > -1) {
							return strEnvironmentName;
						}
					}
				} catch ($e:Error) {}
			}			
			return "production";
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
		private static function saveSetting($key:String, $value:Object):void
		{
			Config.OBJ_FRAMEWORK_SETTINGS.setValue($key, $value);
		}
		private static function saveValue($key:String, $value:Object):void
		{
			Config.OBJ_ENVIRONMENT_SETTINGS.setValue($key, $value);
		}		
		/*
		Getters
		*/
		public static function getSetting($key:String):*
		{
			return Config.OBJ_FRAMEWORK_SETTINGS.getValue($key);
		}
		public static function getValue($key:String):*
		{
			return Config.OBJ_ENVIRONMENT_SETTINGS.getValue($key); 
		}
		/*
		Event Handlers
		*/
		private static function onXMLProcess($event:Event):void
		{
			Config.parseXML(Config.OBJ_URL_LOADER.data);
		}
		private static function onXMLError($event:Event):void
		{
			OUTPUT.output("Could not parse config!", "error")
		}
	}
}
dynamic class ConfigData
{
	public function setValue($key:String, $value:*):void
	{
		this[$key] = $value;
	}
	
	public function getValue($key:String):*
	{
		return this[$key];
	}
	public function deleteValue($key):void
	{
		delete this[$key];
	}
}

