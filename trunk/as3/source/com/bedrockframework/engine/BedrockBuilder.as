/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@builtonbedrock.com
 * website: http://www.builtonbedrock.com/
 * blog: http://blog.builtonbedrock.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.engine
{
	
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.core.controller.FrontController;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.command.*;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.*;
	import com.bedrockframework.engine.view.*;
	import com.bedrockframework.plugin.display.Blocker;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.gadget.*;
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.storage.ArrayBrowser;
	import com.bedrockframework.plugin.tracking.ITrackingService;
	
	import com.bedrockframework.engine.bedrock;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class BedrockBuilder extends MovieClipWidget
	{
		/*
		Variable Declarations
		*/
		public var configURL:String;
		public var params:String
		
		private const _arrLoadSequence:Array=new Array("loadParams","loadConfig","loadDeepLinking","loadCacheSettings", "loadLogging","loadServices","loadEngineClasses","loadEngineCommands","loadEngineContainers","loadCSS", "loadCopy", "loadDefaultPage", "buildDefaultPanel","loadModels","loadCommands","loadViews","loadTracking","loadCustomization","loadComplete");
		private var _numLoadIndex:Number;		
		private var _objConfigLoader:URLLoader;
		
		private var _objBedrockEngine:BedrockEngine;
		/*
		Constructor
		*/
		public function BedrockBuilder()
		{
			this.configURL = "../../" + BedrockData.CONFIG_FILENAME + ".xml";
			this._objBedrockEngine = BedrockEngine.getInstance();

			this._numLoadIndex=0;
			this.createEngineClasses();
			this.loaderInfo.addEventListener(Event.COMPLETE,this.onBootUp);
		}
		/**
		 * The initialize function is automatically called once the shell.swf has finished loading itself.
		 */
		final private function initialize():void
		{
			this.next();
		}
		
		final private function createEngineClasses():void
		{
			//use namespace engine;
			
			this._objBedrockEngine.bedrock::controller = new FrontController;
			
			this._objBedrockEngine.assetManager = new AssetManager;
			this._objBedrockEngine.containerManager = new ContainerManager;
			this._objBedrockEngine.copyManager = new CopyManager;
			this._objBedrockEngine.deeplinkManager = new DeepLinkManager;
			this._objBedrockEngine.loadManager = new LoadManager;
			this._objBedrockEngine.bedrock::pageManager = new PageManager;
			this._objBedrockEngine.bedrock::preloaderManager = new PreloaderManager;
			this._objBedrockEngine.serviceManager = new ServiceManager;			
			this._objBedrockEngine.styleManager = new StyleManager;
			this._objBedrockEngine.trackingManager = new TrackingManager;
			this._objBedrockEngine.bedrock::transitionManager = new TransitionManager;
			
			this._objBedrockEngine.config = new Config;
			this._objBedrockEngine.bedrock::state = new State;
		}
		
		final protected function next():void
		{
			var strFunction:String=this._arrLoadSequence[this._numLoadIndex];
			this._numLoadIndex+= 1;

			var objDetails:Object = this.getProgressObject();

			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.BEDROCK_PROGRESS,this,objDetails));

			this[strFunction]();
		}
		/*
		Calculate Percentage
		*/
		private function getProgressObject():Object
		{
			var numPercent:int=Math.round(this._numLoadIndex / this._arrLoadSequence.length * 100);
			var objDetails:Object=new Object  ;
			objDetails.index=this._numLoadIndex;
			objDetails.percent=numPercent;
			return objDetails;
		}
		
		/*
		Sequential Functions
		*/

		final private function loadParams():void
		{			
			this._objBedrockEngine.config.parseParamString(this.params);
			this._objBedrockEngine.config.saveParams(this.loaderInfo.parameters);
			this.next();
		}
		
		final private function loadConfig():void
		{
			var strConfigURL:String;
			this.loadConfigXML(this._objBedrockEngine.config.getParam(BedrockData.CONFIG_URL) ||this.configURL);
			this.status(this.loaderInfo.url);
		}
		final private function loadDeepLinking():void
		{
			if (this._objBedrockEngine.config.getSetting(BedrockData.DEEP_LINKING_ENABLED)) {
				this._objBedrockEngine.deeplinkManager.initialize();
				BedrockDispatcher.addEventListener(BedrockEvent.DEEP_LINK_INITIALIZE, this.onDeepLinkInitialized);
			} else {
				this.next();
			}	
		}
		final private function loadCacheSettings():void
		{
			if (this._objBedrockEngine.config.getSetting(BedrockData.CACHE_PREVENTION_ENABLED) && this._objBedrockEngine.config.getSetting(BedrockData.ENVIRONMENT) != BedrockData.LOCAL) {
				BackgroundLoader.cachePrevention = true;
				VisualLoader.cachePrevention = true;
				BackgroundLoader.cacheKey = this._objBedrockEngine.config.getValue(BedrockData.CACHE_KEY);
				VisualLoader.cacheKey = this._objBedrockEngine.config.getValue(BedrockData.CACHE_KEY);
			}
			this.next();
		}
		final private function loadLogging():void
		{
			Logger.localLevel = LogLevel[this._objBedrockEngine.config.getParam(BedrockData.LOCAL_LOG_LEVEL)  || this._objBedrockEngine.config.getValue(BedrockData.LOCAL_LOG_LEVEL)];
			Logger.eventLevel = LogLevel[this._objBedrockEngine.config.getParam(BedrockData.EVENT_LOG_LEVEL)  || this._objBedrockEngine.config.getValue(BedrockData.EVENT_LOG_LEVEL)];
			Logger.remoteLevel = LogLevel[this._objBedrockEngine.config.getParam(BedrockData.REMOTE_LOG_LEVEL)  || this._objBedrockEngine.config.getValue(BedrockData.REMOTE_LOG_LEVEL)];
			Logger.remoteLogURL = this._objBedrockEngine.config.getValue(BedrockData.REMOTE_LOG_URL);
			this.next();
		}
		final private function loadCSS():void
		{
			if (this._objBedrockEngine.config.getSetting(BedrockData.STYLESHEET_ENABLED)) {
				this.addToQueue(this._objBedrockEngine.config.getValue(BedrockData.CSS_PATH) + BedrockData.STYLESHEET_FILENAME + ".css", null, this.onCSSLoaded);
			}
			this.next();
		}
		final private function loadCopy():void
		{
			if (this._objBedrockEngine.config.getSetting(BedrockData.COPY_DECK_ENABLED)) {
				var strPath:String;
				var arrLanguages:Array = this._objBedrockEngine.config.getSetting(BedrockData.LANGUAGES);
				var objBrowser:ArrayBrowser = new ArrayBrowser(arrLanguages);
				if (arrLanguages.length > 0 && this._objBedrockEngine.config.getSetting(BedrockData.DEFAULT_LANGUAGE) != "") {
					if (objBrowser.containsItem(this._objBedrockEngine.config.getSetting(BedrockData.CURRENT_LANGUAGE))) {
						strPath = this._objBedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + "_" + this._objBedrockEngine.config.getSetting(BedrockData.CURRENT_LANGUAGE) + ".xml";
					} else {
						strPath = this._objBedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + "_" + this._objBedrockEngine.config.getSetting(BedrockData.DEFAULT_LANGUAGE) + ".xml";
					}
				} else {
					strPath = this._objBedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + ".xml";
				}
				this._objBedrockEngine.copyManager.initialize(strPath);
			}			
			this.next();
		}
		final private function loadEngineCommands():void
		{			
			this.addCommand(BedrockEvent.SET_QUEUE,SetQueueCommand);
			this.addCommand(BedrockEvent.LOAD_QUEUE,LoadQueueCommand);
			this.addCommand(BedrockEvent.DO_DEFAULT,DoDefaultCommand);
			this.addCommand(BedrockEvent.DO_CHANGE,DoChangeCommand);
			this.addCommand(BedrockEvent.RENDER_PRELOADER,RenderPreloaderCommand);
			
			this.addCommand(BedrockEvent.RENDER_SITE,RenderSiteCommand);
			this.addCommand(BedrockEvent.URL_CHANGE, URLChangeCommand);
			
			this.addCommand(BedrockEvent.SHOW_BLOCKER,ShowBlockerCommand);
			this.addCommand(BedrockEvent.HIDE_BLOCKER,HideBlockerCommand);
			this.addCommand(BedrockEvent.SET_QUEUE,ShowBlockerCommand);
			this.addCommand(BedrockEvent.INTRO_COMPLETE,HideBlockerCommand);
			
			this.addCommand(BedrockEvent.SET_QUEUE, StateChangeCommand);
			this.addCommand(BedrockEvent.INITIALIZE_COMPLETE, StateChangeCommand);
			
			if (this._objBedrockEngine.config.getSetting(BedrockData.AUTO_INTRO_ENABLED)){
				this.addCommand(BedrockEvent.BEDROCK_COMPLETE,RenderSiteCommand);
			}
			if (this._objBedrockEngine.config.getSetting(BedrockData.COPY_DECK_ENABLED)){
				this.addCommand(BedrockEvent.LOAD_COPY, LoadCopyCommand);
			}
			
			this.next();
		}
		final private function loadEngineClasses():void
		{
			this._objBedrockEngine.containerManager.initialize(this);
			this._objBedrockEngine.bedrock::preloaderManager.initialize();
			this._objBedrockEngine.bedrock::transitionManager.initialize();
			
			this._objBedrockEngine.trackingManager.initialize(this._objBedrockEngine.config.getValue(BedrockData.TRACKING_ENABLED));
			
			this.next();			
		}
		final private function loadEngineContainers():void
		{
			this._objBedrockEngine.containerManager.buildLayout(this._objBedrockEngine.config.getSetting(BedrockData.LAYOUT));
			this._objBedrockEngine.bedrock::transitionManager.siteLoader = this._objBedrockEngine.containerManager.getContainer(BedrockData.SITE_CONTAINER) as VisualLoader;
			this._objBedrockEngine.bedrock::transitionManager.pageLoader = this._objBedrockEngine.containerManager.getContainer(BedrockData.PAGE_CONTAINER) as VisualLoader;
			
			this._objBedrockEngine.containerManager.buildContainer(BedrockData.PRELOADER_CONTAINER, new Sprite);
				
			var objBlocker:Blocker=new Blocker(this._objBedrockEngine.config.getParam(BedrockData.BLOCKER_ALPHA));
			this._objBedrockEngine.containerManager.buildContainer(BedrockData.BLOCKER_CONTAINER, objBlocker);
			objBlocker.show();
			
			this.next();
		}
		final private function loadServices():void
		{
			try{
				if (this._objBedrockEngine.config.getSetting(BedrockData.REMOTING_ENABLED)) {
					this._objBedrockEngine.serviceManager.initialize(this._objBedrockEngine.config.getValue(BedrockData.REMOTING))
				}				
			}catch($error:Error){
			}
			this.next();
		}
		final private function buildDefaultPanel():void
		{
			this.next();
		}
		final private function loadDefaultPage():void
		{
			if (this._objBedrockEngine.config.getSetting(BedrockData.AUTO_DEFAULT_ENABLED)) {
				this._objBedrockEngine.bedrock::pageManager.setupPageLoad(this._objBedrockEngine.config.getPage(this._objBedrockEngine.bedrock::pageManager.getDefaultPage()));
			}
			this.next();
		}
		/*
		Site Customization Functions
		*/
		
		/*
		Load Completion Notice
		*/
		final private function loadComplete():void
		{
			this.addToQueue(this._objBedrockEngine.config.getValue(BedrockData.SWF_PATH) + BedrockData.SITE_FILENAME + ".swf", this._objBedrockEngine.containerManager.getContainer(BedrockData.SITE_CONTAINER));
			this.addToQueue(this._objBedrockEngine.config.getValue(BedrockData.SWF_PATH) + BedrockData.SHARED_FILENAME + ".swf", this._objBedrockEngine.containerManager.getContainer(BedrockData.SHARED_CONTAINER));			
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.BEDROCK_COMPLETE,this));
			this.status("Initialization Complete!");
		}
		/*
		Add Command
		*/
		/**
		 * Adds an event/command relationship to the BedrockController.
		 */
		final protected function addCommand($type:String,$command:Class):void
		{
			this._objBedrockEngine.bedrock::controller.addCommand($type,$command);
		}
		/**
		 * Removes an event/command relationship to the BedrockController.
		 */
		final protected function removeCommand($type:String,$command:Class):void
		{
			this._objBedrockEngine.bedrock::controller.removeCommand($type,$command);
		}
		/*
		Add Tracking Service
		*/
		final protected function addTrackingService($name:String, $service:ITrackingService):void
		{
			this._objBedrockEngine.trackingManager.addService($name, $service);
		}
		/*
		Add View Functions
		*/
		final protected function addToQueue($path:String,$loader:*,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			this._objBedrockEngine.loadManager.addToQueue($path, $loader, $completeHandler, $errorHandler);
		}
		/*
		Config Related Stuff
		*/
		final private function loadConfigXML($path:String):void
		{
			this.createLoader();
			this._objConfigLoader.load(new URLRequest($path));
		}
		/*
		Create Loader
	 	*/
	 	final private function createLoader():void
		{
			this._objConfigLoader = new URLLoader();
			this._objConfigLoader.addEventListener(Event.COMPLETE, this.onConfigLoaded,false,0,true);
			this._objConfigLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onConfigError,false,0,true);
			this._objConfigLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConfigError,false,0,true);
		}
	 	/*
		Clear Loader
	 	*/
	 	final private function clearLoader():void
		{			
			this._objConfigLoader.removeEventListener(Event.COMPLETE, this.onConfigLoaded);
			this._objConfigLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onConfigError);
			this._objConfigLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConfigError);
			this._objConfigLoader = null;
		}
		/*
		Event Handlers
		*/
		final private function onBootUp($event:Event):void
		{
			this.initialize();
		}
		final private function onConfigLoaded($event:Event):void
		{
			this._objBedrockEngine.config.initialize(this._objConfigLoader.data, this.loaderInfo.url, this.stage);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.CONFIG_LOADED,this));
			this.next();
		}
		final private function onDeepLinkInitialized($event:BedrockEvent):void
		{
			this._objBedrockEngine.config.parseParamString($event.details.query);
			BedrockDispatcher.removeEventListener(BedrockEvent.DEEP_LINK_INITIALIZE, this.onDeepLinkInitialized);
			this.next();
		}
		
		final private function onConfigError($event:Event):void
		{
			this.fatal("Could not parse config!");
		}
		final private function onCSSLoaded($event:LoaderEvent):void
		{
			this._objBedrockEngine.styleManager.parseCSS($event.details.data);
		}
		/*
		Property Definitions
		*/
		public function get engine():BedrockEngine
		{
			return this._objBedrockEngine;
		}
	}
}