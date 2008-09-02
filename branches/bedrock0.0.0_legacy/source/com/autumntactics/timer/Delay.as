package com.builtonbedrock.timer
{
	/*
	imports
	*/
	import flash.display.Sprite;
	import com.builtonbedrock.bedrock.base.DispatcherWidget;
	import com.builtonbedrock.events.DelayEvent;
	import flash.utils.*;
	/*
	class
	*/
	public class Delay extends DispatcherWidget
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
		/*
		Constructor
		*/
		public function Delay($name:String = null):void
		{
			Delay.NUM_TOTAL +=1;
			this.numID = NUM_TOTAL;
			this.strName = $name;
			this.bolRunning = false;
		}
		/*
		public functions
		*/
		public function start($delay:Number):void
		{
			if (!this.bolRunning) {
				this.status("Start");
				this.numSeconds = $delay;
				this.numMilliseconds = $delay * 1000;
				this.numID = setTimeout(this.trigger, this.numMilliseconds);
				this.bolRunning = true;
				this.dispatchEvent(new DelayEvent(DelayEvent.START, this, {id:this.numID, seconds:this.numSeconds, milliseconds:this.numMilliseconds}));
			}
		}
		public function stop():void
		{
			if (this.bolRunning) {
				this.status("Stop");
				this.bolRunning = false;
				clearTimeout(this.numID);
				this.dispatchEvent(new DelayEvent(DelayEvent.STOP, this,{id:this.numID, seconds:this.numSeconds, milliseconds:this.numMilliseconds}));
			}
		}
		public function trigger():void
		{
			this.bolRunning = false;
			this.dispatchEvent(new DelayEvent(DelayEvent.TRIGGER, this,{id:this.numID}));
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
		public function get totalTimers():Number
		{
			return NUM_TOTAL;
		}
		public function get running():Boolean
		{
			return this.bolRunning;
		}
	}
}