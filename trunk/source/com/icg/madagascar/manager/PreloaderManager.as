package com.icg.madagascar.manager
{
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.events.ViewEvent;
	import com.icg.madagascar.output.Outputter;
	import com.icg.madagascar.view.IPreloader;
	public class PreloaderManager extends StaticWidget
	{
		private static  var OUTPUT:Outputter = new Outputter(PreloaderManager);
		private static  var OBJ_PRELOADER:IPreloader;

		
		public static function initialize():void
		{
			MadagascarDispatcher.addEventListener(MadagascarEvent.LOAD_BEGIN,PreloaderManager.onLoadBegin);
			MadagascarDispatcher.addEventListener(MadagascarEvent.LOAD_PROGRESS,PreloaderManager.onLoadProgress);
			MadagascarDispatcher.addEventListener(MadagascarEvent.LOAD_COMPLETE,PreloaderManager.onLoadComplete);
		}
		public static function set($preloader:IPreloader):void
		{
			PreloaderManager.OBJ_PRELOADER=$preloader;
			PreloaderManager.addListeners(PreloaderManager.OBJ_PRELOADER);
			PreloaderManager.OBJ_PRELOADER.initialize();
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
		private static function onLoadBegin($event:MadagascarEvent):void
		{
			PreloaderManager.OBJ_PRELOADER.displayProgress(0);
		}
		private static function onLoadProgress($event:MadagascarEvent):void
		{
			PreloaderManager.OBJ_PRELOADER.displayProgress($event.details.overallPercent);
		}
		private static function onLoadComplete($event:MadagascarEvent):void
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
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.LOAD_QUEUE, PreloaderManager));
		}
		private static function onOutroComplete($event:ViewEvent):void
		{
			PreloaderManager.removeListeners(PreloaderManager.OBJ_PRELOADER);
			PreloaderManager.OBJ_PRELOADER.remove();
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.DO_INITIALIZE, PreloaderManager));
		}
	}

}