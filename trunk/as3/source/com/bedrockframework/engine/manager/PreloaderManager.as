package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.api.IPreloaderManager;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.view.IPreloader;
	import com.bedrockframework.plugin.event.TriggerEvent;
	import com.bedrockframework.plugin.event.ViewEvent;
	import com.bedrockframework.plugin.timer.IntervalTrigger;
	import com.bedrockframework.plugin.timer.StopWatch;
	import com.bedrockframework.plugin.timer.TimeoutTrigger;
	import com.bedrockframework.plugin.util.MathUtil;
	
	public class PreloaderManager extends StandardWidget implements IPreloaderManager
	{
		/*
		Variable Declarations
		*/
		private var _objPreloader:IPreloader;
		private var _objInterval:IntervalTrigger;
		private var _objTimeout:TimeoutTrigger;
		private var _numPercentage:Number;
		private var _numTime:Number;
		private var _objStopWatch:StopWatch;
		private var _bolUseTimer:Boolean;
		private var _bolTimerDone:Boolean;
		private var _bolLoaderDone:Boolean;
		/*
		Constructor
		*/
		public function PreloaderManager()
		{
			
		}
		public function initialize($preloaderTime:Number = 0):void
		{
			this._numTime = $preloaderTime * 1000;
			this._bolUseTimer = (this._numTime == 0) ? false : true;
			this.createTimers($preloaderTime);
			this.createListeners();
		}
		private function createListeners():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_BEGIN,this.onLoadBegin);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_PROGRESS,this.onLoadProgress);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_COMPLETE,this.onLoadComplete);
		}
		private function createTimers($preloaderTime:Number = 0):void
		{
			this._objInterval = new IntervalTrigger(0.05);
			this._objInterval.addEventListener(TriggerEvent.TRIGGER, this.onInterval);
			this._objInterval.silenceLogging  = true;
			
			this._objTimeout = new TimeoutTrigger($preloaderTime);
			this._objTimeout.addEventListener(TriggerEvent.TRIGGER, this.onTimeout);
			this._objTimeout.silenceLogging  = true;
			
			this._objStopWatch = new StopWatch;
			this._objStopWatch.silenceLogging  = true;
		}
		/*
		Update
		*/
		private function startPreloader():void
		{
			this._numPercentage = 0;
			this._bolLoaderDone = false;
			this._bolTimerDone = false;
			this._objInterval.start();
			this._objTimeout.start();
			this._objStopWatch.start();
			this.updatePreloader(this._numPercentage);
		}
		private function stopPreloader():void
		{
			if (this._bolUseTimer) {
				if (this._bolTimerDone && this._bolLoaderDone) {
					this.killPreloader();
				}				
			} else {
				this.killPreloader();
			}
		}
		private function killPreloader():void
		{
			this._numPercentage = 100;
			this._objInterval.stop();
			this._objTimeout.stop();
			this._objStopWatch.stop();
			this._objStopWatch.clear();
			this.updatePreloader(this._numPercentage);
			this._objPreloader.outro();
		}
		private function updatePreloader($percent:Number):void
		{
			this._objPreloader.displayProgress(this.calculatePercentage($percent));
		}
		private function calculatePercentage($percent:Number):Number
		{
			var numPercentage:Number;
			if (this._bolUseTimer) {
				var numTimerPercentage:Number = MathUtil.calculatePercentage(this._objStopWatch.elapsedMilliseconds, this._numTime);
				numPercentage = (numTimerPercentage < this._numPercentage) ? numTimerPercentage : this._numPercentage;
			} else {
				numPercentage =  this._numPercentage;
			}
			return numPercentage;
		}
		/*
		Manage Event Listening
		*/
		private function addListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,this.onIntroComplete);
			$target.addEventListener(ViewEvent.OUTRO_COMPLETE,this.onOutroComplete);
		}
		private function removeListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,this.onIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,this.onOutroComplete);
		}
		/*
		Framework Event Handlers
		*/
		private function onLoadBegin($event:BedrockEvent):void
		{
			this.startPreloader();
		}
		private function onLoadProgress($event:BedrockEvent):void
		{
			this._numPercentage = $event.details.overallPercent;
			this.updatePreloader($event.details.overallPercent);
		}
		private function onLoadComplete($event:BedrockEvent):void
		{
			this._bolLoaderDone = true;
			this.stopPreloader();
		}
		/*
		Individual Preloader Handlers
		*/
		private function onInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.PRELOADER_INITIALIZE_COMPLETE, this));
			this._objPreloader.intro();
		}
		private function onIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.PRELOADER_INTRO_COMPLETE, this));
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.LOAD_QUEUE, this));
		}
		private function onOutroComplete($event:ViewEvent):void
		{
			this.removeListeners(this._objPreloader);
			this._objPreloader.clear();
			this._objPreloader.remove();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.PRELOADER_OUTRO_COMPLETE, this));
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_INITIALIZE, this));
		}
		/*
		Trigger Handlers
		*/
		private function onInterval($event:TriggerEvent):void
		{
			this.updatePreloader(this._numPercentage);
		}
		private function onTimeout($event:TriggerEvent):void
		{
			this._bolTimerDone = true;
			this.stopPreloader();
		}
		/*
		Set the display for the preloader
	 	*/
	 	public function set scope($preloader:IPreloader):void
		{
			this._objPreloader=$preloader;
			this.addListeners(this._objPreloader);
			this._objPreloader.initialize();
		}
		public function get scope():IPreloader
		{
			return this._objPreloader;
		}
	}

}