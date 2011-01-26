package com.bedrock.framework.engine
{
	import com.bedrock.framework.core.controller.IFrontController;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.core.logging.BedrockLogger;
	import com.bedrock.framework.engine.api.*;
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.plugin.sound.IGlobalSound;
	import com.bedrock.framework.plugin.tracking.ITrackingService;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public class Bedrock
	{
		/*
		Variable Definitions
	 	*/
	 	/**
		 * @private
		 */
		engine static var data:BedrockData;
		/**
		 * @private
		 */
		engine static var logger:BedrockLogger;
		/**
		 * @private
		 */
		engine static var dispatcher:BedrockDispatcher;
		/**
		 * @private
		 */
		engine static var globalSound:IGlobalSound;
		/**
		 * @private
		 */
		engine static var transitionController:ITransitionController;
		/**
		 * @private
		 */
		engine static var specialAssetController:ISpecialAssetController;
		/**
		 * @private
		 */
		engine static var frontController:IFrontController;
		/**
		 * @private
		 */
		engine static var loadController:ILoadController;
		/**
		 * @private
		 */		
		engine static var assetManager:IAssetManager;
		/**
		 * @private
		 */
		engine static var containerManager:IContainerManager;
		/**
		 * @private
		 */
		engine static var moduleManager:IModuleManager;
		/**
		 * @private
		 */
		engine static var contextMenuManager:IContextMenuManager;
		/**
		 * @private
		 */
		engine static var resourceBundleManager:IResourceBundleManager;
		/**
		 * @private
		 */
		engine static var deeplinkingManager:IDeeplinkingManager;
		/**
		 * @private
		 */
		engine static var libraryManager:ILibraryManager;
		/**
		 * @private
		 */
		engine static var localeManager:ILocaleManager;
		/**
		 * @private
		 */
		engine static var preloadManager:IPreloadManager;
		/**
		 * @private
		 */		
		engine static var stylesheetManager:IStylesheetManager;
		/**
		 * @private
		 */
		engine static var trackingManager:ITrackingManager;
		/**
		 * @private
		 */
		engine static var configModel:IConfigModel;
		/**
		 * @private
		 */
		engine static var historyModel:IHistoryModel;
		
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
			
			Bedrock.engine::data = BedrockData.instance;
			Bedrock.engine::logger = BedrockLogger.instance;
			Bedrock.engine::dispatcher = BedrockDispatcher.instance;
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
		public static function get library():ILibraryManager
		{
			if ( !Bedrock.__instance ) Bedrock.__initialize();
			return Bedrock.engine::libraryManager;
		}
		public static function get deeplinking():IDeeplinkingManager
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
		public function filterAssets( $field:String, $value:* ):Array
		{
			return Bedrock.engine::assetManager.filterAssets( $field, $value );
		}
		public function addAsset( $asset:BedrockAssetData ):void
		{
			Bedrock.engine::assetManager.addAsset( $asset );
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
		public function filterAssetGroups( $field:String, $value:* ):Array
		{
			return Bedrock.engine::assetManager.filterGroups( $field, $value );
		}
		/*
		ModuleManager
		*/
		public function addModule($data:BedrockModuleData):void
		{
			Bedrock.engine::moduleManager.addModule( $data );
		}
		public function addAssetToModule( $moduleID:String, $asset:BedrockAssetData ):void
		{
			Bedrock.engine::moduleManager.addAssetToModule( $moduleID, $asset );
		}
		public function getModule($id:String):BedrockModuleData
		{
			return Bedrock.engine::moduleManager.getModule( $id );
		}
		public function hasModule($id:String):Boolean
		{
			return Boolean( Bedrock.engine::moduleManager.hasModule( $id ) );
		}
		public function getIndexedModules():Array
		{
			return this.filterModules( BedrockData.INDEXED, true );
		}
		public function filterModules( $field:String, $value:* ):Array
		{
			return Bedrock.engine::moduleManager.filterModules( $field, $value );
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
		
		public function appendModuleToLoad( $module:BedrockModuleData ):void
		{
			Bedrock.engine::loadController.appendModule( $module );
		}
		public function appendAssetToLoad( $asset:BedrockAssetData ):void
		{
			Bedrock.engine::assetManager.addAsset( $asset );
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
		public function get stylesheet():StyleSheet
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
		public function prepareInitialLoad():void
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