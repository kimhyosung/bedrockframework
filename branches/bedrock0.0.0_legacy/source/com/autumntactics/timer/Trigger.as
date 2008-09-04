package com.autumntactics.timer
{
	/*
	imports
	*/
	import flash.display.Sprite;
	import com.autumntactics.bedrock.base.DispatcherWidget;
	import com.autumntactics.events.TriggerEvent;
	import flash.utils.*;
	/*
	class
	*/
	public class Trigger extends DispatcherWidget
	{
		/*
		Variables
		*/
		private static  var NUM_TOTAL:Number = 0;
		private var numMilliseconds:Number;
		private var numSeconds:Number;
		private var numID:uint;
		private var strName:String;
		private var bolRunning:Boolean;
		private var numLoops:int;
		private var numIndex:Number;
		/*
		Constructor
		*/
		public function Trigger($name:String = null):void
		{
			Trigger.NUM_TOTAL +=1;
			this.numID = NUM_TOTAL;
			this.strName = $name;
			this.bolRunning = false;
			this.numLoops = -1;
		}
		/*
		public functions
		*/
		public function start($delay:Number ,$loops:int = -1):void
		{
			if (!this.bolRunning) {
				this.status("Start");
				this.numSeconds = $delay;
				this.numMilliseconds = $delay * 1000;
				this.numID = setInterval(this.trigger, this.numMilliseconds);
				this.numLoops = $loops;
				this.numIndex = 0;
				this.bolRunning = true;
				this.dispatchEvent(new TriggerEvent(TriggerEvent.START, this, {id:this.numID, seconds:this.numSeconds, milliseconds:this.numMilliseconds, loops:this.numLoops}));
			}
		}
		public function stop():void
		{
			if (this.bolRunning) {
				this.status("Stop");
				this.numIndex = 0;
				this.bolRunning = false;
				clearInterval(this.numID);
				this.dispatchEvent(new TriggerEvent(TriggerEvent.STOP, this,{id:this.numID, seconds:this.numSeconds, milliseconds:this.numMilliseconds, loops:this.numLoops}));
			}			
		}
		public function trigger():void
		{
			this.dispatchEvent(new TriggerEvent(TriggerEvent.TRIGGER, this,{id:this.numID, index:this.numIndex, loops:this.numLoops}));
			this.numIndex++;
			if (this.numLoops > 0) {
				if (this.numIndex >= this.numLoops) {
					this.stop();
				}
			}
		}
		/*
		Property Definitions
		*/
		public function get id():Number
		{
			return this.numID;
		}
		public function get delay():Number
		{
			return this.seconds;
		}
		public function get seconds():Number
		{
			return (this.numMilliseconds / 1000);
		}
		public function get milliseconds():Number
		{
			return this.numMilliseconds / 1000;
		}
		public function get loops():Number
		{
			return this.numLoops;
		}
		public function get totalTimers():Number
		{
			return NUM_TOTAL;
		}
		public function get running():Boolean
		{
			return this.bolRunning;
		}
		public function get elapsed():Number
		{
			return this.numIndex * this.numMilliseconds / 1000;
		}
	}
}