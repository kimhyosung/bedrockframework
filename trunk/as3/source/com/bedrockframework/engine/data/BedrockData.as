package com.bedrockframework.engine.data
{
	public class BedrockData
	{
		
		/*
		Constant Settings
		*/
		public static const AUTO_INTRO_ENABLED:String = "autoIntroEnabled";
		public static const AUTO_DEFAULT_ENABLED:String = "autoDefaultEnabled";
		
		public static const SHELL_PRELOADER_TIME:String = "shellPreloaderTime";
		public static const PAGE_PRELOADER_TIME:String = "pagePreloaderTime";
		
		public static const DEEP_LINKING_ENABLED:String = "deepLinkingEnabled";
		public static const CACHE_PREVENTION_ENABLED:String = "cachePreventionEnabled";
		public static const STYLESHEET_ENABLED:String = "stylesheetEnabled";
		public static const RESOURCE_BUNDLE_ENABLED:String = "resourceBundleEnabled";
		public static const TRACKING_ENABLED:String = "trackingEnabled";
		public static const LOCALES_ENABLED:String = "localesEnabled";
		public static const FONTS_ENABLED:String = "fontsEnabled";
		
		public static const SHARED_ENABLED:String = "sharedEnabled";
		public static const SHARED_SOUNDS_ENABLED:String = "sharedSoundsEnabled";
		
		public static const AUTO_BLOCKER_ENABLED:String = "autoBlockerEnabled";
		
		public static const LOCALE_LIST:String = "localeList";
		public static const LOCALIZED_FILES:String = "localizedFiles";
		public static const LOCALE_DELIMITER:String = "localeDelimiter";
		public static const DEFAULT_LOCALE:String = "defaultLocale";
		public static const CURRENT_LOCALE:String = "currentLocale";
		public static const SYSTEM_LANGUAGE:String = "systemLanguage";
		public static const ENVIRONMENT:String = "environment";
		public static const FORCE_ENVIRONMENT:String = "forceEnvironment";
		public static const CACHE_KEY:String = "cacheKey";
		
		public static const MANUFACTURER:String = "manufacturer";
		
		public static const CONFIG_URL:String = "configURL";
		public static const PATTERNS:String = "patterns";
		
		public static const ROOT:String = "root";
		public static const ROOT_WIDTH:String = "root_width";
		public static const ROOT_HEIGHT:String = "root_height";
		
		public static const LAYOUT:String = "layout";
		public static const BLOCKER_ALPHA:String = "blockerAlpha";
		public static const DEFAULT_PAGE:String = "defaultPage";
		
		public static const URL:String = "url";
		public static const OS:String = "os";
		
		public static  const AUTO_DEEP_LINK:String = "auto";
		public static  const MANUAL_DEEP_LINK:String = "manual";
		
		public static const ERRORS_ENABLED:String = "errorsEnabled";
		public static const LOG_DETAIL_DEPTH:String = "logDetailDepth";
		public static const TRACE_LOG_LEVEL:String = "traceLogLevel";
		public static const EVENT_LOG_LEVEL:String = "eventLogLevel";
		public static const REMOTE_LOG_LEVEL:String = "remoteLogLevel";
		public static const MONSTER_LOG_LEVEL:String = "monsterLogLevel";
		public static const REMOTE_LOG_URL:String = "remoteLogURL";
		
		public static const SHELL_PRELOADER:String= "shellPreloader";
		public static const PAGE_PRELOADER:String= "pagePreloader";
		public static const DEFAULT_PRELOADER:String= "defaultPreloader";
		/*
		Constant File Names
		*/
		public static const CONFIG_FILE_NAME:String = "bedrock_config";
		public static const STYLESHEET_FILENAME:String = "stylesheetFilename";
		public static const FONTS_FILENAME:String = "fontsFilename";
		public static const RESOURCE_BUNDLE_FILENAME:String = "resourceBundleFilename";
		public static const SITE_FILENAME:String = "siteFilename";
		public static const SHARED_FILENAME:String = "sharedFilename";
		/*
		Constant Paths
		*/
		public static const RESOURCE_BUNDLE_PATH:String = "resourceBundlePath";
		public static const FONTS_PATH:String = "fontPath";
		public static const SITE_PATH:String = "sitePath";
		public static const SHARED_PATH:String = "sharedPath";
		public static const SOUND_PATH:String = "soundPath";
		public static const STYLESHEET_PATH:String = "stylesheetPath";
		public static const XML_PATH:String = "xmlPath";
		public static const IMAGE_PATH:String = "imagePath";
		public static const VIDEO_PATH:String = "videoPath";
		public static const SWF_PATH:String = "swfPath";
		/*
		Constant Containers
		*/
		public static const SITE_CONTAINER:String = "site";
		public static const BLOCKER_CONTAINER:String = "blocker";
		public static const PRELOADER_CONTAINER:String = "preloader";
		public static const PAGE_CONTAINER:String = "page";
		public static const SHARED_CONTAINER:String = "shared";
		/*
		Constant Environments
		*/
		public static const DEFAULT:String = "default";
		public static const LOCAL:String = "local";
		public static const DEVELOPMENT:String = "development";
		public static const LOCALHOST:String = "localhost";
		public static const STAGING:String = "staging";
		public static const PRODUCTION:String = "production";
		/*
		Load Priorities
		*/
		public static const SHARED_PRIORITY:int = 101;
		public static const SITE_PRIORITY:int = 102;
		public static const PAGE_PRIORITY:int = 103;
		/*
		Context Menus
		*/
		public static const SHOW_PAGES_IN_CONTEXT_MENU:String = "showPagesInContextMenu";
		public static const SHOW_ABOUT_IN_CONTEXT_MENU:String = "showAboutInContextMenu";
	}
}