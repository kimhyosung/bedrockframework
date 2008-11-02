package com.bedrockframework.plugin.util
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.plugin.storage.HashMap;
	
	import flash.utils.*;
	import flash.xml.*;

	public class XMLUtil extends StaticWidget
	{
		public static function convertToObject($node:*):Object
		{
			var objAnalysis:Object = new Object;
			var xmlTemp:XMLList = new XMLList($node);
			var numLength:Number = xmlTemp.children().length();
			var strName:String;
			var xmlValue:XMLList;
			var arrNodes:Array;
			for (var i:int = 0; i  < numLength; i++) {
				xmlValue = xmlTemp.child(i);
				strName = xmlTemp.child(i).name();
				if (objAnalysis[strName] == null) {
					if (xmlValue.hasComplexContent()) {
						objAnalysis[strName] = XMLUtil.convertToObject(xmlValue);
					} else {
						objAnalysis[strName] = XMLUtil.convertValue(xmlValue);
					}					
				} else {
					if (objAnalysis[strName] is Array) {
						objAnalysis[strName].push(convertToObject(xmlValue));
					} else {
						arrNodes = new Array(objAnalysis[strName]);
						objAnalysis[strName] = arrNodes
						objAnalysis[strName].push(XMLUtil.convertToObject(xmlValue));
					}
				}
			}
			return objAnalysis;
		}
		public static function convertToArray($node:*):Array
		{
			var arrReturn:Array = new Array();
			var xmlTemp:XMLList = new XMLList($node);
			var numLength:Number = xmlTemp.children().length();
			for (var i:int = 0; i < numLength; i ++) {
				arrReturn.push(XMLUtil.convertToObject(xmlTemp.child(i)));
			}
			return arrReturn;
		}
		public static function convertToHashMap($node:*):HashMap
		{
			var objResultMap:HashMap = new HashMap;
			var objConverted:Object = XMLUtil.convertToObject($node);
			for (var c:String in objConverted) {
				objResultMap.saveValue(c, objConverted[c]);
			}
			return objResultMap;
		}
		
		public static function convertValue($node:*):*
		{
			return VariableUtil.sanitize($node.toString());
		}
		
		public static function getAttributeObject($node:*):Object
		{
			var objResult:Object = new Object();
			
			var xmlTemp:XMLList = new XMLList($node);
			var xmlAttributes:XMLList = xmlTemp.attributes();
			
			var numLength:int = xmlAttributes.length();		
			for (var i:int = 0; i < numLength; i ++) {
				objResult[xmlAttributes[i].name().toString()] = XMLUtil.convertValue(xmlAttributes[i]);
			}	
				
			return objResult;
		}
		
		
		public static function filterByAttribute($node:*, $attribute:String, $value:String):XML
		{
			var xmlData:XML = new XML($node);
			var xmlList:XMLList = xmlData.children().(attribute($attribute) == $value);
			return new XML(xmlList);
		}
		public static function filterByNode($node:*, $name:String, $value:String):XML
		{
			var xmlData:XML = new XML($node);
			var xmlList:XMLList = xmlData.children().(child($name) == $value);
			return new XML("<root>" + xmlList.toString() + "</root>");
		}
		
		
	}
}