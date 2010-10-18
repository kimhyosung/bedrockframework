package com.bedrockframework.engine.api
{
	import flash.display.DisplayObjectContainer;
	
	public interface IConfig
	{
		function initialize($data:String, $url:String ):void;
		
		/*
		Save the page information for later use.
		*/
		
		
		function getSettingValue($key:String):*;
		function getPathValue($key:String):*;
		function getVariableValue($key:String):*;
		
		function saveSettingValue( $key:String, $value:*, $autoAdd:Boolean = true ):void;

		function parseParamObject( $data:Object ):void;
		function parseParamString( $values:String, $variableSeparator:String ="&", $valueSeparator:String =  "=" ):void;
		
		function get containers():XML;
		function get locales():XML;
		function get pages():XML;
	}
}