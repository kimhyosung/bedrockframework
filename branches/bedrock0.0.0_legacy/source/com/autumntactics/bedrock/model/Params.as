package com.builtonbedrock.bedrock.model
{
	import com.builtonbedrock.bedrock.base.StaticWidget;
	import com.builtonbedrock.bedrock.output.Outputter;
	import com.builtonbedrock.storage.SimpleMap;
	import com.builtonbedrock.util.VariableUtil;
	import com.builtonbedrock.bedrock.logging.Logger;
	import com.builtonbedrock.bedrock.logging.LogLevel;

	public class Params extends StaticWidget
	{
		/*
		Variable Declarations
		*/
		private static  var OBJ_VALUE_MAP:SimpleMap = new SimpleMap();
		
		Logger.log(Params, LogLevel.CONSTRUCTOR, "Constructed");

		/*
		Parse Values
		*/
		public static function parse($values:String, $variableSeparator:String ="&", $valueSeparator:String =  "="):void
		{
			if ($values != null) {
				var strValues:String = $values;
				var strVariableSeparator:String = $variableSeparator;
				var strValueSeparator:String = $valueSeparator;
				//
				var arrValues:Array = strValues.split(strVariableSeparator);
				//
				var strOutput:String = "Parse Result";
				//
				
				for (var v = 0; v < arrValues.length; v++) {
					var arrVariable:Array = arrValues[v].split(strValueSeparator);
					Params.OBJ_VALUE_MAP.saveValue(arrVariable[0],  arrVariable[1]);
					strOutput += ("\n   - " + arrVariable[0] + " = " + arrVariable[1]);
				}
				Logger.status(Params, strOutput);
			} else {
				Logger.warning(Params, "Nothing to parse!");
			}
		}
		public static function save($data:Object):void
		{
			for (var d in $data){
				Params.OBJ_VALUE_MAP.saveValue(d, VariableUtil.sanitize($data[d]));
			}
		}
		public static function getValue($name:String):*
		{
			return Params.OBJ_VALUE_MAP.getValue($name);
		}
		
	}
}