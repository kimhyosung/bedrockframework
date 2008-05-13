package com.icg.madagascar.manager
{
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.storage.HashMap;
	import com.icg.remoting.Service;
	import com.icg.madagascar.output.Outputter;

	public class ServiceManager extends StaticWidget
	{
		/*
		Variable Declarations
		*/
		private static var OUTPUT:Outputter = new Outputter(ServiceManager);
		private static  var OBJ_SERVICES:HashMap = new HashMap();
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
				ServiceManager.OUTPUT.output("Missing Parameters!", "error");
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