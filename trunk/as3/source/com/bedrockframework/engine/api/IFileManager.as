package com.bedrockframework.engine.api
{
	public interface IFileManager
	{
		function initialize():void;
		function load( $locale:String = null, $useLoadManager:Boolean = false):void;
		/*
		Property Definitions
		*/
		function get delegate():Class;
		function set delegate( $class:Class ):void;
	}
}