﻿package com.autumntactics.bedrock.logging
{
	import com.autumntactics.storage.SimpleMap;
	import com.autumntactics.util.ClassUtil;
	
	import flash.utils.*;
	
	public class LogFormatter implements ILogFormatter
	{
		private var objCategoryHash:SimpleMap;
		
		public function LogFormatter()
		{
			this.createCategoryLabels();
		}
		
		private function createCategoryLabels():void
		{
			this.objCategoryHash = new SimpleMap;
			this.objCategoryHash.saveValue(LogLevel.CONSTRUCTOR.toString(), "");
			this.objCategoryHash.saveValue(LogLevel.DEBUG.toString(), "Debug");
			this.objCategoryHash.saveValue(LogLevel.ERROR.toString(), "Error");
			this.objCategoryHash.saveValue(LogLevel.FATAL.toString(), "Fatal");
			this.objCategoryHash.saveValue(LogLevel.STATUS.toString(), "Status");
			this.objCategoryHash.saveValue(LogLevel.WARNING.toString(), "Warning");
		}
		
		
		public function format($target:*, $category:int, $arguments:Array):String
		{
			var strTarget:String = this.getTargetFormat($target);
			var strCategory:String = this.getCategoryFormat($category);
			if ($arguments.length > 1) {
				return this.getSimpleFormat(strTarget, strCategory, $arguments);
			} else {
				if (LogFormatter.isObject($arguments[0]) || LogFormatter.isArray($arguments[0])) {
					return this.getComplexFormat(strTarget, strCategory, $arguments[0]);
				} else {
					return this.getSimpleFormat(strTarget, strCategory, $arguments);
				}				
			}
			
		}
		
		private function getSimpleFormat($target:*, $category:String, $arguments:Array = null):String
		{
			if ($category == "[]") {
				return $target + " : " + $arguments.join(", ");
			} else {
				return $target + " " + $category + " : " + $arguments.join(", ");
			}			
		}
		
		private function getComplexFormat($target:*, $category:String, $object:Object):String
		{
			var strReturn:String = "";
			strReturn += $target + " : " + $category + "\n";
			strReturn += ("---------------------------------------------------------------------------------" + "\n");
			strReturn += this.getObjectFormat($object);
			
			return strReturn;
		}
		
		private function getObjectFormat($object:Object, $tabs:uint = 0):String
		{
			var objTrace:Object = $object;
			var strReturn:String = "";
			for (var i in objTrace) {
				
				if (LogFormatter.isObject(objTrace[i]) || LogFormatter.isArray(objTrace[i])) {
					strReturn += this.getVariableFormat(i, objTrace[i], $tabs + 1, "+");
					for (var o in objTrace[i]) {
						strReturn += this.getVariableFormat(o, objTrace[i][o], $tabs + 2);						
					}
				} else {
					strReturn += this.getVariableFormat(i, objTrace[i], $tabs + 1);
				}
				
			}
			return strReturn;
		}
		
		private function getVariableFormat($name:String, $value:*, $tabs:uint = 0, $prefix:String = "-"):String
		{
			var strTabs:String = "";
			var numLength:int = $tabs;
			for (var i:int = 0 ; i < numLength; i++) {
				strTabs += "   ";
			}
			return (strTabs + $prefix +" [" + ClassUtil.getClassName($value) + "] " + $name + " : " + $value + "\n");
		}
		
		private function getCategoryFormat($category:int):String
		{
			return "[" + this.objCategoryHash.getValue($category.toString()) + "]"
		}
		
		/*
		Target Retreival
		*/
		private function getTargetFormat($target:*):String
		{
			if ($target is String) {
				return ($target);
			} else {
				var strTarget:String = ($target != null) ? "[" + ClassUtil.getClassName($target) + "]" : "[Global]";
				return strTarget;
			}
		}
		/*
		Check whether argument is an object
	 	*/
	 	private static function isObject($target:*):Boolean
		{
			return (getQualifiedClassName($target) == "Object") ? true : false;
		}
		private static function isArray($target:*):Boolean
		{
			return (getQualifiedClassName($target) == "Array") ? true : false;
		}
	}
}