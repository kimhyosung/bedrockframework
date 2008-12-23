package com.bedrockframework.plugin.util
{
	import flash.utils.ByteArray;
	import com.bedrockframework.core.base.StaticWidget;

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
		
		public static function combineObjects($data1:Object, $data2:Object):Object
		{
			var objResult:Object = new Object();
			
			for (var d1:String in $data1) {
				objResult[d1] = $data1[d1];
			}
			for (var d2:String in $data2) {
				objResult[d2] = $data2[d2];
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
        public static function clone($reference:*):Object
        {
            var arrBytes:ByteArray = new ByteArray();
            arrBytes.writeObject($reference);
            arrBytes.position = 0;

            return arrBytes.readObject();
        }
		
	}
}