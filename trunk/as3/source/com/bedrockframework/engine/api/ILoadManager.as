package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.loader.VisualLoader;
	
	public interface ILoadManager
	{
		/*
		ChainLoader wrappers
		*/
		function reset():void		
		function close():void		
		function loadQueue():void		
		function addToQueue($path:String,$loader:VisualLoader=null, $priority:uint=0, $id:String = null, $completeHandler:Function=null, $errorHandler:Function=null):void		
		/*
		Property Definitions
		*/
		function get running():Boolean
		
	}
}