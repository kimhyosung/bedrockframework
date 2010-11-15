package com.bedrock.framework.plugin.util
{
	import com.bedrock.framework.core.base.StaticBase;

	public class CoreUtil extends StaticBase
	{
		public function CoreUtil()
		{
			super();
		}
		public static function objectHasValues( $target:*, $values:Array ):Boolean
		{
			for each ( var value:String in $values ) {
				if ( $target[ value ] == null || $target[ value ] == undefined ) return false;
			}
			return true;
		}
		
		public static function sanitize($value:String):*
		{
			var strValue:String = $value;
			
			if (strValue == "") return "";
			if (strValue == "null") return null;

			var numValue:Number = Number(strValue);

			if ( !isNaN(numValue) ) return numValue;
			
			if ( CoreUtil.sanitizeBoolean(strValue) != null ) return CoreUtil.sanitizeBoolean(strValue);
			
			return strValue;
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
	}
}