package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	
	public interface IFontManager
	{
		function load($url:String, $autoRegister:Boolean = true):void;
		function get loader():BackgroundLoader;
	}
}