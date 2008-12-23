package com.bedrockframework.engine.api
{
	import com.bedrockframework.engine.view.IPreloader;
	
	public interface IPreloaderManager
	{
		function initialize($preloaderTime:Number = 0):void
		/*
		Set the display for the preloader
	 	*/
	 	function set scope($preloader:IPreloader):void		
		function get scope():IPreloader		
	}
}