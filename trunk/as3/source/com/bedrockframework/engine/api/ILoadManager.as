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
		
		function addToQueue($url:String, $loader:*=null, $priority:uint=0, $alias:String = null, $completeHandler:Function=null, $errorHandler:Function=null):void;
		/*
		Property Definitions
		*/
		function get running():Boolean
		function set cuncurrentLoads($count:uint):void;
		function get cuncurrentLoads():uint;
	}
}