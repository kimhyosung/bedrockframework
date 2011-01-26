package com.bedrock.framework.engine.api
{
	import com.bedrock.framework.plugin.tracking.ITrackingService;
	
	public interface ITrackingManager
	{
		function initialize($enabled:Boolean = true):void;
		function track($id:String, $details:Object):void;
		function addService($id:String, $service:ITrackingService):void;
		function getService($id:String):*;
		function hasService( $id:String ):Boolean;
		function get enabled():Boolean;
	}
}