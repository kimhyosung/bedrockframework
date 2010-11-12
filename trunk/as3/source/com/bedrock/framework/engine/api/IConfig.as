package com.bedrock.framework.engine.api
{
	import flash.display.DisplayObjectContainer;
	
	public interface IConfig
	{
		function initialize($data:String, $url:String ):void;
		
		/*
		Save the page information for later use.
		*/
		
		
		function getSettingValue($id:String):*;
		function getPathValue($id:String):*;
		function getVariableValue($id:String):*;
		
		function saveSettingValue( $id:String, $value:*, $autoAdd:Boolean = true ):void;

		function parseParams( $data:* ):void;
		
		function get containers():XML;
		function get locales():XML;
		function get contents():XML;
	}
}