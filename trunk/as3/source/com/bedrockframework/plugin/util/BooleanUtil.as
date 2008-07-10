package com.bedrockframework.plugin.util
{
	import com.bedrockframework.core.base.StaticWidget;
	
	public class BooleanUtil extends StaticWidget
	{
		/*
		Sanitize Boolean
		*/
		public static function sanitize($boolean):*
		{
			var strBoolean:String =  $boolean.toLowerCase();
			if (strBoolean.search("true") == -1 && strBoolean.search("false") == -1 ) {
				return null;
			} else {
				return (strBoolean.search("true") != -1)?true:false;
			}
		}
		/*
		Toggle Boolean
		*/
		public static function toggle($boolean:Boolean):Boolean
		{
			if ($boolean == true) {
				return false;
			} else {
				return true;
			}
		}
	}
}