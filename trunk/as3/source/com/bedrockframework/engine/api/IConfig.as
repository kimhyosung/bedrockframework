package com.bedrockframework.engine.api
{
	import flash.display.Stage;
	
	public interface IConfig
	{
		function initialize($data:String, $url:String, $stage:Stage):void;
			/*
		Save the page information for later use.
		*/
		function addPage($alias:String, $data:Object):void;
		/*
		Getters
		*/
		/**
		 * Returns a framework setting independent of environment.
	 	*/
		function getSetting($key:String):*;
		/**
		 * Returns a environment value that will change depending on the current environment.
		 * Environment values are declared in the config xml file.
	 	*/
		function getValue($key:String):*;
		/*
		Pull the information for a specific page.
		*/
		function getPage($alias:String):Object;
		function getPages():Array;
		
		function saveParams($data:Object):void;
		function getParam($key:String):*;
		
		function parseParamString($values:String, $variableSeparator:String ="&", $valueSeparator:String =  "="):void;
		
		function get localePrefix():String;
		function get localeSuffix():String;
	}
}