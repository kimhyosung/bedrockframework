package com.bedrock.framework.engine.api
{
	public interface ILocaleManager
	{
		function initialize( $data:XML, $defaultLocale:String, $currentLocale:String ):void
		function load($locale:String = null ):void;
		function getLocale($locale:String):Object;
		function hasLocale($locale:String):Boolean;
		
		function get data():Array;
		function get currentLocale():String;
		function get defaultLocale():String;
	}
}