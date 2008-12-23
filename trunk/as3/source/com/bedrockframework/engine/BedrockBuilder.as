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
		
		private const _arrLoadSequence:Array=new Array("loadParams","loadConfig","loadContainer","loadDeepLinking","loadCacheSettings", "loadLogging","loadServices","loadEngineClasses","loadEngineCommands","loadEngineContainers","loadCSS", "loadCopy", "loadDefaultPage", "buildDefaultPanel","loadModels","loadCommands","loadViews","loadTracking","loadCustomization","loadComplete");
		private var _numLoadIndex:Number;		
		private var _objConfigLoader:URLLoader;
		public var environmentURL:String;
		
		private var _sprContainer:Sprite;
		/*
		Constructor
		*/
		public function BedrockBuilder()
		{
			this.configURL = "../../" + BedrockData.CONFIG_FILENAME + ".xml";

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
			BedrockEngine.bedrock::controller = new FrontController;
			
			BedrockEngine.assetManager = new AssetManager;
			BedrockEngine.containerManager = new ContainerManager;
			BedrockEngine.copyManager = new CopyManager;
			BedrockEngine.deeplinkManager = new DeepLinkManager;
			BedrockEngine.loadManager = new LoadManager;
			BedrockEngine.bedrock::pageManager = new PageManager;
			BedrockEngine.bedrock::preloaderManager = new PreloaderManager;
			BedrockEngine.serviceManager = new ServiceManager;	
			BedrockEngine.soundManager = new SoundManager;	
			BedrockEngine.styleManager = new StyleManager;
			BedrockEngine.trackingManager = new TrackingManager;
			BedrockEngine.bedrock::transitionManager = new TransitionManager;
			
			BedrockEngine.config = new Config;
			BedrockEngine.history = new History;
			BedrockEngine.bedrock::state = new State;
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
			var objDetails:Object=new Object;
			objDetails.index=this._numLoadIndex;
			objDetails.percent=numPercent;
			return objDetails;
		}
		
		/*
		Sequential Functions
		*/

		final private function loadParams():void
		{			
			BedrockEngine.config.parseParamString(this.params);
			BedrockEngine.config.saveParams(this.loaderInfo.parameters);
			this.next();
		}
		
		final private function loadConfig():void
		{
			var strConfigURL:String;
			this.loadConfigXML(BedrockEngine.config.getParam(BedrockData.CONFIG_URL) ||this.configURL);
			this.status(this.loaderInfo.url);
			this.next();
		}
		final private function loadDeepLinking():void
		{
			if (BedrockEngine.config.getSetting(BedrockData.DEEP_LINKING_ENABLED)) {
				BedrockEngine.deeplinkManager.initialize();
				BedrockDispatcher.addEventListener(BedrockEvent.DEEP_LINK_INITIALIZE, this.onDeepLinkInitialized);
			} else {
				this.next();
			}	
		}
		final private function loadCacheSettings():void
		{
			if (BedrockEngine.config.getSetting(BedrockData.CACHE_PREVENTION_ENABLED) && BedrockEngine.config.getSetting(BedrockData.ENVIRONMENT) != BedrockData.LOCAL) {
				BackgroundLoader.cachePrevention = true;
				VisualLoader.cachePrevention = true;
				BackgroundLoader.cacheKey = BedrockEngine.config.getValue(BedrockData.CACHE_KEY);
				VisualLoader.cacheKey = BedrockEngine.config.getValue(BedrockData.CACHE_KEY);
			}
			this.next();
		}
		final private function loadLogging():void
		{
			Logger.localLevel = LogLevel[BedrockEngine.config.getParam(BedrockData.LOCAL_LOG_LEVEL)  || BedrockEngine.config.getValue(BedrockData.LOCAL_LOG_LEVEL)];
			Logger.eventLevel = LogLevel[BedrockEngine.config.getParam(BedrockData.EVENT_LOG_LEVEL)  || BedrockEngine.config.getValue(BedrockData.EVENT_LOG_LEVEL)];
			Logger.remoteLevel = LogLevel[BedrockEngine.config.getParam(BedrockData.REMOTE_LOG_LEVEL)  || BedrockEngine.config.getValue(BedrockData.REMOTE_LOG_LEVEL)];
			Logger.remoteLogURL = BedrockEngine.config.getValue(BedrockData.REMOTE_LOG_URL);
			this.next();
		}
		final private function loadContainer():void
		{
			this._sprContainer = new Sprite;
			this.addChild(this._sprContainer);
			BedrockEngine.containerManager.initialize(this._sprContainer);
		}
		final private function loadCSS():void
		{
			if (BedrockEngine.config.getSetting(BedrockData.STYLESHEET_ENABLED)) {
				this.addToQueue(BedrockEngine.config.getValue(BedrockData.CSS_PATH) + BedrockData.STYLESHEET_FILENAME + ".css", null, this.onCSSLoaded);
			}
			this.next();
		}
		final private function loadCopy():void
		{
			if (BedrockEngine.config.getSetting(BedrockData.COPY_DECK_ENABLED)) {
				var arrLanguages:Array = BedrockEngine.config.getSetting(BedrockData.LANGUAGES);
				var objBrowser:ArrayBrowser = new ArrayBrowser(arrLanguages);
				var strDefaultLanguage:String = BedrockEngine.config.getParam(BedrockData.DEFAULT_LANGUAGE) || BedrockEngine.config.getSetting(BedrockData.DEFAULT_LANGUAGE) || BedrockEngine.config.getSetting(BedrockData.SYSTEM_LANGUAGE);
				var strSelectedLanguage:String;
				if (arrLanguages.length > 0 && strDefaultLanguage != "") {
					if (objBrowser.containsItem(BedrockEngine.config.getSetting(BedrockData.SYSTEM_LANGUAGE))) {
						//strPath = BedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + "_" +  + ".xml";
						strSelectedLanguage = BedrockEngine.config.getSetting(BedrockData.SYSTEM_LANGUAGE);
					} else {
						//strPath = BedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + "_" + strDefaultLanguage + ".xml";
						strSelectedLanguage = strDefaultLanguage;
					}
				} else {
					//strPath = BedrockEngine.config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + ".xml";
					strSelectedLanguage = null;
				}
				BedrockEngine.copyManager.initialize(strSelectedLanguage);
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
			
			if (BedrockEngine.config.getSetting(BedrockData.AUTO_INTRO_ENABLED)){
				this.addCommand(BedrockEvent.BEDROCK_COMPLETE,RenderSiteCommand);
			}
			if (BedrockEngine.config.getSetting(BedrockData.COPY_DECK_ENABLED)){
				this.addCommand(BedrockEvent.LOAD_COPY, LoadCopyCommand);
			}

			this.addCommand(BedrockEvent.ADD_SOUND, SoundControlCommand);
			this.addCommand(BedrockEvent.PLAY_SOUND, SoundControlCommand);
			this.addCommand(BedrockEvent.STOP_SOUND, SoundControlCommand);
			this.addCommand(BedrockEvent.ADJUST_SOUND_VOLUME, SoundControlCommand);
			this.addCommand(BedrockEvent.ADJUST_SOUND_PAN, SoundControlCommand);
			this.addCommand(BedrockEvent.MUTE, SoundControlCommand);
			this.addCommand(BedrockEvent.UNMUTE, SoundControlCommand);
			this.addCommand(BedrockEvent.ADJUST_GLOBAL_VOLUME, SoundControlCommand);
			this.addCommand(BedrockEvent.ADJUST_GLOBAL_PAN, SoundControlCommand);
		
			this.next();
		}
		final private function loadEngineClasses():void
		{
			BedrockEngine.bedrock::preloaderManager.initialize(BedrockEngine.config.getSetting(BedrockData.PRELOADER_TIME));
			BedrockEngine.bedrock::transitionManager.initialize();
			
			BedrockEngine.trackingManager.initialize(BedrockEngine.config.getValue(BedrockData.TRACKING_ENABLED));
			
			this.next();			
		}
		final private function loadEngineContainers():void
		{			
			BedrockEngine.containerManager.buildLayout(BedrockEngine.config.getSetting(BedrockData.LAYOUT));
			BedrockEngine.bedrock::transitionManager.siteLoader = BedrockEngine.containerManager.getContainer(BedrockData.SITE_CONTAINER) as VisualLoader;
			BedrockEngine.bedrock::transitionManager.pageLoader = BedrockEngine.containerManager.getContainer(BedrockData.PAGE_CONTAINER) as VisualLoader;
			
			BedrockEngine.containerManager.replaceContainer(BedrockData.PRELOADER_CONTAINER, new PreloaderContainer);
				
			var objBlocker:Blocker=new Blocker(BedrockEngine.config.getParam(BedrockData.BLOCKER_ALPHA));
			BedrockEngine.containerManager.replaceContainer(BedrockData.BLOCKER_CONTAINER, objBlocker);
			objBlocker.show();
			
			this.next();
		}
		final private function loadServices():void
		{
			try{
				if (BedrockEngine.config.getSetting(BedrockData.REMOTING_ENABLED)) {
					BedrockEngine.serviceManager.initialize(BedrockEngine.config.getValue(BedrockData.REMOTING))
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
			var bolAutoDefault:Boolean = BedrockEngine.config.getSetting(BedrockData.AUTO_DEFAULT_ENABLED);
			BedrockEngine.bedrock::pageManager.initialize(bolAutoDefault);
			this.next();
		}
		/*
		Load Completion Notice
		*/
		final private function loadComplete():void
		{
			this.addToQueue(BedrockEngine.config.getValue(BedrockData.SWF_PATH) + BedrockData.SITE_FILENAME + ".swf", BedrockEngine.containerManager.getContainer(BedrockData.SITE_CONTAINER));
			this.addToQueue(BedrockEngine.config.getValue(BedrockData.SWF_PATH) + BedrockData.SHARED_FILENAME + ".swf", BedrockEngine.containerManager.getContainer(BedrockData.SHARED_CONTAINER), this.onSharedLoaded);
						
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
			BedrockEngine.bedrock::controller.addCommand($type,$command);
		}
		/**
		 * Removes an event/command relationship to the BedrockController.
		 */
		final protected function removeCommand($type:String,$command:Class):void
		{
			BedrockEngine.bedrock::controller.removeCommand($type,$command);
		}
		/*
		Add Tracking Service
		*/
		final protected function addTrackingService($alias:String, $service:ITrackingService):void
		{
			BedrockEngine.trackingManager.addService($alias, $service);
		}
		/*
		Add View Functions
		*/
		final protected function addToQueue($path:String,$loader:*,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			BedrockEngine.loadManager.addToQueue($path, $loader, $completeHandler, $errorHandler);
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
			BedrockEngine.config.initialize(this._objConfigLoader.data, this.environmentURL || this.loaderInfo.url, this.stage);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.CONFIG_LOADED,this));
			this.next();
		}
		final private function onDeepLinkInitialized($event:BedrockEvent):void
		{
			BedrockEngine.config.parseParamString($event.details.query);
			BedrockDispatcher.removeEventListener(BedrockEvent.DEEP_LINK_INITIALIZE, this.onDeepLinkInitialized);
			this.next();
		}
		
		final private function onConfigError($event:Event):void
		{
			this.fatal("Could not parse config!");
		}
		final private function onCSSLoaded($event:LoaderEvent):void
		{
			BedrockEngine.styleManager.parseCSS($event.details.data);
		}
		final private function onSharedLoaded($event:LoaderEvent):void
		{
			$event.origin.content.initialize();
			if (BedrockEngine.config.getSetting(BedrockData.SHARED_SOUNDS_ENABLED)) {
				BedrockEngine.soundManager.initialize(BedrockEngine.assetManager.getSounds());
			}
		}
	}
}