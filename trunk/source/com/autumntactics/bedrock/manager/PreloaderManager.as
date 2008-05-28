package com.autumntactics.bedrock.manager
{
	import com.autumntactics.bedrock.base.StaticWidget;
	import com.autumntactics.bedrock.dispatcher.BedrockDispatcher;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.events.ViewEvent;
	import com.autumntactics.bedrock.output.Outputter;
	import com.autumntactics.bedrock.view.IPreloader;
	import com.autumntactics.bedrock.logging.Logger;
	import com.autumntactics.bedrock.logging.LogLevel;
	
	public class PreloaderManager extends StaticWidget
	{
		private static  var OBJ_PRELOADER:IPreloader;
		
		Logger.log(PreloaderManager, LogLevel.CONSTRUCTOR, "Constructed");
		
		public static function initialize():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_BEGIN,PreloaderManager.onLoadBegin);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_PROGRESS,PreloaderManager.onLoadProgress);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_COMPLETE,PreloaderManager.onLoadComplete);
		}
		/*
		Manager Event Listening
		*/
		private static function addListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,PreloaderManager.onInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,PreloaderManager.onIntroComplete);
			$target.addEventListener(ViewEvent.OUTRO_COMPLETE,PreloaderManager.onOutroComplete);
		}
		private static function removeListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,PreloaderManager.onInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,PreloaderManager.onIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,PreloaderManager.onOutroComplete);
		}
		/*
		Framework Event Handlers
		*/
		private static function onLoadBegin($event:BedrockEvent):void
		{
			PreloaderManager.OBJ_PRELOADER.displayProgress(0);
		}
		private static function onLoadProgress($event:BedrockEvent):void
		{
			PreloaderManager.OBJ_PRELOADER.displayProgress($event.details.overallPercent);
		}
		private static function onLoadComplete($event:BedrockEvent):void
		{
			PreloaderManager.OBJ_PRELOADER.displayProgress(100);
			PreloaderManager.OBJ_PRELOADER.outro();
		}
		/*
		Individual Preloader Handlers
		*/
		private static function onInitializeComplete($event:ViewEvent):void
		{
			PreloaderManager.OBJ_PRELOADER.intro();
		}
		private static function onIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.LOAD_QUEUE, PreloaderManager));
		}
		private static function onOutroComplete($event:ViewEvent):void
		{
			PreloaderManager.removeListeners(PreloaderManager.OBJ_PRELOADER);
			PreloaderManager.OBJ_PRELOADER.remove();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_INITIALIZE, PreloaderManager));
		}
		/*
		Set the display for the preloader
	 	*/
	 	public static function set container($preloader:IPreloader):void
		{
			PreloaderManager.OBJ_PRELOADER=$preloader;
			PreloaderManager.addListeners(PreloaderManager.OBJ_PRELOADER);
			PreloaderManager.OBJ_PRELOADER.initialize();
		}
		public static function get container():IPreloader
		{
			return PreloaderManager.OBJ_PRELOADER;
		}
	}

}