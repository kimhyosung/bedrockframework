package com.bedrock.framework.engine.data
{
	import com.bedrock.framework.engine.BedrockEngine;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import com.bedrock.framework.engine.bedrock;
	
	dynamic public class BedrockData extends Proxy
	{
		/*
		Player Values
		*/
		public static const MANUFACTURER:String = "manufacturer";
		public static const SYSTEM_LANGUAGE:String = "systemLanguage";
		public static const URL:String = "url";
		public static const OS:String = "os";
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
		Constant Settings
		*/
		public static const CONFIG_URL:String = "configURL";
		
		public static const BLOCKER:String = "blocker";
		/*
		Locale Settings
		*/
		public static const ENVIRONMENT:String = "environment";
		public static const FORCE_ENVIRONMENT:String = "forceEnvironment";
		
		public static const SHELL:String = "shell";
		public static const FONTS:String = "fonts";
		public static const STYLESHEET:String = "stylesheet";
		public static const DATA_BUNDLE:String = "dataBundle";
		public static const LIBRARY:String = "library";
		/*
		Logger Settings
		*/
		public static const INITIAL_PRELOADER:String= "initialPreloader";
		public static const DEFAULT_PRELOADER:String= "defaultPreloader";
		/*
		Constant File Names
		*/
		public static const CONFIG_FILENAME:String = "bedrock_config";
		
		/*
		Constant Containers
		*/
		public static const NONE:String = "none";
		public static const ROOT:String = "root";
		public static const SITE:String = "site";
		public static const OVERLAY:String = "overlay";
		public static const PRELOADER:String = "preloader";
		/*
		Context Menus
		*/
		public static const INDEXED:String = "indexed";
		public static const PRIORITY:String = "priority";
		public static const INITIAL_TRANSITION:String = "initialTransition";
		public static const INITIAL_LOAD:String = "initialLoad";
		public static const AUTO_DISPOSE:String = "autoDispose";
		public static const AUTO_DISPOSE_ASSETS:String = "autoDisposeAssets";
		
		/*
		Variable Declarations
		*/
		private static var __instance:BedrockData;
		/*
		Constructor
		*/
		public function BedrockData( $singletonEnforcer:SingletonEnforcer )
		{
		}
		public static function getInstance():BedrockData
		{
			if ( BedrockData.__instance == null ) {
				BedrockData.__instance = new BedrockData( new SingletonEnforcer );
			}
			return BedrockData.__instance;
		}
		
		
		flash_proxy override function callProperty( $name:*, ...$arguments:Array ):*
		{
			return null;
		}


		flash_proxy override function getProperty( $name:* ):*
		{
			var name:String = $name.toString();
			if ( BedrockEngine.bedrock::config.hasSettingValue( name ) ) return BedrockEngine.bedrock::config.getSettingValue( name );
			if ( BedrockEngine.bedrock::config.hasPathValue( name ) ) return BedrockEngine.bedrock::config.getPathValue( name );
			if ( BedrockEngine.bedrock::config.hasVariableValue( name ) ) return BedrockEngine.bedrock::config.hasVariableValue( name );
			return null;
		}


		flash_proxy override function setProperty( $name:*, $value:* ):void
		{
			var name:String = $name.toString();
			if ( BedrockEngine.bedrock::config.hasSettingValue( name ) ) BedrockEngine.bedrock::config.saveSettingValue( name, $value );
			if ( BedrockEngine.bedrock::config.hasPathValue( name ) ) BedrockEngine.bedrock::config.savePathValue( name, $value );
			if ( BedrockEngine.bedrock::config.hasVariableValue( name ) || ( !BedrockEngine.bedrock::config.hasSettingValue( name ) && !BedrockEngine.bedrock::config.hasPathValue( name ) ) ) {
				BedrockEngine.bedrock::config.saveVariableValue( name, $value );
			}
		}


		flash_proxy override function deleteProperty( $name:* ):Boolean
		{
			return false;
		}
	}
	
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}