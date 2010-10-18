package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.tracking.ITrackingService;
	
	public interface ITrackingManager
	{
		function initialize($enabled:Boolean = true):void;
		/*
		Run Tracking
		*/
		function track($id:String, $details:Object):void;
		/*
		Add/ Get Services
		*/
		function addService($id:String, $service:ITrackingService):void;
		function getService($id:String):*;
		/*
		Property Definitions
		*/
		function set enabled($status:Boolean):void;
		function get enabled():Boolean;
	}
}