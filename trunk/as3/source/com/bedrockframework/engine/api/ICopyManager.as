package com.bedrockframework.engine.api
{
	public interface ICopyManager
	{
		function initialize($languages:Array, $defaultLanguage:String = null):void;
		function load($language:String = null):void;
		function getCopy($key:String):String;
		function getCopyGroup($key:String):Object;
		function get languages():Array;
		function get currentLanguage():String;
		function get defaultLanguage():String
	}
}