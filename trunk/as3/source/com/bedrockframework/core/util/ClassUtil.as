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
package com.bedrockframework.core.util
{
	import flash.utils.*;
	import com.bedrockframework.core.base.StaticWidget;
	
	public class ClassUtil extends StaticWidget
	{
		public static function getDisplayClassName($instance:Object):String
		{
			return "[" + ClassUtil.getClassName($instance) +"]";
		}
		public static function getClassName($instance:Object):String
		{
			var strName:String = getQualifiedClassName($instance);
			strName=strName.slice(strName.lastIndexOf(":") + 1,strName.length);
			return strName;
		}
		public static function getClass($name:String):Class
		{
			var clsReference:Class;
			try {
				clsReference = getDefinitionByName($name) as Class;
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