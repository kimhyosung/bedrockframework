package com.bedrock.framework.engine.api
{
	public interface IConfigModel
	{
		function initialize( $data:String, $url:String ):void;
		function parseParams( $data:* ):void;
		function saveParamValue( $id:String, $value:*):void;
		function saveSettingValue($id:String, $value:*, $overrideOnly:Boolean = false ):void;
		function savePathValue($id:String, $value:*, $overrideOnly:Boolean = false ):void;
		function saveVariableValue($id:String, $value:*, $overrideOnly:Boolean = false ):void;
		function getSettingValue($id:String):*;
		function getPathValue($id:String):*;
		function getVariableValue($id:String):*;
		function hasSettingValue($id:String):Boolean;
		function hasPathValue($id:String):Boolean;
		function hasVariableValue($id:String):Boolean;
		function get containers():XML;
		function get locales():XML;
		function get modules():XML;
		function get assets():XML;
		function get available():Boolean;
	}
}