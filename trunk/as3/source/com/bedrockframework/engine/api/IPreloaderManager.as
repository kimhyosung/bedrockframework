package com.bedrockframework.engine.api
{
	import com.bedrockframework.engine.view.IPreloader;
	
	public interface IPreloaderManager
	{
		function initialize():void
		/*
		Set the display for the preloader
	 	*/
	 	function set container($preloader:IPreloader):void		
		function get container():IPreloader		
	}
}