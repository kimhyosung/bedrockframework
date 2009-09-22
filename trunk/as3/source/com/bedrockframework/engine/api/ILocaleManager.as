package com.bedrockframework.engine.api
{
	public interface ILocaleManager
	{
		function initialize($locales:Array, $defaultLocale:String = null):void;
		function load($locale:String = null, $useLoadManager:Boolean = false):void;
		function isLocaleAvailable($locale:String):Boolean;
		function get locales():Array;
		function get currentLocale():String;
		function get defaultLocale():String;
	}
}