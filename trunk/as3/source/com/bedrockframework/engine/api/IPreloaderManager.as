package com.bedrockframework.engine.api
{
	import com.bedrockframework.engine.view.IPreloader;
	
	public interface IPreloaderManager
	{
		function initialize($preloaderTime:Number = 0):void;
	}
}