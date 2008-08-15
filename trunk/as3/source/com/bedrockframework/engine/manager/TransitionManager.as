package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.event.ViewEvent;
	import com.bedrockframework.engine.model.Config;
	import com.bedrockframework.engine.model.Queue;
	import com.bedrockframework.engine.model.State;
	import com.bedrockframework.engine.view.IView;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.VisualLoader;
	
	import flash.utils.*;

	public class TransitionManager extends StaticWidget
	{
		private static var __objSiteLoader:VisualLoader;
		private static var __objSiteView:IView;
		
		private static var __objSectionLoader:VisualLoader;
		private static var __objSectionView:IView;
		

		Logger.log(TransitionManager, LogLevel.CONSTRUCTOR, "Constructed");
		
		public static function reset():void
		{
			TransitionManager.__objSectionLoader=null;
			TransitionManager.__objSectionView=null;
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
		
		private static function addSectionListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,TransitionManager.onSectionInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,TransitionManager.onSectionIntroComplete);
			$target.addEventListener(ViewEvent.OUTRO_COMPLETE,TransitionManager.onSectionOutroComplete);
		}
		private static function removeSectionListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,TransitionManager.onSectionInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,TransitionManager.onSectionIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,TransitionManager.onSectionOutroComplete);
		}
		/*
		Create a detail object to be sent out with events
	 	*/
	 	private static function getDetailObject():Object
		{
			var objDetail:Object = new Object();
			try {
				objDetail.section = Queue.current;
			} catch ($e:Error) {
			}
			objDetail.view = TransitionManager.sectionView;
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
				TransitionManager.sectionView.initialize();
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
				TransitionManager.sectionView.initialize();
			}
		}
		/*
		Individual Section View Handlers
		*/
		private static function onSectionInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, TransitionManager.sectionView, TransitionManager.getDetailObject()));
			TransitionManager.sectionView.intro();
		}
		private static function onSectionIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INTRO_COMPLETE, TransitionManager.sectionView, TransitionManager.getDetailObject()));
		}
		private static function onSectionOutroComplete($event:ViewEvent):void
		{
			TransitionManager.removeSectionListeners(TransitionManager.sectionView);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.OUTRO_COMPLETE, TransitionManager.sectionView, TransitionManager.getDetailObject()));			
			TransitionManager.sectionView.clear();
			TransitionManager.sectionLoader.unload();
			TransitionManager.reset();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,TransitionManager.sectionLoader));
		}
		/*
		Load Handlers
		*/
		private static function onSiteLoadComplete($event:LoaderEvent):void
		{
			TransitionManager.__objSiteView = TransitionManager.__objSiteLoader.content  as IView;
			TransitionManager.addSiteListeners(TransitionManager.__objSiteView);
		}
		private static function onSectionLoadComplete($event:LoaderEvent):void
		{
			TransitionManager.__objSectionView = TransitionManager.__objSectionLoader.content as IView;
			TransitionManager.addSectionListeners(TransitionManager.__objSectionView);
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
		public static function set sectionLoader($loader:VisualLoader):void
		{
			TransitionManager.__objSectionLoader=$loader;
			TransitionManager.__objSectionLoader.addEventListener(LoaderEvent.COMPLETE, TransitionManager.onSectionLoadComplete);
		}
		public static function get sectionLoader():VisualLoader
		{
			return TransitionManager.__objSectionLoader;
		}
		
		public static function get siteView():IView
		{
			return TransitionManager.__objSiteView;
		}
		public static function get sectionView():IView
		{
			return TransitionManager.__objSectionView;
		}
	}

}