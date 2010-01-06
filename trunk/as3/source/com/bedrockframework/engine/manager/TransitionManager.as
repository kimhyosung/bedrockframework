package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.util.ClassUtil;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.ITransitionManger;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.view.IPreloader;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.event.ViewEvent;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.view.IView;
	
	import flash.utils.*;

	public class TransitionManager extends StandardWidget implements ITransitionManger
	{
		/*
		Variable Declarations
		*/
		private var _objSiteLoader:VisualLoader;
		private var _objSiteView:IView;
		
		private var _objPageLoader:VisualLoader;
		private var _objPageView:IView;
		
		private var _objPreloaderView:IPreloader;
		/*
		Constructor
		*/
		public function TransitionManager()
		{
			this.reset();
		}
		
		public function initialize():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.DO_INITIALIZE,this.onDoInitialize);
		}
		public function reset():void
		{
			this._objPageLoader=null;
			this._objPageView=null;
		}
		/*
		Manager Event Listening
		*/
		private function addSiteListeners($target:*):void
		{
			try {
				$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onSiteInitializeComplete);
				$target.addEventListener(ViewEvent.INTRO_COMPLETE,this.onSiteIntroComplete);
			} catch ($error) {
				this.fatal("Fatal error loading site, check for compile errors!");
			}
			
		}
		private function addPageListeners($target:*):void
		{
			try {
				$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onPageInitializeComplete);
				$target.addEventListener(ViewEvent.INTRO_COMPLETE,this.onPageIntroComplete);
				$target.addEventListener(ViewEvent.OUTRO_COMPLETE,this.onPageOutroComplete);
			} catch ($error) {
				this.fatal("Fatal error loading page, check for compile errors!");
			}
		}
		private function removePageListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onPageInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,this.onPageIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,this.onPageOutroComplete);
		}
		
		private function addPreloaderListeners($target:*):void
		{
			try {
				$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onPreloaderInitializeComplete);
				$target.addEventListener(ViewEvent.INTRO_COMPLETE,this.onPreloaderIntroComplete);
				$target.addEventListener(ViewEvent.OUTRO_COMPLETE,this.onPreloaderOutroComplete);
			} catch ($error) {
				this.fatal("Fatal error loading page, check for compile errors!");
			}
		}
		private function removePreloaderListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onPreloaderInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,this.onPreloaderIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,this.onPreloaderOutroComplete);
		}
		/*
		Create a detail object to be sent out with events
	 	*/
	 	private function getDetailObject():Object
		{
			var objDetail:Object = new Object();
			try {
				objDetail.page = BedrockEngine.bedrock::pageManager.current;
			} catch ($e:Error) {
			}
			objDetail.view = this.pageView;
			return objDetail;
		}
		/*
		Framework Event Handlers
		*/
		private function onDoInitialize($event:BedrockEvent):void
		{
			if (!BedrockEngine.bedrock::state.siteInitialized) {
				if ( this.siteView == null) this.fatal("Fatal error loading site, check for compile errors!");
				this.siteView.initialize();
				BedrockEngine.bedrock::state.siteInitialized = true;
			} else {
				if ( this.pageView == null) this.fatal("Fatal error loading page, check for compile errors!");
				//"Fatal error loading page! \n - Check for compile errors.\n - Check your preloader, is outroComplete called imediatly in the outro function?"
				this.pageView.initialize();
			}
		}
		/*
		Individual Site View Handlers
		*/
		private function onSiteInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, this.siteView));
			this.siteView.intro();
		}
		private function onSiteIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INTRO_COMPLETE, this.siteView));
			if (BedrockEngine.config.getSettingValue(BedrockData.AUTO_DEFAULT_ENABLED)) {
				if ( this.pageView == null) this.fatal("Fatal error referencing page, check for compile errors!");
				this.pageView.initialize();
			}
		}
		/*
		Individual Page View Handlers
		*/
		private function onPageInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, this.pageView, this.getDetailObject()));
			if ( this.pageView == null) this.fatal("Fatal error referencing page, check for compile errors!");
			this.pageView.intro();
		}
		private function onPageIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INTRO_COMPLETE, this.pageView, this.getDetailObject()));
		}
		private function onPageOutroComplete($event:ViewEvent):void
		{
			this.removePageListeners(this.pageView);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.OUTRO_COMPLETE, this.pageView, this.getDetailObject()));			
			this.pageView.clear();
			this.pageLoader.unload();
			BedrockEngine.containerManager.pageContainer.release();
			ClassUtil.forceGarbageCollection();
			this.reset();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER, this));
		}
		/*
		Preloader View Handlers
		*/
		private function onPreloaderInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.PRELOADER_INITIALIZE_COMPLETE, this));
			this._objPreloaderView.intro();
		}
		private function onPreloaderIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.PRELOADER_INTRO_COMPLETE, this));
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.LOAD_QUEUE, this));
		}
		private function onPreloaderOutroComplete($event:ViewEvent):void
		{
			this.removePreloaderListeners(this._objPreloaderView);
			this._objPreloaderView.clear();
			BedrockEngine.containerManager.preloaderContainer.release();
			this._objPreloaderView = null;
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.PRELOADER_OUTRO_COMPLETE, this));
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_INITIALIZE, this));
		}
		/*
		Load Handlers
		*/
		private function onSiteLoadComplete($event:LoaderEvent):void
		{
			this._objSiteView = this._objSiteLoader.content as IView;
			this.addSiteListeners(this._objSiteView);
		}
		private function onPageLoadComplete($event:LoaderEvent):void
		{
			this._objPageView = this._objPageLoader.content as IView;
			this.addPageListeners(this._objPageView);
			BedrockEngine.history.current.loaded = true;
		}
		/*
		Set the current container to load content into
	 	*/
	 	public function set siteLoader($loader:VisualLoader):void
		{
			this._objSiteLoader=$loader;
			this._objSiteLoader.addEventListener(LoaderEvent.COMPLETE, this.onSiteLoadComplete);
		}
		public function get siteLoader():VisualLoader
		{
			return this._objSiteLoader;
		}
		
		public function set pageLoader($loader:VisualLoader):void
		{
			this._objPageLoader=$loader;
			this._objPageLoader.addEventListener(LoaderEvent.COMPLETE, this.onPageLoadComplete);
		}
		public function get pageLoader():VisualLoader
		{
			return this._objPageLoader;
		}
	
		public function get siteView():IView
		{
			return this._objSiteView;
		}
		public function get pageView():IView
		{
			return this._objPageView;
		}
		
		public function set preloaderView($preloader):void
		{
			this._objPreloaderView = $preloader;
			this.addPreloaderListeners(this._objPreloaderView);
			this._objPreloaderView.initialize();
		}
		
		public function get preloaderView():IPreloader
		{
			return this._objPreloaderView;
		}
	}

}