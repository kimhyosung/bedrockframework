package com.bedrockframework.engine.api
{
	public interface ICopyManager
	{
		function initialize($path:String):void
		function loadXML($path:String):void
		function getCopy($key:String):String
	}
}