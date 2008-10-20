package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.api.IPreloaderManager;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.view.IPreloader;
	import com.bedrockframework.plugin.event.ViewEvent;
	
	public class PreloaderManager extends StandardWidget implements IPreloaderManager
	{
		/*
		Variable Declarations
		*/
		private var _objPreloader:IPreloader;
		/*
		Constructor
		*/
		public function PreloaderManager()
		{
			
		}
		public function initialize():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_BEGIN,this.onLoadBegin);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_PROGRESS,this.onLoadProgress);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_COMPLETE,this.onLoadComplete);
		}
		/*
		Manager Event Listening
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
			this._objPreloader.displayProgress(0);
		}
		private function onLoadProgress($event:BedrockEvent):void
		{
			this._objPreloader.displayProgress($event.details.overallPercent);
		}
		private function onLoadComplete($event:BedrockEvent):void
		{
			this._objPreloader.displayProgress(100);
			this._objPreloader.outro();
		}
		/*
		Individual Preloader Handlers
		*/
		private function onInitializeComplete($event:ViewEvent):void
		{
			this._objPreloader.intro();
		}
		private function onIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.LOAD_QUEUE, PreloaderManager));
		}
		private function onOutroComplete($event:ViewEvent):void
		{
			this.removeListeners(this._objPreloader);
			this._objPreloader.clear();
			this._objPreloader.remove();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_INITIALIZE, PreloaderManager));
		}
		/*
		Set the display for the preloader
	 	*/
	 	public function set container($preloader:IPreloader):void
		{
			this._objPreloader=$preloader;
			this.addListeners(this._objPreloader);
			this._objPreloader.initialize();
		}
		public function get container():IPreloader
		{
			return this._objPreloader;
		}
	}

}