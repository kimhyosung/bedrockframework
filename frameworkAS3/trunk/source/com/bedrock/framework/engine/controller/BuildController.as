package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.core.controller.*;
	import com.bedrock.framework.core.dispatcher.DispatcherBase;
	import com.bedrock.framework.core.logging.*;
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.api.IBedrockBuilder;
	import com.bedrock.framework.engine.builder.BedrockBuilder;
	import com.bedrock.framework.engine.command.*;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.manager.*;
	import com.bedrock.framework.engine.model.*;
	import com.bedrock.framework.plugin.logging.*;
	import com.bedrock.framework.plugin.sound.GlobalSound;
	import com.bedrock.framework.plugin.storage.SuperArray;
	import com.bedrock.framework.plugin.view.Blocker;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * @private
	 */
	public class BuildController extends DispatcherBase
	{
		/*
		Variable Declarations
		*/
		public var builder:BedrockBuilder;
		
		private var _configURLIndex:uint;
		private var _configURLs:SuperArray;
		private var _configLoader:URLLoader;
		/*
		Constructor
		*/
		public function BuildController()
		{
			Bedrock.api;
		}
		/**
		 * The initialize function is automatically called once the shell.swf has finished loading itself.
		 */
		public function initialize( $builder:BedrockBuilder, $configURL:String = null ):void
		{
			this.builder = $builder;
			
			this._configURLs = new SuperArray;
			if ( this.builder.loaderInfo.parameters[ BedrockData.CONFIG_URL ] != null ) this._configURLs.push( $configURL );
			if ( $configURL != null ) this._configURLs.push( $configURL );
			this._determineConfigURLs();
			
			this._createEngineClasses();
			this._createConfigLoader();
			
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			
			this._loadConfig( this._configURLs.getSelected() );
		}
		
		private function _createEngineClasses():void
		{
			Bedrock.engine::globalSound = new GlobalSound;
			
			Bedrock.engine::transitionController = new TransitionController;
			Bedrock.engine::specialAssetController = new SpecialAssetController;
			Bedrock.engine::frontController = new FrontController;
			
			Bedrock.engine::assetManager = new AssetManager;
			Bedrock.engine::containerManager = new ContainerManager;
			Bedrock.engine::moduleManager = new ModuleManager;
			Bedrock.engine::contextMenuManager = new ContextMenuManager;
			Bedrock.engine::resourceBundleManager = new ResourceBundleManager;
			Bedrock.engine::deeplinkingManager = new DeeplinkingManager;
			Bedrock.engine::libraryManager = new LibraryManager;
			Bedrock.engine::loadController = new LoadController;
			Bedrock.engine::localeManager = new LocaleManager;
			Bedrock.engine::preloadManager = new PreloadManager;
			Bedrock.engine::stylesheetManager = new StylesheetManager;
			Bedrock.engine::trackingManager = new TrackingManager;
			
			Bedrock.engine::configModel = new ConfigModel;
			Bedrock.engine::historyModel = new HistoryModel;
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
		
		/*
		Engine Classes
		*/
		
		/*
		*/
		private function _initializeFeatureGroupA():void
		{
			this._setupStage();
			this._piggybackEvents();
			this._setupCommands();
			this._storePreloader();
			this._parseParams();
			
			if( Bedrock.data.deeplinkingEnabled ) {
				this._prepareDeeplinking();
			} else {
				this._initializeFeatureGroupB();
			}
			
		}
		private function _initializeFeatureGroupB():void
		{
			this._setupLogger();
			if ( Bedrock.data.localesEnabled ) this._setupLocales();
			this._initializeVitals();
			this._prepareBlocker();
			if ( Bedrock.data.showModulesInContextMenu ) this._setupContextMenu();

			Bedrock.engine::specialAssetController.initialize();
			
			if ( Bedrock.data.autoPrepareInitialLoad ) Bedrock.engine::transitionController.prepareInitialLoad();
			
			IBedrockBuilder( this.builder ).preinitialize();
			
			if ( !Bedrock.data.autoPrepareInitialTransition ) {
				Bedrock.engine::transitionController.runShellTransition();
			} else if ( Bedrock.data.autoPrepareInitialTransition ) {
				Bedrock.engine::transitionController.prepareInitialTransition( {} );
			}
			
			this._initializeComplete();
		}
		
		
		private function _setupStage():void
		{
			this.builder.stage.align = StageAlign[ Bedrock.data.stageAlignment ];
			this.builder.stage.scaleMode = StageScaleMode[ Bedrock.data.stageScaleMode ];
		}
		private function _piggybackEvents():void
		{
			this.addEventListener( BedrockEvent.INITIALIZE_COMPLETE, Bedrock.dispatcher.dispatchEvent );
			this.addEventListener( BedrockEvent.CONFIG_LOADED, Bedrock.dispatcher.dispatchEvent );
			
			Bedrock.engine::transitionController.addEventListener( BedrockEvent.TRANSITION_COMPLETE, Bedrock.dispatcher.dispatchEvent );
			
			Bedrock.engine::loadController.addEventListener( BedrockEvent.LOAD_BEGIN, Bedrock.dispatcher.dispatchEvent );
			Bedrock.engine::loadController.addEventListener( BedrockEvent.LOAD_ERROR, Bedrock.dispatcher.dispatchEvent );
			Bedrock.engine::loadController.addEventListener( BedrockEvent.LOAD_COMPLETE, Bedrock.dispatcher.dispatchEvent );
			Bedrock.engine::loadController.addEventListener( BedrockEvent.LOAD_PROGRESS, Bedrock.dispatcher.dispatchEvent );
			
			if ( Bedrock.data.deeplinkingEnabled ) {
				Bedrock.engine::deeplinkingManager.addEventListener( BedrockEvent.DEEPLINK_CHANGE, Bedrock.dispatcher.dispatchEvent );
				Bedrock.engine::deeplinkingManager.addEventListener( BedrockEvent.DEEPLINKING_INITIALIZED, Bedrock.dispatcher.dispatchEvent );
			}
		}
		private function _setupCommands():void
		{
			Bedrock.engine::frontController.initialize( Bedrock.dispatcher );
		
			Bedrock.engine::frontController.addCommand( BedrockEvent.SHOW_BLOCKER, ShowBlockerCommand );
			Bedrock.engine::frontController.addCommand( BedrockEvent.HIDE_BLOCKER, HideBlockerCommand );

			if ( Bedrock.data.showBlockerDuringTransitions ) {
				Bedrock.engine::frontController.addCommand( BedrockEvent.TRANSITION_PREPARED, ShowBlockerCommand );
				Bedrock.engine::frontController.addCommand( BedrockEvent.TRANSITION_COMPLETE, HideBlockerCommand );
			}
			if ( Bedrock.data.deeplinkingEnabled && Bedrock.data.deeplinkModules ) {
				Bedrock.engine::frontController.addCommand( BedrockEvent.DEEPLINK_CHANGE, DeeplinkChangeCommand );
			}
		}
		/*
		Sequential Functions
		*/
		private function _storePreloader():void
		{
			Bedrock.engine::libraryManager.registerPreloader( BedrockData.INITIAL_PRELOADER, "InitialPreloader" );
		}
		private function _parseParams():void
		{
			Bedrock.engine::configModel.parseParams( this.builder.loaderInfo.parameters );
		}
		private function _setupLogger():void
		{
			Bedrock.logger.errorsEnabled = Bedrock.data.errorsEnabled;
			
			var logger:ILoggingService = Bedrock.logger.getService( "trace" );
			logger.initialize( LogLevel[ Bedrock.data.traceLogLevel ], Bedrock.data.logDetailDepth );
			
			logger = new EventService;
			logger.initialize( LogLevel[ Bedrock.data.eventLogLevel ], Bedrock.data.logDetailDepth );
			Bedrock.logger.addService( "event", logger );
			
			logger = new MonsterService;
			logger.initialize( LogLevel[ Bedrock.data.monsterLogLevel ], Bedrock.data.logDetailDepth );
			Bedrock.logger.addService( "monster", logger );
			
		}
		private function _initializeVitals():void
		{
			Bedrock.engine::transitionController.initialize( this.builder );
			Bedrock.engine::containerManager.initialize( Bedrock.engine::configModel.containers, this.builder );
			Bedrock.engine::moduleManager.initialize( Bedrock.engine::configModel.modules );
			Bedrock.engine::assetManager.initialize( Bedrock.engine::configModel.assets );
			
			Bedrock.engine::loadController.initialize( this.builder, this.builder.loaderInfo.applicationDomain );
			
			Bedrock.engine::libraryManager.initialize( this.builder.loaderInfo.applicationDomain );
			Bedrock.engine::preloadManager.initialize( Bedrock.data.initialPreloaderTime );
			
			Bedrock.engine::trackingManager.initialize( Bedrock.data.trackingEnabled );
		}
		private function _prepareBlocker():void
		{
			var blocker:Blocker = new Blocker( Bedrock.data.blockerAlpha, Bedrock.data.blockerColor );
			blocker.name = BedrockData.BLOCKER;
			Bedrock.engine::containerManager.getContainer( BedrockData.OVERLAY ).addChildAt( blocker, 0 );
			if ( Bedrock.data.showBlockerDuringTransitions ) blocker.show();
		}
		/*
		Extras
		*/
		private function _prepareDeeplinking():void
		{
			Bedrock.engine::deeplinkingManager.addEventListener( BedrockEvent.DEEPLINKING_INITIALIZED, this._onDeeplinkingInitialized );
			Bedrock.engine::deeplinkingManager.initialize();
		}
		
		private function _setupContextMenu():void
		{
			Bedrock.engine::contextMenuManager.initialize();
			this.builder.contextMenu = Bedrock.engine::contextMenuManager.menu;
		}
		private function _setupLocales():void
		{
			if ( Bedrock.data.currentLocale == null ) Bedrock.data.defaultLocale;
			Bedrock.engine::localeManager.initialize( Bedrock.engine::configModel.locales, Bedrock.data.defaultLocale, Bedrock.data.currentLocale );
		}
		/*
		Load Completion Notice
		*/
		private function _initializeComplete():void
		{
			this.dispatchEvent( new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, this ) );
			Bedrock.logger.status( "Initialization Complete!" );
		}
		/*
		Config URLs
		*/
		private function _determineConfigURLs():void
		{
			this._configURLs.push( "../../" + BedrockData.CONFIG_FILENAME + ".xml" );
			this._configURLs.push( "../" + BedrockData.CONFIG_FILENAME + ".xml" );
			this._configURLs.push( BedrockData.CONFIG_FILENAME + ".xml" );
		}
		/*
		Config Handlers
		*/
		private function _onDeeplinkingInitialized( $event:Event ):void
		{
			Bedrock.engine::configModel.parseParams( Bedrock.engine::deeplinkingManager.getParametersAsObject() );
			this._initializeFeatureGroupB();
		}
		private function _onConfigLoaded( $event:Event ):void
		{
			Bedrock.engine::configModel.initialize( this._configLoader.data, ( this.builder.loaderInfo.parameters.environmentURL ||  this.builder.loaderInfo.url ) );
			
			Bedrock.logger.status( this.builder.loaderInfo.url );
			Bedrock.logger.status( Bedrock.data.environment );
			
			this.dispatchEvent( new BedrockEvent( BedrockEvent.CONFIG_LOADED, this ) );
			this._clearConfigLoader();
			
			this._initializeFeatureGroupA();
		}
		private function _onConfigError( $event:Event ):void
		{
			if ( this._configURLs.hasNext() ) {
				this._loadConfig( this._configURLs.selectNext() );
			} else {
				Bedrock.logger.fatal( "Could not load config!" );
			}
		}
	}
}