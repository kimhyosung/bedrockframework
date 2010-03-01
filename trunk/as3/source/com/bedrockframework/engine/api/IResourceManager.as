package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.loader.DataLoader;
	
	public interface IResourceManager
	{
		function load( $path:String ):void;
		function saveResource($key:String, $data:* ):void;
		function getResource($key:String, $group:String = null):*;
		function getResourceGroup($group:String, $key:String = null ):*;
		function getResourceArray( $prefix:String, $suffix:String = "", $startIndex:int = 1 ):Array;
		function get loader():DataLoader;
		function get delegate():Class;
		function set delegate( $class:Class ):void;
	}
}