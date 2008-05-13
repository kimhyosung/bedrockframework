package com.icg.madagascar.model
{
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.storage.SimpleMap;

	import com.icg.madagascar.output.Outputter;

	public class Params extends StaticWidget
	{
		/*
		Variable Declarations
		*/
		private static  var OBJ_VALUE_MAP:SimpleMap;
		private static  var OUTPUT:Outputter = new Outputter(Params);
		/*
		Initialize
		*/
		public static function initialize()
		{
			Params.OBJ_VALUE_MAP = new SimpleMap();
		}
		/*
		Parse Values
		*/
		public static function parse($values:String, $variableSeparator:String ="^" , $valueSeparator:String =  "|")
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
					Params.OBJ_VALUE_MAP.set(arrVariable[0],  arrVariable[1]);
					strOutput += ("\n   - " + arrVariable[0] + " = " + arrVariable[1]);
				}
				OUTPUT.output(strOutput);
			} else {
				OUTPUT.output("Nothing to parse!", "warning");
			}
		}
		public static function save($parameter:Object):void
		{
			for (var p in $parameter){
				Params.OBJ_VALUE_MAP.set(p, $parameter[p]);
			}
		}
		public static function getValue($name:String):*
		{
			return Params.OBJ_VALUE_MAP.get($name);
		}
		public static function output():void
		{
			Params.OUTPUT.output(Params.OBJ_VALUE_MAP);
		}
	}
}