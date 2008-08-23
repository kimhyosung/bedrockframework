package com.bedrockframework.plugin.util
{
	import flash.utils.*;
	import flash.xml.*;
	import com.bedrockframework.core.base.StaticWidget;

	public class XMLUtil extends StaticWidget
	{
		/*
		Alex, you need to create a more sophisticated system for checks.
	 	*/
		public static function getObjectArray($node:*):Array
		{
			var xmlTemp:XMLList = new XMLList($node);
			var numLength:Number = xmlTemp.children().length();
			var arrReturn:Array = new Array();
			if (xmlTemp.hasComplexContent()) {
				for (var i:int = 0; i < numLength; i ++) {
					if (xmlTemp.child(i).hasComplexContent()) {
						arrReturn.push(XMLUtil.getObject(xmlTemp.child(i)));
					} else {
						arrReturn.push(XMLUtil.sanitizeValue(xmlTemp.child(i)));
					}			
				}
			}
			return arrReturn;
		}
		public static function getObject($node:*):Object
		{
			var xmlTemp:XMLList = new XMLList($node);
			var objTemp:Object = new Object();
			if (xmlTemp.hasComplexContent()) {
				var numLength:Number = xmlTemp.children().length();
				for (var i:int = 0; i  < numLength; i++) {
					if (!xmlTemp.child(i).hasComplexContent()) {
						objTemp[xmlTemp.child(i).name()] = XMLUtil.sanitizeValue(xmlTemp.child(i));
					}else{
						objTemp[xmlTemp.child(i).name()] = XMLUtil.getObjectArray(xmlTemp.child(i));
					}
				}
				return objTemp;
			}
			return null;
		}
		public static function getArray($node:*):Array
		{
			var arrReturn:Array = new Array();
			var xmlTemp:XMLList = new XMLList($node);			
			
			var numLength:Number = xmlTemp.children().length();
			if (xmlTemp.hasComplexContent()) {
				for (var i:int = 0; i < numLength; i ++) {
					arrReturn.push(XMLUtil.sanitizeValue(xmlTemp.child(i)));
				}
			}
			return arrReturn;
		}
		
		public static function getAttributeObject($node:*):Object
		{
			var objResult:Object = new Object();
			
			var xmlTemp:XMLList = new XMLList($node);
			var xmlAttributes:XMLList = xmlTemp.attributes();
			
			var numLength:int = xmlAttributes.length();		
			for (var i:int = 0; i < numLength; i ++) {
				objResult[xmlAttributes[i].name().toString()] = XMLUtil.sanitizeValue(xmlAttributes[i]);
			}	
				
			return objResult;
		}
		public static function sanitizeValue($node:*):*
		{
			return VariableUtil.sanitize($node.toString());
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