﻿package com.bedrockframework.engine
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.controller.IFrontController;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.api.IAssetManager;
	import com.bedrockframework.engine.api.IConfig;
	import com.bedrockframework.engine.api.IContainerManager;
	import com.bedrockframework.engine.api.IContextMenuManager;
	import com.bedrockframework.engine.api.IDeepLinkManager;
	import com.bedrockframework.engine.api.IFontManager;
	import com.bedrockframework.engine.api.IHistory;
	import com.bedrockframework.engine.api.ILoadManager;
	import com.bedrockframework.engine.api.ILocaleManager;
	import com.bedrockframework.engine.api.IPageManager;
	import com.bedrockframework.engine.api.IPreloaderManager;
	import com.bedrockframework.engine.api.IResourceManager;
	import com.bedrockframework.engine.api.IServiceManager;
	import com.bedrockframework.engine.api.ISoundManager;
	import com.bedrockframework.engine.api.IState;
	import com.bedrockframework.engine.api.IStyleManager;
	import com.bedrockframework.engine.api.ITrackingManager;
	import com.bedrockframework.engine.api.ITransitionManger;

	public class BedrockEngine extends StandardWidget
	{
		/*
		Variable Definitions
	 	*/
		bedrock static var controller:IFrontController;
		public static var assetManager:IAssetManager;
		public static var containerManager:IContainerManager;
		public static var contextMenuManager:IContextMenuManager;
		public static var resourceManager:IResourceManager;
		public static var deeplinkManager:IDeepLinkManager;
		public static var fontManager:IFontManager;
		public static var loadManager:ILoadManager;
		public static var localeManager:ILocaleManager;
		bedrock static var pageManager:IPageManager;
		bedrock static var preloaderManager:IPreloaderManager;		
		public static var serviceManager:IServiceManager;
		public static var soundManager:ISoundManager;
		public static var styleManager:IStyleManager;
		public static var trackingManager:ITrackingManager;
		bedrock static var transitionManager:ITransitionManger;
		
		public static var config:IConfig;
		public static var history:IHistory;
		bedrock static var state:IState;
		
		/*
		Constructor
	 	*/
	 	Logger.log(BedrockEngine, LogLevel.CONSTRUCTOR, "Constructed");
		
	}
}
