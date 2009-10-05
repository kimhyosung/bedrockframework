package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	
	public interface IResourceManager
	{
		function load( $path:String ):void;
		function getResource($key:String, $group:String = null):String;
		function getResourceGroup($group:String, $key:String = null ):*;
		function get loader():BackgroundLoader;
	}
}