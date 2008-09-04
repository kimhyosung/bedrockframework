package com.autumntactics.util
{
	import flash.utils.*;
	public class ClassUtil
	{
		public static function getDisplayClassName($instance:Object):String
		{
			return "[" + ClassUtil.getClassName($instance) +"]";
		}
		public static function getClassName($instance:Object):String
		{
			var strName:String=getQualifiedClassName($instance);
			strName=strName.slice(strName.lastIndexOf(":") + 1,strName.length);
			return strName;
		}
		public static function getClass($name:String):Class
		{
			try {
				var clsReference:Class = getDefinitionByName($name) as Class;
			} catch ($error:Error) {
				throw new TypeError($name);
			}
			return clsReference;
		}
		public static function getDescription($object:*):Object
		{
			var objResult:Object = new Object();
			var xmlDescription:XML = describeType($object);
			
			return objResult;
		}
	}
}