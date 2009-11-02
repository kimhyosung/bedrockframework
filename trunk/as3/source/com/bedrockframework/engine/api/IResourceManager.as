package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	
	public interface IResourceManager
	{
		function load( $path:String ):void;
		function getResource($key:String, $group:String = null):String;
		function getResourceGroup($group:String, $key:String = null ):*;
		function getResourceArray( $key:String, $startIndex:uint = 1 ):Array;
		function get loader():BackgroundLoader;
		function get delegate():Class;
		function set delegate( $class:Class ):void;
	}
}