package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.remoting.Service;
	
	public interface IServiceManager
	{
		function initialize($services:Array):void
		/*
		Create a new remoting service.
		*/
		function addService($alias:String, $service:Service):void
		/*
		Get a new remoting service.
		*/
		function getService($alias:String):Service
	}
}