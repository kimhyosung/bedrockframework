package com.icg.madagascar.manager
{
	import com.icg.events.DelayEvent;
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.madagascar.output.Outputter;
	import com.icg.storage.HashMap;
	import com.icg.timer.Delay;
	import com.icg.tracking.TrackingService;

	public class TrackingManager extends StaticWidget
	{

		/*
		Variable Declarations
		*/
		private static  var OUTPUT:Outputter = new Outputter(TrackingManager);
		private static  var BOL_TRACKING:Boolean = true;
		private static  var OBJ_TRACK_DELAY:Delay;
		private static  var OBJ_SERVICES:HashMap;
		private static  var ARR_QUEUE:Array;
		/*
		Initialize
		*/
		public static function initialize():void
		{
			TrackingManager.OBJ_SERVICES = new HashMap();
			TrackingManager.ARR_QUEUE = new Array();
			TrackingManager.OBJ_TRACK_DELAY = new Delay("Track");
			TrackingManager.OBJ_TRACK_DELAY.addEventListener(DelayEvent.TRIGGER, TrackingManager.onTrack);
			TrackingManager.OBJ_TRACK_DELAY.outputSilenced = true;
		}
		/*
		Run Tracking
		*/
		public static function track($name:String, ...$arguments):void
		{
			if (TrackingManager.enabled) {
				var objService:Object = TrackingManager.getService($name);
				if (objService) {
					TrackingManager.addToQueue($name, $arguments);
				}
				TrackingManager.startDelay();
			}
		}
		private static function execute($name:String, $arguments:Array):void
		{
			var objService:Object = TrackingManager.getService($name);
			if (objService) {
				objService.track.apply(objService, $arguments);
			}
		}
		private static function startDelay():void
		{
			if (TrackingManager.ARR_QUEUE.length > 0) {
				if (!TrackingManager.OBJ_TRACK_DELAY.running) {
					TrackingManager.OBJ_TRACK_DELAY.start(0.5);
				}
			}
		}
		/*
		Add/ Get Services
		*/
		public static function addService($name:String, $service:TrackingService):void
		{
			TrackingManager.OBJ_SERVICES.saveValue($name, $service);
		}
		public static function getService($name:String):Object
		{
			return TrackingManager.OBJ_SERVICES.getValue($name);
		}
		/*
		Queue Functions 
		*/
		private static function addToQueue($name:String, $arguments:Array):void
		{
			TrackingManager.ARR_QUEUE.push({name:$name, arguments:$arguments});
		}
		private static function getNextQueueItem():Object
		{
			return TrackingManager.ARR_QUEUE.shift();
		}
		/*
		Event Handlers
		*/
		private static function onTrack($event:DelayEvent):void
		{
			var objTrack:Object = TrackingManager.getNextQueueItem();
			if (objTrack != null) {
				TrackingManager.execute(objTrack.name, objTrack.arguments);
			}
			TrackingManager.startDelay()
		}
		/*
		Property Definitions
		*/
		public static function set enabled($status:Boolean):void
		{
			OUTPUT.output("Track status set to - " + $status)
			TrackingManager.BOL_TRACKING = $status;
		}
		public static function get enabled():Boolean
		{
			return TrackingManager.BOL_TRACKING;
		}
	}
}