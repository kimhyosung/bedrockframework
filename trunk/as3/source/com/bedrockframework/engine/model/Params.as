package com.bedrockframework.engine.model
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.VariableUtil;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.core.logging.LogLevel;

	public class Params extends StaticWidget
	{
		/*
		* Variable Declarations
		*/
		private static var __objValueMap:HashMap = new HashMap();
		/*
		* Constructor
		*/
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
					Params.__objValueMap.saveValue(arrVariable[0],  arrVariable[1]);
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
				Params.__objValueMap.saveValue(d, VariableUtil.sanitize($data[d]));
			}
		}
		public static function getValue($name:String):*
		{
			return Params.__objValueMap.getValue($name);
		}
		
	}
}