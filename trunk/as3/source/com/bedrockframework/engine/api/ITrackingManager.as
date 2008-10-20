package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.tracking.ITrackingService;
	
	public interface ITrackingManager
	{
		function initialize($enabled:Boolean = true):void
		/*
		Run Tracking
		*/
		function track($name:String, $details:Object):void
		/*
		Add/ Get Services
		*/
		function addService($name:String, $service:ITrackingService):void
		function getService($name:String):Object
		/*
		Property Definitions
		*/
		function set enabled($status:Boolean):void
		function get enabled():Boolean
	}
}