package com.builtonbedrock.bedrock.manager
{
	import com.builtonbedrock.bedrock.base.StaticWidget;
	import com.builtonbedrock.bedrock.logging.LogLevel;
	import com.builtonbedrock.bedrock.logging.Logger;
	import com.builtonbedrock.remoting.Service;
	import com.builtonbedrock.storage.HashMap;
	
	public class ServiceManager extends StaticWidget
	{
		/*
		Variable Declarations
		*/
		private static  var OBJ_SERVICES:HashMap = new HashMap();
		
		Logger.log(ServiceManager, LogLevel.CONSTRUCTOR, "Constructed");
		/*
		Create a new remoting service.
		*/
		public static function addService($alias:String, $service:Service):void
		{
			ServiceManager.OBJ_SERVICES.saveValue($alias, $service);
		}
		/*
		Create a new remoting service.
		*/
		public static function createService($params:Object):void
		{
			var objParams:Object = $params;
			try {
				var objService:Service = new Service(objParams.gateway, objParams.path);
				ServiceManager.addService(objParams.alias, objService);
			}catch($error:Error){
				Logger.error(ServiceManager, "Missing Parameters!");
			}
			
		}
		/*
		Create a several new remoting services.
		*/
		public static function createServices($services:Array):void
		{
			var arrServices:Array = $services;
			var numLength:Number = arrServices.length;
			for (var i:Number = 0; i < numLength; i++) {
				ServiceManager.createService(arrServices[i]);
			}
		}
		/*
		Get a new remoting service.
		*/
		public static function getService($alias:String):Service
		{			
			return ServiceManager.OBJ_SERVICES.getValue($alias);
		}
	}
}