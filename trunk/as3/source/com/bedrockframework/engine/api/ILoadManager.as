package com.bedrockframework.engine.api
{
	public interface ILoadManager
	{
		/*
		ChainLoader wrappers
		*/
		function reset():void;
		function close():void;
		function loadQueue():void;
		
		function getLoader($id:String):*;
		
		function addToQueue($url:String, $loader:*=null, $priority:uint=0, $id:String = null, $completeHandler:Function=null, $errorHandler:Function=null):void;
		/*
		Property Definitions
		*/
		function get running():Boolean
		
	}
}