package com.bedrock.framework.engine
{
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.core.controller.IFrontController;
	import com.bedrock.framework.core.logging.Logger;
	import com.bedrock.framework.engine.api.*;

	public class BedrockEngine extends StandardBase
	{
		/*
		Variable Definitions
	 	*/
		public static var available:Boolean = false;
		
		bedrock static var transitionController:ITransitionController;
		bedrock static var resourceController:IResourceController;
		public static var frontController:IFrontController;
		
		public static var libraryManager:ILibraryManager;
		public static var containerManager:IContainerManager;
		public static var contentManager:IContentManager;
		public static var contextMenuManager:IContextMenuManager;
		public static var dataBundleManager:IDataBundleManager;
		public static var deeplinkingManager:IDeeplinkingManager;
		public static var fontManager:IFontManager;
		public static var loadManager:ILoadManager;
		public static var localeManager:ILocaleManager;
		bedrock static var preloadManager:IPreloadManager;		
		public static var stylesheetManager:IStylesheetManager;
		public static var trackingManager:ITrackingManager;
		
		public static var resourceDelegate:IResourceDelegate;
		
		public static var config:IConfig;
		public static var history:IHistory;
		/*
		Constructor
	 	*/
	 	Logger.status( "Initialized", BedrockEngine );
		
	}
}
