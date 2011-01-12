package com.bedrock.framework.engine.event
{
	import com.bedrock.framework.core.event.GenericEvent;

	public class BedrockEvent extends GenericEvent
	{
		public static const TRANSITION_PREPARED:String="BedrockEvent._onTransitionPrepared";
		public static const TRANSITION_COMPLETE:String="BedrockEvent._onTransitionComplete";
		
		public static const CONFIG_LOADED:String="BedrockEvent._onConfigLoaded";
		public static const INITIALIZE_COMPLETE:String="BedrockEvent._onInitializeComplete";

		public static const DEEPLINK_CHANGE:String="BedrockEvent._onDeeplinkChange";
		public static const DEEPLINKING_INITIALIZED:String="BedrockEvent._onDeeplinkingInitialized";

		public static const LOAD_BEGIN:String="BedrockEvent._onLoadBegin";
		public static const LOAD_ERROR:String="BedrockEvent._onLoadError";
		public static const LOAD_COMPLETE:String="BedrockEvent._onLoadComplete";
		public static const LOAD_PROGRESS:String="BedrockEvent._onLoadProgress";

		public static const SHOW_BLOCKER:String="BedrockEvent._onShowBlocker";
		public static const HIDE_BLOCKER:String="BedrockEvent._onHideBlocker";
		
		public function BedrockEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}