package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.engine.api.IPreloadManager;
	import com.bedrock.framework.engine.view.IPreloader;
	import com.bedrock.framework.plugin.trigger.Trigger;
	import com.bedrock.framework.plugin.trigger.TriggerEvent;
	
	public class PreloadManager extends StandardBase implements IPreloadManager
	{
		/*
		Variable Declarations
		*/
		private var _trigger:Trigger;
		private var _preloader:IPreloader;
		
		private var _percentage:Number;
		private var _timeInSeconds:Number;
		private var _timeInMilliseconds:Number;
		
		private var _useTimer:Boolean;
		private var _timerDone:Boolean;
		private var _loaderDone:Boolean;
		/*
		Constructor
		*/
		public function PreloadManager()
		{
			
		}
		public function initialize( $preloaderTime:Number = 0 ):void
		{
			this.minimumTime = $preloaderTime;
			this._createTrigger();
		}
		/*
		Create
		*/
		private function _createTrigger():void
		{
			this._trigger = new Trigger();
			this._trigger.addEventListener( TriggerEvent.TIMER_TRIGGER, this._onTimerTrigger );
			this._trigger.addEventListener( TriggerEvent.STOPWATCH_TRIGGER, this._onStopwatchTrigger);
			this._trigger.silenceLogging = true;
		}
		/*
		Update
		*/
		public function loadBegin():void
		{
			this._loaderDone = false;
			this._timerDone = false;
			if ( this._useTimer ) {
				this._trigger.clearStopwatch();
				this._trigger.startTimer( this._timeInSeconds );
				this._trigger.startStopwatch( 0.01 );
			}
			this._percentage = 0;
			this._updatePreloader( this._percentage );
		}
		public function loadComplete():void
		{
			this._loaderDone = true;
			this._stopPreloader();
		}
		/*
		Preloader Functions
		*/
		private function _updatePreloader( $progress:Number ):void
		{
			this._percentage = $progress;
			this._preloader.displayProgress( this._calculatePercentage() );
		}
		private function _stopPreloader():void
		{
			if (this._useTimer) {
				if ( this._timerDone && this._loaderDone ) {
					this._killPreloader();
				}				
			} else {
				this._killPreloader();
			}
		}
		private function _killPreloader():void
		{
			if ( this._useTimer ) {
				this._trigger.stopTimer();
				this._trigger.stopStopwatch();
			}
			this._percentage = 100;
			this._updatePreloader( this._percentage );
			this._preloader.outro();
		}
		
		private function _calculatePercentage():Number
		{
			var displayPercentage:uint;
			if ( this._useTimer ) {
				var timerPercentage:uint = Math.round( (this._trigger.elapsedMilliseconds / this._timeInMilliseconds) * 100 );
				displayPercentage = ( timerPercentage < this._percentage) ? timerPercentage : this._percentage;
			} else {
				displayPercentage = this._percentage;
			}
			return displayPercentage;
		}
		/*
		Trigger Handlers
		*/
		private function _onStopwatchTrigger( $event:TriggerEvent ):void
		{
			this._updatePreloader(this._percentage);
		}
		private function _onTimerTrigger($event:TriggerEvent):void
		{
			this._timerDone = true;
			this._stopPreloader();
		}
		/*
		Accessors
		*/
		public function set minimumTime( $seconds:Number ):void
		{
			this._timeInSeconds = $seconds;
			this._timeInMilliseconds = this._timeInSeconds * 1000;
			this._useTimer = ( this._timeInSeconds == 0 ) ? false : true;
		}
		
		public function set progress( $progress:Number ):void
		{
			this._updatePreloader( $progress * 100 );
		}
		
		public function set preloader( $preloader:IPreloader ):void
		{
			this._preloader = $preloader;
			this._updatePreloader( 0 );
		}
	}

}
	
