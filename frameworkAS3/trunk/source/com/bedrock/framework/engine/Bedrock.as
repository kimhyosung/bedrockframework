package com.bedrock.framework.engine
{
	import com.bedrock.framework.core.controller.FrontController;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.core.logging.BedrockLogger;
	import com.bedrock.framework.engine.api.*;
	import com.bedrock.framework.engine.controller.*;
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockContentData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.manager.*;
	import com.bedrock.framework.engine.model.*;
	import com.bedrock.framework.plugin.sound.GlobalSound;
	import com.bedrock.framework.plugin.tracking.ITrackingService;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public class Bedrock
	{
		/*
		Variable Definitions
	 	*/
		engine static var data:BedrockData;
		engine static var logger:BedrockLogger;
		engine static var dispatcher:BedrockDispatcher;
		engine static var globalSound:GlobalSound;
		
		engine static var transitionController:TransitionController;
		//bedrock static var sequenceController:SequenceController;
		engine static var specialAssetController:SpecialAssetController;
		engine static var frontController:FrontController;
		engine static var loadController:LoadController;
		
		engine static var assetManager:AssetManager;
		engine static var containerManager:ContainerManager;
		engine static var contentManager:ContentManager;
		engine static var contextMenuManager:ContextMenuManager;
		engine static var resourceBundleManager:ResourceBundleManager;
		engine static var deeplinkingManager:DeeplinkingManager;
		engine static var libraryManager:LibraryManager;
		engine static var localeManager:LocaleManager;
		engine static var preloadManager:PreloadManager;		
		engine static var stylesheetManager:StylesheetManager;
		engine static var trackingManager:TrackingManager;
		
		engine static var config:Config;
		engine static var history:History;
		
		/*
		Variable Declarations
		*/
		private static var __instance:Bedrock;
		/*
		Constructor
	 	*/
		public function Bedrock( $enforcer:SingletonEnforcer )
		{
		}
		
		private static function __initialize():void
		{
			Bedrock.__instance = new Bedrock( new SingletonEnforcer );
			
			Bedrock.engine::logger = BedrockLogger.instance;
			Bedrock.engine::data = BedrockData.instance;
			Bedrock.engine::dispatcher = BedrockDispatcher.instance;
			Bedrock.engine::globalSound = new GlobalSound;
			
			Bedrock.engine::transitionController = new TransitionController;
			Bedrock.engine::specialAssetController = new SpecialAssetController;
			Bedrock.engine::frontController = new FrontController;
			
			Bedrock.engine::assetManager = new AssetManager;
			Bedrock.engine::containerManager = new ContainerManager;
			Bedrock.engine::contentManager = new ContentManager;
			Bedrock.engine::contextMenuManager = new ContextMenuManager;
			Bedrock.engine::resourceBundleManager = new ResourceBundleManager;
			Bedrock.engine::deeplinkingManager = new DeeplinkingManager;
			Bedrock.engine::libraryManager = new LibraryManager;
			Bedrock.engine::loadController = new LoadController;
			Bedrock.engine::localeManager = new LocaleManager;
			Bedrock.engine::preloadManager = new PreloadManager;
			Bedrock.engine::stylesheetManager = new StylesheetManager;
			Bedrock.engine::trackingManager = new TrackingManager;
			
			Bedrock.engine::config = new Config;
			Bedrock.engine::history = new History;
		}
	 	/*
		Accessors
	 	*/
	 	public static function get api():Bedrock
		{
			if ( !Bedrock.__instance ) Bedrock.__initialize();
			return Bedrock.__instance;
		}
		public static function get data():BedrockData
		{
			if ( !Bedrock.__instance ) Bedrock.__initialize();
			return Bedrock.engine::data;
		}
		public static function get logger():BedrockLogger
		{
			if ( !Bedrock.__instance ) Bedrock.__initialize();
			return Bedrock.engine::logger;
		}
		public static function get dispatcher():BedrockDispatcher
		{
			if ( !Bedrock.__instance ) Bedrock.__initialize();
			return Bedrock.engine::dispatcher;
		}
		public static function get library():LibraryManager
		{
			if ( !Bedrock.__instance ) Bedrock.__initialize();
			return Bedrock.engine::libraryManager;
		}
		public static function get deeplink():DeeplinkingManager
		{
			if ( !Bedrock.__instance ) Bedrock.__initialize();
			return Bedrock.engine::deeplinkingManager;
		}
		/*
		API Calls
		*/
		/*
		AssetManager
		*/
		public function getAsset($id:String):BedrockAssetData
		{
			return Bedrock.engine::assetManager.getAsset( $id );
		}
		public function hasAsset($id:String):Boolean
		{
			return Boolean( Bedrock.engine::assetManager.hasAsset( $id ) );
		}
		public function filterAssets($value:*, $field:String):Array
		{
			return Bedrock.engine::assetManager.filterAssets( $value, $field );
		}
		public function addAssetToGroup($groupID:String, $asset:BedrockAssetData):void
		{
			Bedrock.engine::assetManager.addAssetToGroup( $groupID, $asset );
		}
		public function hasAssetGroup($id:String):Boolean
		{
			return Boolean( Bedrock.engine::assetManager.hasGroup( $id ) );
		}
		public function getAssetGroup($id:String):BedrockAssetGroupData
		{
			return Bedrock.engine::assetManager.getGroup( $id );
		}
		public function filterAssetGroups($value:*, $field:String):Array
		{
			return Bedrock.engine::assetManager.filterGroups( $value, $field );
		}
		/*
		ContentManager
		*/
		public function addContent($data:BedrockContentData):void
		{
			Bedrock.engine::contentManager.addContent( $data );
		}
		public function addAssetToContent( $contentID:String, $asset:BedrockAssetData ):void
		{
			Bedrock.engine::contentManager.addAssetToContent( $contentID, $asset );
		}
		public function getContent($id:String):BedrockContentData
		{
			return Bedrock.engine::contentManager.getContent( $id );
		}
		public function hasContent($id:String):Boolean
		{
			return Boolean( Bedrock.engine::contentManager.hasContent( $id ) );
		}
		public function getIndexedContent():Array
		{
			return this.filterContent( true, BedrockData.INDEXED );
		}
		public function filterContent( $value:*, $field:String):Array
		{
			return Bedrock.engine::contentManager.filterContent( $value, $field );
		}
		/*
		ContainerManager
		*/
		public function getContainer($id:String):*
		{
			return Bedrock.engine::containerManager.getContainer( $id );
		}
		public function removeContainer($id:String):void
		{
			Bedrock.engine::containerManager.removeContainer( $id );
		}
		public function hasContainer($id:String):Boolean
		{
			return Boolean( Bedrock.engine::containerManager.hasContainer( $id ) );
		}
		public function get root():DisplayObjectContainer
		{
			return Bedrock.engine::containerManager.root;
		}
		/*
		DataBundleManager
		*/
		public function getResourceBundle( $id:String, $type:String=null ):*
		{
			return Bedrock.engine::resourceBundleManager.getBundle( $id, $type );
		}
		public function hasResourceBundle( $id:String ):Boolean
		{
			return Boolean( Bedrock.engine::resourceBundleManager.hasBundle( $id ) );
		}
		public function get resourceBundles():XML
		{
			return Bedrock.engine::resourceBundleManager.data;
		}
		/*
		LocaleManager
		*/
		public function getLocale($id:String):Object
		{
			return Bedrock.engine::localeManager.getLocale( $id );
		}
		public function hasLocale($id:String):Boolean
		{
			return Boolean( Bedrock.engine::localeManager.hasLocale( $id ) );
		}
		public function get currentLocale():String
		{
			return Bedrock.engine::localeManager.currentLocale;
		}
		public function get defaultLocale():String
		{
			return Bedrock.engine::localeManager.defaultLocale;
		}
		public function get locales():Array
		{
			return Bedrock.engine::localeManager.data;
		}
		/*
		LoadController
		*/
		public function startLoad():void
		{
			Bedrock.engine::loadController.load();
		}
		public function pauseLoad():void
		{
			Bedrock.engine::loadController.pause();
		}
		public function resumeLoad():void
		{
			Bedrock.engine::loadController.resume();
		}
		
		public function appendContentToLoad( $content:BedrockContentData ):void
		{
			Bedrock.engine::loadController.appendContent( $content );
		}
		public function appendAssetToLoad( $asset:BedrockAssetData ):void
		{
			Bedrock.engine::loadController.appendAsset( $asset );
		}
		public function appendAssetGroupToLoad( $assetGroup:BedrockAssetGroupData ):void
		{
			Bedrock.engine::loadController.appendAssetGroup( $assetGroup );
		}
		public function set maxLoaderConnections($count:uint):void
		{
			Bedrock.engine::loadController.maxConnections = $count;
		}
		public function get maxLoaderConnections():uint
		{
			return Bedrock.engine::loadController.maxConnections;
		}
		/*
		FrontController
		*/
		public function addCommand($type:String, $command:Class):void
		{
			Bedrock.engine::frontController.addCommand( $type, $command );
		}
		public function removeCommand($type:String, $command:Class):void
		{
			Bedrock.engine::frontController.removeCommand( $type, $command );
		}
		/*
		Stylesheet Manager
		*/
		public function getStylesheet():StyleSheet
		{
			return Bedrock.engine::stylesheetManager.data;
		}
		public function getStyleAsObject($style:String):Object
		{
			return Bedrock.engine::stylesheetManager.getStyleAsObject( $style );
		}
		public function getStyleAsTextFormat( $style:String ):TextFormat
		{
			return Bedrock.engine::stylesheetManager.getStyleAsTextFormat( $style );
		}
		/*
		TrackingManager
		*/
		public function track($serviceID:String, $details:Object):void
		{
			Bedrock.engine::trackingManager.track( $serviceID, $details );
		}
		
		public function addTrackingService( $id:String, $service:ITrackingService ):void
		{
			Bedrock.engine::trackingManager.addService( $id, $service );
		}
		public function getTrackingService($id:String):*
		{
			return Bedrock.engine::trackingManager.getService( $id );
		}
		public function hasTrackingService($id:String):Boolean
		{
			return Boolean( Bedrock.engine::trackingManager.hasService( $id ) );
		}
		/*
		Global Sound
		*/
		public function mute():void
		{
			Bedrock.engine::globalSound.mute();
		}
		public function unmute():void
		{
			Bedrock.engine::globalSound.unmute();
		}
		public function toggleMute():Boolean
		{
			return Boolean( Bedrock.engine::globalSound.toggleMute() );
		}
		public function get isMuted():Boolean
		{
			return Boolean( Bedrock.engine::globalSound.isMuted );
		}
		/*
		TransitionController
		*/
		public function queueInitialLoad():void
		{
			Bedrock.engine::transitionController.prepareInitialLoad();
		}
		public function transition( $detail:* = null ):void
		{
			Bedrock.engine::transitionController.transition( $detail );
		}
		
	}
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}