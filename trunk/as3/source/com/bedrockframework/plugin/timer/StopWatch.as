package com.bedrockframework.plugin.timer
{
	import com.bedrockframework.core.base.DispatcherWidget;

	import flash.utils.getTimer;
	import com.bedrockframework.plugin.event.StopWatchEvent;
	import com.bedrockframework.plugin.util.TimeUtil;

	public class StopWatch extends DispatcherWidget
	{
		/*
		Variable Declarations
		*/
		private var _numStart:uint;
		private var _numEnd:uint;
		private var _numDifference:uint;
		private var _bolRunning:Boolean;
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
			if (!this._bolRunning){
				this.status("Start");
				this.clear();
				this._bolRunning = true;
				this._numStart = getTimer();
				this.dispatchEvent(new StopWatchEvent(StopWatchEvent.START, this));
			}
		}
		/*
		Stop the timer
		*/
		public function stop():void
		{
			if (this._bolRunning) {
				var objElapsed:Object = this.elapsed;
				this.status("Time Elapsed\n	- Minutes : " + objElapsed.minutes + "\n	- Seconds : " + objElapsed.seconds + "\n	- Milliseconds : " + objElapsed.milliseconds + "\n	- Total : " + objElapsed.total);
				this.dispatchEvent(new StopWatchEvent(StopWatchEvent.STOP, this, objElapsed))
				this._bolRunning = false;
			}		
		}
		/*
		Clear the timer
		*/
		public function clear():void
		{
			this._numStart = 0;
			this._numEnd = 0;
			this._numDifference = 0;
			this._bolRunning = false;
		}
		/*
		Update difference
		*/
		private function update():void
		{
			this._numEnd = getTimer();
			this._numDifference = (this._numEnd - this._numStart);
		}
		/*
		Get elapsed time
		*/
		public function get elapsed():Object
		{
			this.update();
			return TimeUtil.parseMilliseconds(this._numDifference);
		}
		public function get elapsedMilliseconds():uint
		{
			this.update();
			return this._numDifference;
		}
		/*
		Check wether or not the timer is running
		*/
		public function get running():Boolean
		{
			return this._bolRunning;
		}
	}
}