package com.bedrockframework.engine.api
{
	public interface ICopyManager
	{
		function initialize($language:String = null):void;
		function loadXML($language:String = null):void;
		function getCopy($key:String):String;
		function getCopyGroup($key:String):Object;
	}
}