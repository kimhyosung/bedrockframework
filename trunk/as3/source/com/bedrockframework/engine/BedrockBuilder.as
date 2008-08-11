/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@autumntactics.com
 * website: http://www.autumntactics.com/
 * blog: http://blog.autumntactics.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.engine
{

	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.command.*;
	import com.bedrockframework.engine.controller.*;
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
		
		private var _numLoadIndex:Number;		
		private var _objConfigLoader:URLLoader;
		private const _arrLoadSequence:Array=new Array("loadDispatcher","loadParams","loadConfig","loadCacheSettings", "loadLogging","loadController","loadServices","loadTracking","loadEngineClasses","loadEngineCommands","loadEngineContainers","loadCSS", "loadCopy", "buildDefaultPanel","loadModels","loadCommands","loadViews","loadTracking","loadCustomization","loadComplete");
		private var _objBedrockController:BedrockController;
		
		/*
		Constructor
		*/
		public function BedrockBuilder()
		{
			this.configURL = "../../bedrock_config.xml";
			this.loaderInfo.addEventListener(Event.COMPLETE,this.onBootUp);
			this._numLoadIndex=0;
		}
		/**
		 * The initialize function is automatically called once the shell.swf has finished loading itself.
		 */
		final protected function initialize():void
		{
			this.next();
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
		Determine General Location
	 	*/
	 	private function determineLocation($url:String):String
		{
			if ($url.indexOf("http") != -1) {
				return "remote";
			} else {
				return "local";
			}
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
		final private function loadDispatcher():void
		{
			this.next();
		}

		final private function loadParams():void
		{
			Params.parse(this.params);
			Params.save(this.loaderInfo.parameters);
			this.next();
		}
		final private function loadConfig():void
		{
			var strConfigURL:String;
			this.loadXML(Params.getValue("configURL") ||this.configURL);
			this.status(this.loaderInfo.url);
		}
		final private function loadCacheSettings():void
		{
			if (Config.getSetting("cache_prevention") && Config.getSetting("environment") != "local") {
				BackgroundLoader.cachePrevention = true;
				VisualLoader.cachePrevention = true;
				BackgroundLoader.cacheKey = Config.getValue("cache_key");
				VisualLoader.cacheKey = Config.getValue("cache_key");
			}
			this.next();
		}
		final private function loadLogging():void
		{
			var strLevel:String = Params.getValue("local_level")  || Config.getValue("local_level");
			Logger.localLevel = LogLevel[strLevel];
			Logger.loggerURL = Config.getValue("logger_url");
			this.next();
		}
		final private function loadCSS():void
		{
			if (Config.getSetting("stylesheet")) {
				this.addToQueue(Config.getValue("css_path") + "bedrock_style.css", null, this.onCSSLoaded);
			}
			this.next();
		}
		final private function loadCopy():void
		{
			if (Config.getSetting("copy_deck")) {
				var strPath:String;
				var arrLanguages:Array = Config.getSetting("languages");
				var objBrowser:ArrayBrowser = new ArrayBrowser(arrLanguages);
				if (arrLanguages.length > 0 && Config.getSetting("default_language") != "") {
					if (objBrowser.containsItem(Config.getSetting("language"))) {
						strPath = Config.getValue("xml_path") + "bedrock_copy_" + Config.getSetting("language") + ".xml";
					} else {
						strPath = Config.getValue("xml_path") + "bedrock_copy_" + Config.getSetting("default_language") + ".xml";
					}
				} else {
					strPath = Config.getValue("xml_path") + "bedrock_copy.xml";
				}
				CopyManager.initialize(strPath);
			}			
			this.next();
		}
		final private function loadController():void
		{			
			this._objBedrockController=new BedrockController();
			this.next();
		}
		final private function loadEngineCommands():void
		{			
			this.addCommand(BedrockEvent.SET_QUEUE,SetQueueCommand);
			this.addCommand(BedrockEvent.LOAD_QUEUE,LoadQueueCommand);
			this.addCommand(BedrockEvent.DO_DEFAULT,DoDefaultCommand);
			this.addCommand(BedrockEvent.DO_CHANGE,DoChangeCommand);
			this.addCommand(BedrockEvent.RENDER_VIEW,RenderViewCommand);
			this.addCommand(BedrockEvent.RENDER_PRELOADER,RenderPreloaderCommand);
			
			this.addCommand(BedrockEvent.RENDER_SITE,RenderSiteCommand);
			this.addCommand(BedrockEvent.URL_CHANGE, URLChangeCommand);
			//
			this.addCommand(BedrockEvent.SHOW_BLOCKER,ShowBlockerCommand);
			this.addCommand(BedrockEvent.HIDE_BLOCKER,HideBlockerCommand);
			this.addCommand(BedrockEvent.SET_QUEUE,ShowBlockerCommand);
			this.addCommand(BedrockEvent.INTRO_COMPLETE,HideBlockerCommand);
			//
			this.addCommand(BedrockEvent.SET_QUEUE, StateChangeCommand);
			this.addCommand(BedrockEvent.INITIALIZE_COMPLETE, StateChangeCommand);
			//
			if (Config.getSetting("auto_intro")){
				this.addCommand(BedrockEvent.BEDROCK_COMPLETE,RenderSiteCommand);
			}
			if (Config.getSetting("copy_deck")){
				this.addCommand(BedrockEvent.LOAD_COPY, LoadCopyCommand);
			}
			//
			this.next();
		}
		final private function loadEngineClasses():void
		{
			State.initialize();

			if (Config.getSetting("deep_linking")) {
				
				DeepLinkManager.initialize();
				
			}
			ContainerManager.initialize(this);
			LayoutManager.initialize();
			LoadManager.initialize();
			PreloaderManager.initialize();
			TransitionManager.initialize();
			
			TrackingManager.initialize(Config.getValue("tracking_enabled"));
			
			this.next();
		}
		final private function loadEngineContainers():void
		{
			LayoutManager.buildLayout(Config.getSetting("layout"));
			TransitionManager.container = ContainerManager.getContainer("site") as VisualLoader;
			ContainerManager.buildContainer("preloader", new Sprite);
				
			var objBlocker:Blocker=new Blocker(Params.getValue("blocker_alpha"));
			ContainerManager.buildContainer("blocker",objBlocker);
			objBlocker.show();
			
			this.next();
		}
		final private function loadServices():void
		{
			try{
				ServiceManager.createServices(Config.getValue("remoting"))
			}catch($error:Error){
			}		
			this.next();
		}
		final private function buildDefaultPanel():void
		{
			this.next();
		}
		/*
		Site Customization Functions
		*/
		/**
		 * Overide this function in the SiteBuilder file specific to your project.
		 * Use this function to load any Models you'll need throughout your project.
		 * Make sure the next ( this.next() ) function is called in the last line of the function otherwise the next function in the sequence will not be called.
		 */
		public function loadModels():void
		{
			this.next();
		}
		/**
		 * Overide this function in the SiteBuilder file specific to your project.
		 * Use this function to add any event command relationships you'll need throughout your project.
		 * Use the addCommand function to add additional commands to the BedrockController. This is the only place you can add commands to the BedrockController throughout the framework.
		 * Optionally you also have the option of creating your own FrontControllers by extending the FrontController located in the core package.
		 * Make sure the <code>next()</code> function is called in the last line of the function otherwise the next function in the sequence will not be called.
		 */
		public function loadCommands():void
		{
			this.next();
		}
		public function loadContainers():void
		{
			this.next();
		}
		public function loadViews():void
		{
			this.next();
		}
		/**
		 * Overide this function in the SiteBuilder file specific to your project.
		 * Use this function to add new services to the TrackingManager. Use the addTracking function to add additional tracking services.
		 * Make sure the <code>next()</code> function is called in the last line of the function otherwise the next function in the sequence will not be called.
		 */
		public function loadTracking():void
		{
			this.next();
		}
		/**
		 * Overide this function in the SiteBuilder file specific to your project.
		 * Use this function to apply any additional customization you may need for your project. For example, stage setting up alignment or a class you'll need throughout your project but doesnt fall into any specific category.
		 * Make sure the <code>next()</code> function is called in the last line of the function otherwise the next function in the sequence will not be called.
		 */
		public function loadCustomization():void
		{
			this.next();
		}
		/*
		Load Completion Notice
		*/
		final private function loadComplete():void
		{
			this.addToQueue(Config.getValue("swf_path") + "site.swf",ContainerManager.getContainer("site"));
			this.addToQueue(Config.getValue("swf_path") + "shared.swf",ContainerManager.getContainer("shared"));			
			this.status("Initialization Complete!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.BEDROCK_COMPLETE,this));
		}
		/*
		Add Command
		*/
		/**
		 * Adds an event/command relationship to the BedrockController.
		 */
		final protected function addCommand($type:String,$command:Class):void
		{
			this._objBedrockController.addCommand($type,$command);
		}
		/**
		 * Removes an event/command relationship to the BedrockController.
		 */
		final protected function removeCommand($type:String,$command:Class):void
		{
			this._objBedrockController.removeCommand($type,$command);
		}
		/*
		Add Tracking Service
		*/
		final protected function addTrackingService($name:String, $service:ITrackingService):void
		{
			TrackingManager.addService($name, $service);
		}
		/*
		Add View Functions
		*/
		final protected function addToQueue($path:String,$loader:*,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			LoadManager.addToQueue($path, $loader, $completeHandler, $errorHandler);
		}
		/*
		Config Related Stuff
		*/
		final private function loadXML($path:String):void
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
		final private function onBootUp($event:Event)
		{
			this.initialize();
		}
		final private function onConfigLoaded($event:Event):void
		{
			Config.initialize(this._objConfigLoader.data, this.loaderInfo.url, this.stage);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.CONFIG_LOADED,this));
			this.next();
		}
		final private function onConfigError($event:Event):void
		{
			this.fatal("Could not parse config!");
		}
		final private function onCSSLoaded($event:LoaderEvent)
		{
			StyleManager.parseCSS($event.details.data);
		}
	}
}