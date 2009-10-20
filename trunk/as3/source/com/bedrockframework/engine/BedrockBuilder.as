﻿/**
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
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.command.*;
	import com.bedrockframework.engine.controller.EngineController;
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
	import com.bedrockframework.plugin.tracking.ITrackingService;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;

	public class BedrockBuilder extends MovieClipWidget
	{
		/*
		Variable Declarations
		*/
		public var configURL:String;
		public var params:String
		
		private var _arrLoadSequence:Array=new Array("loadPreloader","loadParams","loadConfig","loadContainer","loadDeepLinking","loadCacheSettings", "loadLogging","loadServices","loadEngineClasses","loadController","loadEngineContainers", "loadFonts", "loadResourceBundle", "loadCSS", "loadLocale", "loadDefaultPage", "loadModels","loadCommands","loadViews","loadTracking","loadCustomization","loadComplete");
		private var _numLoadIndex:Number;		
		private var _objConfigLoader:URLLoader;
		public var environmentURL:String;
		
		private var _sprContainer:Sprite;
		/*
		Constructor
		*/
		public function BedrockBuilder()
		{
			this._numLoadIndex=0;
			
			this.createEngineClasses();
			this.loaderInfo.addEventListener(Event.INIT, this.onBootUp);			
		}
		/**
		 * The initialize function is automatically called once the shell.swf has finished loading itself.
		 */
		final public function initialize():void
		{
			this.determineConfigURL();
			this.next();
		}
		
		final private function determineConfigURL():void
		{
			if ( this.configURL == null ) {
				if ( this.loaderInfo.url.indexOf( "file://" ) != -1 ) {
				} else {
					this.configURL = "../../" + BedrockData.CONFIG_FILE_NAME + ".xml";
				}
					var strURL:String = this.loaderInfo.url;
					for (var i:int = 0 ; i < 3; i++) {
						strURL = strURL.substring( 0, strURL.lastIndexOf( "/" ) );
					}
					this.configURL = strURL + "/" + BedrockData.CONFIG_FILE_NAME + ".xml";
			}
		}
		
		final private function createEngineClasses():void
		{
			BedrockEngine.bedrock::controller = new EngineController;
			
			BedrockEngine.assetManager = new AssetManager;
			BedrockEngine.containerManager = new ContainerManager;
			BedrockEngine.resourceManager = new ResourceManager;
			BedrockEngine.deeplinkManager = new DeepLinkManager;
			BedrockEngine.fontManager = new FontManager;
			BedrockEngine.loadManager = new LoadManager;
			BedrockEngine.localeManager = new LocaleManager;
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
		final private function loadPreloader():void
		{
			BedrockEngine.assetManager.addPreloader(BedrockData.SHELL_PRELOADER, ShellPreloader);
			this.next();
		}
		final private function loadParams():void
		{
			BedrockEngine.config.parseParamString(this.params);
			BedrockEngine.config.parseParamObject(this.loaderInfo.parameters);
			this.next();
		}
		
		final private function loadConfig():void
		{
			var strConfigURL:String;
			this.loadConfigXML(BedrockEngine.config.getParamValue(BedrockData.CONFIG_URL) ||this.configURL);
			this.status(this.loaderInfo.url);
			this.next();
		}
		final private function loadDeepLinking():void
		{
			if (BedrockEngine.config.getSettingValue(BedrockData.DEEP_LINKING_ENABLED)) {
				BedrockDispatcher.addEventListener(BedrockEvent.DEEP_LINK_INITIALIZE, this.onDeepLinkInitialized);
				BedrockEngine.deeplinkManager.initialize();
			} else {
				this.next();
			}	
		}
		final private function loadCacheSettings():void
		{
			if (BedrockEngine.config.getSettingValue(BedrockData.CACHE_PREVENTION_ENABLED) && BedrockEngine.config.getSettingValue(BedrockData.ENVIRONMENT) != BedrockData.LOCAL) {
				BackgroundLoader.cachePrevention = true;
				VisualLoader.cachePrevention = true;
				BackgroundLoader.cacheKey = BedrockEngine.config.getSettingValue(BedrockData.CACHE_KEY);
				VisualLoader.cacheKey = BedrockEngine.config.getSettingValue(BedrockData.CACHE_KEY);
			}
			this.next();
		}
		final private function loadLogging():void
		{
			Logger.localLevel = LogLevel[BedrockEngine.config.getParamValue(BedrockData.LOCAL_LOG_LEVEL)  || BedrockEngine.config.getEnvironmentValue(BedrockData.LOCAL_LOG_LEVEL)];
			Logger.eventLevel = LogLevel[BedrockEngine.config.getParamValue(BedrockData.EVENT_LOG_LEVEL)  || BedrockEngine.config.getEnvironmentValue(BedrockData.EVENT_LOG_LEVEL)];
			Logger.remoteLevel = LogLevel[BedrockEngine.config.getParamValue(BedrockData.REMOTE_LOG_LEVEL)  || BedrockEngine.config.getEnvironmentValue(BedrockData.REMOTE_LOG_LEVEL)];
			Logger.remoteLogURL = BedrockEngine.config.getEnvironmentValue(BedrockData.REMOTE_LOG_URL);
			this.next();
		}
		final private function loadContainer():void
		{
			this._sprContainer = new Sprite;
			this.addChild(this._sprContainer);
			BedrockEngine.containerManager.initialize(this._sprContainer);
		}
		final private function loadFonts():void
		{
			if ( BedrockEngine.config.getSettingValue(BedrockData.FONTS_ENABLED) ) {
				if ( !BedrockEngine.config.getSettingValue( BedrockData.LOCALE_ENABLED ) ) {
					var strPath:String = BedrockEngine.config.getEnvironmentValue( BedrockData.SWF_PATH ) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX ) + BedrockEngine.config.getSettingValue( BedrockData.FONTS_FILE_NAME ) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + ".swf";
					this.addToQueue( strPath, BedrockEngine.fontManager.loader );
				}
			}
			this.next();
		}
		final private function loadResourceBundle():void
		{
			if ( BedrockEngine.config.getSettingValue(BedrockData.RESOURCE_BUNDLE_ENABLED) ) {
				if ( !BedrockEngine.config.getSettingValue( BedrockData.LOCALE_ENABLED ) ) {
					var strPath:String = BedrockEngine.config.getEnvironmentValue( BedrockData.XML_PATH ) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX ) + BedrockEngine.config.getSettingValue( BedrockData.RESOURCE_BUNDLE_FILE_NAME ) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + ".xml";
					this.addToQueue( strPath, BedrockEngine.resourceManager.loader );
				}
			}			
			this.next();
		}
		final private function loadCSS():void
		{
			if (BedrockEngine.config.getSettingValue( BedrockData.STYLESHEET_ENABLED) ) {
				if ( !BedrockEngine.config.getSettingValue( BedrockData.LOCALE_ENABLED ) ) {
					var strPath:String = BedrockEngine.config.getEnvironmentValue( BedrockData.CSS_PATH ) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX ) + BedrockEngine.config.getSettingValue( BedrockData.STYLE_SHEET_FILE_NAME ) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + ".css";
					this.addToQueue( strPath, BedrockEngine.styleManager.loader );
				}
			}	
			this.next();
		}
		final private function loadLocale():void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.LOCALE_ENABLED ) ) {
				var strDefaultLocale:String = BedrockEngine.config.getParamValue( BedrockData.DEFAULT_LOCALE ) || BedrockEngine.config.getLocaleValue(BedrockData.DEFAULT_LOCALE);
				BedrockEngine.localeManager.initialize( BedrockEngine.config.getLocaleValue( BedrockData.LOCALES ), strDefaultLocale );
				BedrockEngine.localeManager.load( strDefaultLocale, true );
			}
			this.next();
		}
		final private function loadController():void
		{
			BedrockEngine.bedrock::controller.initialize();
			this.next();
		}
		final private function loadEngineClasses():void
		{
			BedrockEngine.bedrock::preloaderManager.initialize(BedrockEngine.config.getSettingValue(BedrockData.PRELOADER_TIME));
			BedrockEngine.bedrock::transitionManager.initialize();
			
			BedrockEngine.trackingManager.initialize(BedrockEngine.config.getEnvironmentValue(BedrockData.TRACKING_ENABLED));
			
			this.next();			
		}
		final private function loadEngineContainers():void
		{			
			BedrockEngine.containerManager.buildLayout(BedrockEngine.config.getSettingValue(BedrockData.LAYOUT));
			BedrockEngine.bedrock::transitionManager.siteLoader = BedrockEngine.containerManager.getContainer(BedrockData.SITE_CONTAINER) as VisualLoader;
			
			var objBlocker:Blocker=new Blocker(BedrockEngine.config.getParamValue(BedrockData.BLOCKER_ALPHA));
			BedrockEngine.containerManager.replaceContainer( BedrockData.BLOCKER_CONTAINER, objBlocker );
			if (BedrockEngine.config.getSettingValue( BedrockData.AUTO_BLOCKER_ENABLED) ) {
				objBlocker.show();
			}
			
			this.next();
		}
		final private function loadServices():void
		{
			try{
				if (BedrockEngine.config.getSettingValue(BedrockData.REMOTING_ENABLED)) {
					BedrockEngine.serviceManager.initialize(BedrockEngine.config.getEnvironmentValue(BedrockData.REMOTING))
				}				
			}catch($error:Error){
			}
			this.next();
		}
		final private function loadDefaultPage():void
		{
			var bolAutoDefault:Boolean = BedrockEngine.config.getSettingValue(BedrockData.AUTO_DEFAULT_ENABLED);
			BedrockEngine.bedrock::pageManager.initialize(bolAutoDefault);
			this.next();
		}
		/*
		Load Completion Notice
		*/
		final private function loadComplete():void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.SHARED_ENABLED ) ) {
				this.addToQueue(BedrockEngine.config.getEnvironmentValue(BedrockData.SWF_PATH) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX ) + BedrockEngine.config.getSettingValue( BedrockData.SHARED_FILE_NAME ) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX )	 + ".swf", BedrockEngine.containerManager.getContainer(BedrockData.SHARED_CONTAINER), BedrockData.SHARED_PRIORITY, null, this.onSharedLoaded);
			}
			this.addToQueue(BedrockEngine.config.getEnvironmentValue(BedrockData.SWF_PATH) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX ) + BedrockEngine.config.getSettingValue( BedrockData.SITE_FILE_NAME ) + BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + ".swf", BedrockEngine.containerManager.getContainer(BedrockData.SITE_CONTAINER), BedrockData.SITE_PRIORITY);
						
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
		final protected function addToQueue($path:String, $loader:* = null, $priority:uint=0, $id:String = null, $completeHandler:Function=null, $errorHandler:Function=null):void
		{
			BedrockEngine.loadManager.addToQueue($path, $loader, $priority, $id, $completeHandler, $errorHandler);
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
			BedrockEngine.config.initialize( this._objConfigLoader.data, this.environmentURL || this.loaderInfo.url, this );
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.CONFIG_LOADED, this ) );
			this.next();
		}
		final private function onDeepLinkInitialized($event:BedrockEvent):void
		{
			BedrockEngine.config.parseParamString($event.details.query);
			BedrockDispatcher.removeEventListener( BedrockEvent.DEEP_LINK_INITIALIZE, this.onDeepLinkInitialized );
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
			if ( BedrockEngine.config.getSettingValue( BedrockData.SHARED_SOUNDS_ENABLED ) ) {
				BedrockEngine.soundManager.initialize( BedrockEngine.assetManager.getSounds() );
			}
		}
	}
}