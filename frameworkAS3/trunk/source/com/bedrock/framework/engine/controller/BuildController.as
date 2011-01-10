package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.core.base.DispatcherBase;
	import com.bedrock.framework.core.controller.*;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.core.logging.*;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.IBedrockBuilder;
	import com.bedrock.framework.engine.bedrock;
	import com.bedrock.framework.engine.builder.BedrockBuilder;
	import com.bedrock.framework.engine.command.*;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.manager.*;
	import com.bedrock.framework.engine.model.*;
	import com.bedrock.framework.plugin.logging.EventLogger;
	import com.bedrock.framework.plugin.logging.MonsterLogger;
	import com.bedrock.framework.plugin.logging.TraceLogger;
	import com.bedrock.framework.plugin.view.Blocker;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class BuildController extends DispatcherBase
	{
		/*
		Variable Declarations
		*/
		public var builder:BedrockBuilder;
		
		private var _configURL:String;
		private var _configLoader:URLLoader;
		/*
		Constructor
		*/
		public function BuildController()
		{
		}
		/**
		 * The initialize function is automatically called once the shell.swf has finished loading itself.
		 */
		public function initialize( $builder:BedrockBuilder ):void
		{
			this.builder = $builder;
			this._createEngineClasses();
			
			this._createConfigLoader();
			this._determineConfigURL();
			
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			
			this.status( this.builder.loaderInfo.url );
			this._loadConfig( this.builder.loaderInfo.parameters[ BedrockData.CONFIG_URL ] || this._configURL );
		}
		/*
		Config Functions
		*/
		private function _createConfigLoader():void
		{
			this._configLoader = new URLLoader();
			this._configLoader.addEventListener( "complete", this._onConfigLoaded, false, 0, true );
			this._configLoader.addEventListener( "ioError", this._onConfigError, false, 0, true );
			this._configLoader.addEventListener( "securityError", this._onConfigError, false, 0, true );
		}
		private function _clearConfigLoader():void
		{			
			this._configLoader.removeEventListener( "complete", this._onConfigLoaded );
			this._configLoader.removeEventListener(  "ioError", this._onConfigError );
			this._configLoader.removeEventListener( "securityError", this._onConfigError );
			this._configLoader = null;
		}
		private function _loadConfig( $path:String ):void
		{
			this._configLoader.load( new URLRequest( $path ) );
		}
		
		private function _determineConfigURL():void
		{
			if ( this._configURL == null ) {
				if ( this.builder.loaderInfo.url.indexOf( "file://" ) != -1 ) {
				} else {
					this._configURL = "../../" + BedrockData.CONFIG_FILENAME + ".xml";
				}
				var strURL:String = this.builder.loaderInfo.url;
				for (var i:int = 0 ; i < 3; i++) {
					strURL = strURL.substring( 0, strURL.lastIndexOf( "/" ) );
				}
				this._configURL = strURL + "/" + BedrockData.CONFIG_FILENAME + ".xml";
			}
		}
		/*
		Engine Classes
		*/
		private function _createEngineClasses():void
		{
			BedrockEngine.bedrock::transitionController = new TransitionController;
			BedrockEngine.bedrock::resourceController = new ResourceController;
			BedrockEngine.frontController = new FrontController;
			BedrockEngine.data = BedrockData.getInstance();
			
			BedrockEngine.assetManager = new AssetManager;
			BedrockEngine.containerManager = new ContainerManager;
			BedrockEngine.contentManager = new ContentManager;
			BedrockEngine.contextMenuManager = new ContextMenuManager;
			BedrockEngine.dataBundleManager = new DataBundleManager;
			BedrockEngine.deeplinkingManager = new DeeplinkingManager;
			BedrockEngine.libraryManager = new LibraryManager;
			BedrockEngine.loadController = new LoadController;
			BedrockEngine.localeManager = new LocaleManager;
			BedrockEngine.bedrock::preloadManager = new PreloadManager;
			BedrockEngine.stylesheetManager = new StylesheetManager;
			BedrockEngine.trackingManager = new TrackingManager;
			
			BedrockEngine.bedrock::config = new Config;
			BedrockEngine.history = new History;
		}
		/*
		*/
		private function _initializeFeatureGroupA():void
		{
			this._setupStage();
			this._piggybackEvents();
			this._setupCommands();
			this._storePreloader();
			this._parseParams();
			
			if( BedrockEngine.data.deeplinkingEnabled ) {
				this._prepareDeeplinking();
			} else {
				this._initializeFeatureGroupB();
			}
			
		}
		private function _initializeFeatureGroupB():void
		{
			this._setupLogger();
			if ( BedrockEngine.data.localesEnabled ) this._setupLocales();
			this._initializeVitals();
			this._prepareBlocker();
			if ( BedrockEngine.data.showPagesInContextMenu ) this._setupContextMenu();

			BedrockEngine.bedrock::resourceController.initialize();
			
			IBedrockBuilder( this.builder ).preinitialize();
			
			BedrockEngine.bedrock::resourceController.queue( false );
			
			if ( !BedrockEngine.data.autoPrepareInitialLoad && !BedrockEngine.data.autoPrepareInitialTransition ) {
				BedrockEngine.bedrock::transitionController.runShellTransition();
			} else if ( BedrockEngine.data.autoPrepareInitialLoad && !BedrockEngine.data.autoPrepareInitialTransition ) {
				BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.PREPARE_INITIAL_LOAD, this ) );
				BedrockEngine.bedrock::transitionController.runShellTransition();
			} else if ( BedrockEngine.data.autoPrepareInitialLoad && BedrockEngine.data.autoPrepareInitialTransition ) {
				BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.PREPARE_INITIAL_LOAD, this ) );
				BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.PREPARE_INITIAL_TRANSITION, this ) );
			}
			
			this._initializeComplete();
		}
		
		
		private function _setupStage():void
		{
			this.builder.stage.align = StageAlign[ BedrockEngine.data.stageAlignment ];
			this.builder.stage.scaleMode = StageScaleMode[ BedrockEngine.data.stageScaleMode ];
		}
		private function _piggybackEvents():void
		{
			BedrockEngine.bedrock::transitionController.addEventListener( BedrockEvent.TRANSITION_COMPLETE, BedrockDispatcher.dispatchEvent );
			BedrockEngine.loadController.addEventListener( BedrockEvent.LOAD_COMPLETE, BedrockDispatcher.dispatchEvent );
			BedrockEngine.loadController.addEventListener( BedrockEvent.LOAD_PROGRESS, BedrockDispatcher.dispatchEvent );
			
			if ( BedrockEngine.data.deeplinkingEnabled ) {
				BedrockEngine.deeplinkingManager.addEventListener( BedrockEvent.DEEPLINK_CHANGE, BedrockDispatcher.dispatchEvent );
				BedrockEngine.deeplinkingManager.addEventListener( BedrockEvent.DEEPLINKING_INITIALIZED, BedrockDispatcher.dispatchEvent );
			}
		}
		private function _setupCommands():void
		{
			BedrockEngine.frontController.addCommand( BedrockEvent.SHOW_BLOCKER, ShowBlockerCommand );
			BedrockEngine.frontController.addCommand( BedrockEvent.HIDE_BLOCKER, HideBlockerCommand );

			if ( BedrockEngine.data.showBlockerDuringTransitions ) {
				BedrockEngine.frontController.addCommand( BedrockEvent.TRANSITION_PREPARED, ShowBlockerCommand );
				BedrockEngine.frontController.addCommand( BedrockEvent.TRANSITION_COMPLETE, HideBlockerCommand );
			}
		}
		/*
		Sequential Functions
		*/
		private function _storePreloader():void
		{
			BedrockEngine.libraryManager.registerPreloader( BedrockData.INITIAL_PRELOADER, "InitialPreloader" );
		}
		private function _parseParams():void
		{
			BedrockEngine.bedrock::config.parseParams( this.builder.loaderInfo.parameters );
		}
		private function _setupLogger():void
		{
			Logger.errorsEnabled = BedrockEngine.data.errorsEnabled;
			
			var logger:ILogger = new TraceLogger;
			logger.initialize( LogLevel[ BedrockEngine.data.traceLogLevel ], BedrockEngine.data.logDetailDepth );
			Logger.addTarget( logger );
			
			logger = new EventLogger;
			logger.initialize( LogLevel[ BedrockEngine.data.eventLogLevel ], BedrockEngine.data.logDetailDepth );
			Logger.addTarget( logger );
			
			logger = new MonsterLogger;
			logger.initialize( LogLevel[ BedrockEngine.data.monsterLogLevel ], BedrockEngine.data.logDetailDepth );
			Logger.addTarget( logger );
			
		}
		private function _initializeVitals():void
		{
			BedrockEngine.bedrock::transitionController.initialize( this.builder );
			BedrockEngine.containerManager.initialize( BedrockEngine.bedrock::config.containers, this.builder );
			BedrockEngine.contentManager.initialize( BedrockEngine.bedrock::config.contents );
			BedrockEngine.assetManager.initialize( BedrockEngine.bedrock::config.assets );
			
			BedrockEngine.loadController.initialize( this.builder, this.builder.loaderInfo.applicationDomain );
			
			BedrockEngine.libraryManager.initialize( this.builder.loaderInfo.applicationDomain );
			BedrockEngine.bedrock::preloadManager.initialize( BedrockEngine.data.initialPreloaderTime );
			
			BedrockEngine.trackingManager.initialize( BedrockEngine.data.trackingEnabled );
		}
		private function _prepareBlocker():void
		{
			var blocker:Blocker = new Blocker( BedrockEngine.data.blockerAlpha, BedrockEngine.data.blockerColor );
			blocker.name = BedrockData.BLOCKER;
			BedrockEngine.containerManager.getContainer( BedrockData.OVERLAY ).addChildAt( blocker, 0 );
			if ( BedrockEngine.data.showBlockerDuringTransitions ) blocker.show();
		}
		/*
		Extras
		*/
		private function _prepareDeeplinking():void
		{
			BedrockEngine.deeplinkingManager.addEventListener( BedrockEvent.DEEPLINKING_INITIALIZED, this._onDeeplinkingInitialized );
			BedrockEngine.deeplinkingManager.initialize();
		}
		
		private function _setupContextMenu():void
		{
			BedrockEngine.contextMenuManager.initialize();
			this.builder.contextMenu = BedrockEngine.contextMenuManager.menu;
		}
		private function _setupLocales():void
		{
			if ( BedrockEngine.data.currentLocale == null ) BedrockEngine.data.defaultLocale;
			BedrockEngine.localeManager.initialize( BedrockEngine.bedrock::config.locales, BedrockEngine.data.defaultLocale, BedrockEngine.data.currentLocale );
		}
		/*
		Load Completion Notice
		*/
		private function _initializeComplete():void
		{
			this.dispatchEvent( new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, this ) );
			this.status( "Initialization Complete!" );
		}
		
		/*
		Config Handlers
		*/
		private function _onDeeplinkingInitialized( $event:Event ):void
		{
			BedrockEngine.bedrock::config.parseParams( BedrockEngine.deeplinkingManager.getParametersAsObject() );
			this._initializeFeatureGroupB();
		}
		private function _onConfigLoaded( $event:Event ):void
		{
			BedrockEngine.bedrock::config.initialize( this._configLoader.data, ( this.builder.loaderInfo.parameters.environmentURL ||  this.builder.loaderInfo.url ) );
			this.dispatchEvent( new BedrockEvent( BedrockEvent.CONFIG_LOADED, this ) );
			this._clearConfigLoader();
			
			this._initializeFeatureGroupA();
		}
		private function _onConfigError( $event:Event ):void
		{
			this.fatal( "Could not parse config!" );
		}
	}
}