package com.bedrockframework.engine
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.controller.IFrontController;
	import com.bedrockframework.engine.api.IAssetManager;
	import com.bedrockframework.engine.api.IConfig;
	import com.bedrockframework.engine.api.IContainerManager;
	import com.bedrockframework.engine.api.ICopyManager;
	import com.bedrockframework.engine.api.IDeepLinkManager;
	import com.bedrockframework.engine.api.ILoadManager;
	import com.bedrockframework.engine.api.IPageManager;
	import com.bedrockframework.engine.api.IPreloaderManager;
	import com.bedrockframework.engine.api.IServiceManager;
	import com.bedrockframework.engine.api.IState;
	import com.bedrockframework.engine.api.IStyleManager;
	import com.bedrockframework.engine.api.ITrackingManager;
	import com.bedrockframework.engine.api.ITransitionManger;

	import com.bedrockframework.engine.bedrock

	public class BedrockEngine extends StandardWidget
	{
		/*
		Variable Definitions
	 	*/
	 	private static var __objInstance:BedrockEngine;
	 	
		bedrock var controller:IFrontController;
		public var assetManager:IAssetManager;
		public var containerManager:IContainerManager;
		public var copyManager:ICopyManager;
		public var deeplinkManager:IDeepLinkManager;
		public var loadManager:ILoadManager;
		bedrock var pageManager:IPageManager;
		bedrock var preloaderManager:IPreloaderManager;		
		public var serviceManager:IServiceManager;
		public var styleManager:IStyleManager;
		public var trackingManager:ITrackingManager;
		bedrock var transitionManager:ITransitionManger;
		
		public var config:IConfig;
		bedrock var state:IState;
		/*
		Constructor
	 	*/
		public function BedrockEngine($enforcer:SingletonEnforcer)
		{
			
		}
		public static function getInstance():BedrockEngine
		{
			if (BedrockEngine.__objInstance == null) {
				BedrockEngine.__objInstance = new BedrockEngine(new SingletonEnforcer());
			}
			return BedrockEngine.__objInstance;
		}
		
	}
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}