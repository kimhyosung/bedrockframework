package com.autumntactics.timer
{
	import com.autumntactics.bedrock.base.DispatcherWidget;

	import flash.utils.getTimer;
	import com.autumntactics.events.StopWatchEvent;
	import com.autumntactics.util.TimeUtil;

	public class StopWatch extends DispatcherWidget
	{
		/*
		Variable Declarations
		*/
		private var numStart:uint;
		private var numEnd:uint;
		private var numDifference:uint;
		private var bolRunning:Boolean;
		/*
		Constructor
		*/
		public function StopWatch()
		{
			this.clear();
		}
		/*
		Start the timer
		*/
		public function start():void
		{
			if (!this.bolRunning){
				this.status("Start");
				this.clear();
				this.bolRunning = true;
				this.numStart = getTimer();
				this.dispatchEvent(new StopWatchEvent(StopWatchEvent.START, this));
			}			
		}
		/*
		Stop the timer
		*/
		public function stop():void
		{
			if (this.bolRunning){
				this.numEnd = getTimer();
				this.numDifference = this.numEnd - this.numStart;
				var objElapsed:Object =this.elapsed
				this.status("Time Elapsed\n	- Minutes : " + objElapsed.minutes + "\n	- Seconds : " + objElapsed.seconds + "\n	- Milliseconds : " + objElapsed.milliseconds + "\n	- Total : " + objElapsed.total);
				this.dispatchEvent(new StopWatchEvent(StopWatchEvent.STOP, this, objElapsed))
				this.bolRunning = false;
			}		
		}
		/*
		Clear the timer
		*/
		public function clear():void
		{
			this.numStart = 0;
			this.numEnd = 0;
			this.numDifference = 0;
			this.bolRunning = false;
		}
		/*
		Get elapsed time
		*/
		public function get elapsed():Object
		{
			return TimeUtil.parseMilliseconds(this.numDifference);
		}
		/*
		Check wether or not the timer is running
		*/
		public function get running():Boolean
		{
			return this.bolRunning;
		}
	}
}