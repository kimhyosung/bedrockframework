package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.ViewEvent;
	import com.bedrockframework.engine.model.Config;
	import com.bedrockframework.engine.model.Queue;
	import com.bedrockframework.engine.model.State;
	import com.bedrockframework.plugin.view.IView;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.VisualLoader;
	
	import flash.utils.*;

	public class TransitionManager extends StaticWidget
	{
		private static var __objSiteLoader:VisualLoader;
		private static var __objSiteView:IView;
		
		private static var __objPageLoader:VisualLoader;
		private static var __objPageView:IView;
		

		Logger.log(TransitionManager, LogLevel.CONSTRUCTOR, "Constructed");
		
		public static function reset():void
		{
			TransitionManager.__objPageLoader=null;
			TransitionManager.__objPageView=null;
		}
		public static function initialize():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.DO_INITIALIZE,TransitionManager.onDoInitialize);
		}
		/*
		Manager Event Listening
		*/
		private static function addSiteListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,TransitionManager.onSiteInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,TransitionManager.onSiteIntroComplete);
		}
		
		private static function addPageListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,TransitionManager.onPageInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,TransitionManager.onPageIntroComplete);
			$target.addEventListener(ViewEvent.OUTRO_COMPLETE,TransitionManager.onPageOutroComplete);
		}
		private static function removePageListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,TransitionManager.onPageInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,TransitionManager.onPageIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,TransitionManager.onPageOutroComplete);
		}
		/*
		Create a detail object to be sent out with events
	 	*/
	 	private static function getDetailObject():Object
		{
			var objDetail:Object = new Object();
			try {
				objDetail.page = Queue.current;
			} catch ($e:Error) {
			}
			objDetail.view = TransitionManager.pageView;
			return objDetail;
		}
		/*
		Framework Event Handlers
		*/
		private static function onDoInitialize($event:BedrockEvent):void
		{
			if (!State.siteInitialized) {
				TransitionManager.siteView.initialize();
				State.siteInitialized = true;
			} else {
				TransitionManager.pageView.initialize();
			}			
		}
		/*
		Individual Site View Handlers
		*/
		private static function onSiteInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, TransitionManager.siteView));
			TransitionManager.siteView.intro();
		}
		private static function onSiteIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INTRO_COMPLETE, TransitionManager.siteView));
			if (Config.getSetting(BedrockData.AUTO_DEFAULT_ENABLED)) {
				TransitionManager.pageView.initialize();
			}
		}
		/*
		Individual Page View Handlers
		*/
		private static function onPageInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, TransitionManager.pageView, TransitionManager.getDetailObject()));
			TransitionManager.pageView.intro();
		}
		private static function onPageIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INTRO_COMPLETE, TransitionManager.pageView, TransitionManager.getDetailObject()));
		}
		private static function onPageOutroComplete($event:ViewEvent):void
		{
			TransitionManager.removePageListeners(TransitionManager.pageView);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.OUTRO_COMPLETE, TransitionManager.pageView, TransitionManager.getDetailObject()));			
			TransitionManager.pageView.clear();
			TransitionManager.pageLoader.unload();
			TransitionManager.reset();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,TransitionManager.pageLoader));
		}
		/*
		Load Handlers
		*/
		private static function onSiteLoadComplete($event:LoaderEvent):void
		{
			TransitionManager.__objSiteView = TransitionManager.__objSiteLoader.content  as IView;
			TransitionManager.addSiteListeners(TransitionManager.__objSiteView);
		}
		private static function onPageLoadComplete($event:LoaderEvent):void
		{
			TransitionManager.__objPageView = TransitionManager.__objPageLoader.content as IView;
			TransitionManager.addPageListeners(TransitionManager.__objPageView);
		}
		/*
		Set the current container to load content into
	 	*/
	 	public static function set siteLoader($loader:VisualLoader):void
		{
			TransitionManager.__objSiteLoader=$loader;
			TransitionManager.__objSiteLoader.addEventListener(LoaderEvent.COMPLETE, TransitionManager.onSiteLoadComplete);
		}
		public static function get siteLoader():VisualLoader
		{
			return TransitionManager.__objSiteLoader;
		}
		public static function set pageLoader($loader:VisualLoader):void
		{
			TransitionManager.__objPageLoader=$loader;
			TransitionManager.__objPageLoader.addEventListener(LoaderEvent.COMPLETE, TransitionManager.onPageLoadComplete);
		}
		public static function get pageLoader():VisualLoader
		{
			return TransitionManager.__objPageLoader;
		}
		
		public static function get siteView():IView
		{
			return TransitionManager.__objSiteView;
		}
		public static function get pageView():IView
		{
			return TransitionManager.__objPageView;
		}
	}

}