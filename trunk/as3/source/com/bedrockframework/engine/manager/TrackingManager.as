﻿package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.api.ITrackingManager;
	import com.bedrockframework.plugin.event.TriggerEvent;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.timer.TimeoutTrigger;
	import com.bedrockframework.plugin.tracking.ITrackingService;

	public class TrackingManager extends BasicWidget implements ITrackingManager
	{
		/*
		Variable Declarations
		*/
		private var _bolTracking:Boolean = true;
		private var _objTrackDelay:TimeoutTrigger;
		private var _objServiceMap:HashMap;
		private var _arrQueue:Array;
		/*
		Constructor
		*/
		public function TrackingManager()
		{

		}
		/*
		Initialize
		*/
		public function initialize($enabled:Boolean = true):void
		{
			this.enabled = $enabled;
			this._objServiceMap = new HashMap();
			this._arrQueue = new Array;
			this._objTrackDelay = new TimeoutTrigger;
			this._objTrackDelay.addEventListener(TriggerEvent.TRIGGER, this.onTrack);
			this._objTrackDelay.silenceLogging = true;
		}
		/*
		Run Tracking
		*/
		public function track($id:String, $details:Object):void
		{
			if (this.enabled) {
				var objService:Object = this.getService($id);
				if (objService) {
					this.addToQueue($id, $details);
				}
				this.startDelay();
			}
		}
		private function execute($id:String, $details:Object):void
		{
			var objService:Object = this.getService($id);
			if (objService) {
				objService.track($details);
			}
		}
		private function startDelay():void
		{
			if (this._arrQueue.length > 0) {
				if (!this._objTrackDelay.running) {
					this._objTrackDelay.start(0.5);
				}
			}
		}
		/*
		Add/ Get Services
		*/
		public function addService($id:String, $service:ITrackingService):void
		{
			this._objServiceMap.saveValue($id, $service);
		}
		public function getService($id:String):*
		{
			return this._objServiceMap.getValue($id);
		}
		/*
		Queue Functions 
		*/
		private function addToQueue($id:String, $details:Object):void
		{
			this._arrQueue.push({id:$id, details:$details});
		}
		private function getNextQueueItem():Object
		{
			return this._arrQueue.shift();
		}
		/*
		Event Handlers
		*/
		private function onTrack($event:TriggerEvent):void
		{
			var objDetails:Object = this.getNextQueueItem();
			if (objDetails != null) {
				this.execute(objDetails.id, objDetails.details);
			}
			this.startDelay()
		}
		/*
		Property Definitions
		*/
		public function set enabled($status:Boolean):void
		{
			this._bolTracking = $status;
			if ( this._bolTracking ) {
				this.status( "Tracking Enabled!" );
			} else {
				this.status( "Tracking Disabled!" );
			}
		}
		public function get enabled():Boolean
		{
			return this._bolTracking;
		}
	}
}