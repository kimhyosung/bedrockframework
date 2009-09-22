package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	
	public interface ICopyManager
	{
		function load( $path:String ):void;
		function getCopy($key:String, $group:String = null):String;
		function getCopyGroup($group:String, $key:String = null ):*;
		function get loader():BackgroundLoader;
	}
}