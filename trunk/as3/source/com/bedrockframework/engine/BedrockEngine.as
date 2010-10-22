package com.bedrockframework.engine
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.core.controller.IFrontController;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.api.*;

	public class BedrockEngine extends BasicWidget
	{
		/*
		Variable Definitions
	 	*/
		public static var available:Boolean = false;
		
		bedrock static var controller:IFrontController;
		public static var assetManager:IAssetManager;
		public static var containerManager:IContainerManager;
		public static var contextMenuManager:IContextMenuManager;
		public static var resourceManager:IResourceBundleManager;
		public static var deeplinkManager:IDeeplinkManager;
		public static var fontManager:IFontManager;
		public static var loadManager:ILoadManager;
		public static var localeManager:ILocaleManager;
		bedrock static var pageManager:IPageManager;
		public static var pathManager:IPathManager;
		bedrock static var preloaderManager:IPreloaderManager;		
		public static var soundManager:ISoundManager;
		public static var stylesheetManager:IStylesheetManager;
		public static var trackingManager:ITrackingManager;
		bedrock static var transitionManager:ITransitionManger;
		
		public static var config:IConfig;
		public static var history:IHistory;
		bedrock static var state:IState;
		
		/*
		Constructor
	 	*/
	 	Logger.status( "Initialized", BedrockEngine );
		
	}
}
