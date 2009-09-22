﻿package com.bedrockframework.plugin.util
{
	import com.bedrockframework.core.base.StaticWidget;
	
	import flash.utils.ByteArray;

	public class VariableUtil extends StaticWidget
	{

		public static function sanitize($value:String):*
		{
			var strValue:String = $value;
			
			if (strValue == "") return "";
			if (strValue == "null") return null;

			var numValue:Number = Number(strValue);

			if (!isNaN(numValue)) return numValue;
			
			if (VariableUtil.sanitizeBoolean(strValue) != null) return VariableUtil.sanitizeBoolean(strValue);
			
			return strValue;
		}
		
		public static function combineObjects( ...$objects:Array):Object
		{
			var objResult:Object = new Object();
			
			var objData:Object;
			var numLength:int = $objects.length;
			for (var i:int = 0 ; i < numLength; i++) {
				objData = $objects[ i ];
				for (var d:String in objData) {
					objResult[d] = objData[d];
				}
			}
			
			return objResult;
		}
		
		public static function duplicateObject($data:Object):Object
		{
			var objResult:Object = new Object();
			for (var d:String in $data) {
				objResult[d] = $data[d];
			}
			return objResult;
		}
		
		public static function sanitizeBoolean($boolean:*):*
		{
			var strBoolean:String =  $boolean.toLowerCase();
			if (strBoolean != "true" && strBoolean != "false") {
				return null;
			} else {
				return (strBoolean == "true") ? true:false;
			}
		}
		 /**
         * 
         * Creates a deep copy (clone) of a reference object to a new 
         * memory address
         *
         * @param   reference object in which to clone
         * @return  a clone of the original reference object
         * 
         */
        public static function clone($reference:*):*
        {
            var arrBytes:ByteArray = new ByteArray();
            arrBytes.writeObject($reference);
            arrBytes.position = 0;

            return arrBytes.readObject();
        }
		
	}
}