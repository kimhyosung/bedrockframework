package com.bedrock.framework.engine.api
{
	public interface ILocaleManager
	{
		function initialize( $data:XML, $defaultLocale:String, $currentLocale:String ):void;
		function getLocale( $id:String ):Object;
		function hasLocale( $id:String ):Boolean;
		function get currentLocale():String;
		function get defaultLocale():String;
		function get data():Array;
	}
}