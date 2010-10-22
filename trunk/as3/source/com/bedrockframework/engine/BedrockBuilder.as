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
	import com.bedrockframework.plugin.loader.DataLoader;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.timer.StopWatch;
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
		public var params:String;
		
		private var _strConfigURL:String;
		private var _arrLoadSequence:Array;
		private var _numLoadIndex:Number;		
		private var _objConfigLoader:URLLoader;
		
		private var _sprContainer:Sprite;
		/*
		Constructor
		*/
		public function BedrockBuilder()
		{
			this._arrLoadSequence = new Array( "loadPreloader", "loadConfig", "parseParams", "loadLogging", "loadDeepLinking", "loadModifications", "loadCacheSettings", "loadEngineClasses", "loadContextMenu", "loadContainers","loadController","loadLocales", "loadDefaultPage", "loadFiles", "loadModels","loadCommands","loadViews","loadTracking","loadCustomization","loadComplete");
			this._numLoadIndex = 0;
			
			this.createEngineClasses();
			this.loaderInfo.addEventListener( Event.INIT, this.onBootUp );			
		}
		/**
		 * The initialize function is automatically called once the shell.swf has finished loading itself.
		 */
		final public function initialize():void
		{
			this.determineConfigURL();
			
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			
			this.next();
		}
		final private function determineConfigURL():void
		{
			if ( this._strConfigURL == null ) {
				if ( this.loaderInfo.url.indexOf( "file://" ) != -1 ) {
				} else {
					this._strConfigURL = "../../" + BedrockData.CONFIG_FILE_NAME + ".xml";
				}
				var strURL:String = this.loaderInfo.url;
				for (var i:int = 0 ; i < 3; i++) {
					strURL = strURL.substring( 0, strURL.lastIndexOf( "/" ) );
				}
				this._strConfigURL = strURL + "/" + BedrockData.CONFIG_FILE_NAME + ".xml";
			}
		}
		
		final private function createEngineClasses():void
		{
			BedrockEngine.bedrock::controller = new EngineController;
			
			BedrockEngine.assetManager = new AssetManager;
			BedrockEngine.containerManager = new ContainerManager;
			BedrockEngine.contextMenuManager = new ContextMenuManager;
			BedrockEngine.resourceManager = new ResourceBundleManager;
			BedrockEngine.deeplinkManager = new DeeplinkManager;
			BedrockEngine.fontManager = new FontManager;
			BedrockEngine.loadManager = new LoadManager;
			BedrockEngine.localeManager = new LocaleManager;
			BedrockEngine.bedrock::pageManager = new PageManager;
			BedrockEngine.pathManager = new PathManager;
			BedrockEngine.bedrock::preloaderManager = new PreloaderManager;
			BedrockEngine.soundManager = new SoundManager;
			BedrockEngine.stylesheetManager = new StylesheetManager;
			BedrockEngine.trackingManager = new TrackingManager;
			BedrockEngine.bedrock::transitionManager = new TransitionManager;
			
			BedrockEngine.config = new Config;
			BedrockEngine.history = new History;
			BedrockEngine.bedrock::state = new State;
			
			BedrockEngine.available = true;
		}
		
		final protected function next():void
		{
			var strFunction:String=this._arrLoadSequence[this._numLoadIndex];
			this._numLoadIndex+= 1;

			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.BEDROCK_PROGRESS, this, this.getProgressObject() ) );

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
			StopWatch
		}
		
		/*
		Sequential Functions
		*/
		
		
		final private function loadDeepLinking():void
		{
			if (BedrockEngine.config.getSettingValue(BedrockData.DEEP_LINKING_ENABLED)) {
				BedrockEngine.deeplinkManager.initialize();
				BedrockEngine.config.parseParams( BedrockEngine.deeplinkManager.getParameters() );
			}
			this.next();
		}
		final private function loadConfig():void
		{
			var strConfigURL:String;
			this.status( this.loaderInfo.url );
			this.loadConfigXML( this.loaderInfo.parameters.configURL || this._strConfigURL );
		}
		final private function parseParams():void
		{
			BedrockEngine.config.parseParams( this.params );
			BedrockEngine.config.parseParams( this.loaderInfo.parameters );
			this.next();
		}
		
		final private function loadContextMenu():void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.SHOW_PAGES_IN_CONTEXT_MENU ) ) {
				BedrockEngine.contextMenuManager.initialize();
				this.contextMenu = BedrockEngine.contextMenuManager.menu;
			}
			this.next();
		}
		final private function loadPreloader():void
		{
			BedrockEngine.assetManager.addPreloader( "shell_preloader", "ShellPreloader" );
			this.next();
		}
		final private function loadCacheSettings():void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.CACHE_PREVENTION_ENABLED ) && BedrockEngine.config.getSettingValue( BedrockData.ENVIRONMENT ) != BedrockData.LOCAL ) {
				DataLoader.cachePrevention = true;
				VisualLoader.cachePrevention = true;
				DataLoader.cacheKey = BedrockEngine.config.getSettingValue( BedrockData.CACHE_KEY );
				VisualLoader.cacheKey = BedrockEngine.config.getSettingValue( BedrockData.CACHE_KEY );
			}
			this.next();
		}
		final private function loadLogging():void
		{
			Logger.detailDepth = BedrockEngine.config.getSettingValue( BedrockData.LOG_DETAIL_DEPTH );
			Logger.errorsEnabled = BedrockEngine.config.getSettingValue( BedrockData.ERRORS_ENABLED );
			Logger.traceLevel = LogLevel[ BedrockEngine.config.getSettingValue( BedrockData.TRACE_LOG_LEVEL ) ];
			Logger.eventLevel = LogLevel[ BedrockEngine.config.getSettingValue( BedrockData.EVENT_LOG_LEVEL ) ];
			Logger.remoteLevel = LogLevel[ BedrockEngine.config.getSettingValue( BedrockData.REMOTE_LOG_LEVEL ) ];
			Logger.monsterLevel = LogLevel[ BedrockEngine.config.getSettingValue( BedrockData.MONSTER_LOG_LEVEL ) ];
			Logger.remoteLogURL = BedrockEngine.config.getSettingValue( BedrockData.REMOTE_LOG_URL );
			
			this.next();
		}
		final private function loadLocales():void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.LOCALES_ENABLED ) ) {
				var strCurrentLocale:String = BedrockEngine.config.getSettingValue( BedrockData.CURRENT_LOCALE );
				var strDefaultLocale:String = BedrockEngine.config.getSettingValue( BedrockData.DEFAULT_LOCALE );
				var arrLocalized:Array =  BedrockEngine.config.getSettingValue( BedrockData.LOCALIZED_FILES ).split( "," );
				BedrockEngine.localeManager.initialize( BedrockEngine.config.locales, arrLocalized, strDefaultLocale, strCurrentLocale, BedrockEngine.config.getSettingValue( BedrockData.LOCALE_DELIMITER ) );
			}
			this.next();
		}
		final private function loadFiles():void
		{
			BedrockEngine.pathManager.initialize();
			if ( BedrockEngine.config.getSettingValue( BedrockData.LOCALES_ENABLED ) ) {
				BedrockEngine.pathManager.load( BedrockEngine.localeManager.currentLocale, true );
			} else {
				BedrockEngine.pathManager.load( null, true );
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
			BedrockEngine.assetManager.initialize( this.loaderInfo.applicationDomain );
			BedrockEngine.loadManager.initialize( this.loaderInfo.applicationDomain );
			
			BedrockEngine.bedrock::pageManager.initialize( BedrockEngine.config.pages );
			
			BedrockEngine.bedrock::preloaderManager.initialize( BedrockEngine.config.getSettingValue(BedrockData.SHELL_PRELOADER_TIME ) );
			BedrockEngine.bedrock::transitionManager.initialize();
			
			BedrockEngine.trackingManager.initialize(BedrockEngine.config.getSettingValue( BedrockData.TRACKING_ENABLED ) );
			
			this.next();			
		}
		final private function loadDefaultPage():void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.AUTO_DEFAULT_ENABLED ) ) {
				BedrockEngine.bedrock::transitionManager.loadDefaultPage();
			}
			this.next();			
		}
		final private function loadContainers():void
		{
			this._sprContainer = new Sprite;
			this.addChild( this._sprContainer );
			BedrockEngine.containerManager.initialize( BedrockEngine.config.containers, this._sprContainer );
			
			var objSiteLoader:VisualLoader = new VisualLoader;
			BedrockEngine.containerManager.replaceContainer( BedrockData.SITE_CONTAINER, objSiteLoader );
			BedrockEngine.bedrock::transitionManager.siteLoader = objSiteLoader;
			
			BedrockEngine.containerManager.replaceContainer( BedrockData.SHARED_CONTAINER, new VisualLoader );
			
			var objPageView:ContainerView = new ContainerView;
			objPageView.hold( new VisualLoader );
			BedrockEngine.containerManager.replaceContainer( BedrockData.PAGE_CONTAINER, objPageView );
			BedrockEngine.bedrock::transitionManager.pageLoader = objPageView.child;
			
			BedrockEngine.containerManager.replaceContainer( BedrockData.PRELOADER_CONTAINER, new ContainerView );
			
			var objBlocker:Blocker=new Blocker( BedrockEngine.config.getSettingValue(BedrockData.BLOCKER_ALPHA ) );
			BedrockEngine.containerManager.replaceContainer( BedrockData.BLOCKER_CONTAINER, objBlocker );
			if (BedrockEngine.config.getSettingValue( BedrockData.AUTO_BLOCKER_ENABLED) ) {
				objBlocker.show();
			}
			
			this.next();
		}
		/*
		Load Completion Notice
		*/
		final private function loadComplete():void
		{
			var r:int = 1;
			if ( BedrockEngine.config.getSettingValue( BedrockData.SHARED_ENABLED ) ) {
				var objLoader:VisualLoader = BedrockEngine.containerManager.getContainer( BedrockData.SHARED_CONTAINER );
				objLoader.addEventListener( LoaderEvent.INIT, this.onSharedLoaded );
			}
			this.addToQueue( BedrockEngine.config.getPathValue( BedrockData.SWF_PATH ) + BedrockEngine.config.getSettingValue( BedrockData.SITE_FILENAME ) + ".swf", BedrockEngine.containerManager.getContainer( BedrockData.SITE_CONTAINER ), BedrockData.SITE_PRIORITY );
						
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
		final protected function addTrackingService($id:String, $service:ITrackingService):void
		{
			BedrockEngine.trackingManager.addService($id, $service);
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
		final private function loadConfigXML( $path:String ):void
		{
			this.createLoader( $path );
		}
		/*
		Create Loader
	 	*/
	 	final private function createLoader( $path:String ):void
		{
			this._objConfigLoader = new URLLoader();
			this._objConfigLoader.addEventListener(Event.COMPLETE, this.onConfigLoaded,false,0,true);
			this._objConfigLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onConfigError,false,0,true);
			this._objConfigLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConfigError,false,0,true);
			this._objConfigLoader.load( new URLRequest( $path ) );
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
			BedrockEngine.config.initialize( this._objConfigLoader.data, ( this.loaderInfo.parameters.environmentURL || this.loaderInfo.url ) );
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.CONFIG_LOADED, this ) );
			this.next();
		}
		final private function onConfigError($event:Event):void
		{
			this.fatal( "Could not parse config!" );
		}
		final private function onStylesheetLoaded($event:LoaderEvent):void
		{
			BedrockEngine.stylesheetManager.parseStylesheet($event.details.data);
		}
		final private function onSharedLoaded($event:LoaderEvent):void
		{
			$event.origin.content.initialize();
			if ( BedrockEngine.config.getSettingValue( BedrockData.SHARED_SOUNDS_ENABLED ) ) {
				BedrockEngine.soundManager.initialize( BedrockEngine.assetManager.getSounds( true ) );
			}
		}
	}
}