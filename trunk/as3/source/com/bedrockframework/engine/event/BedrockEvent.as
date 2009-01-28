package com.bedrockframework.engine.event
{
	import com.bedrockframework.core.event.GenericEvent;

	public class BedrockEvent extends GenericEvent
	{
		public static const SET_QUEUE:String="BedrockEvent.onSetQueue";
		public static const LOAD_QUEUE:String="BedrockEvent.onLoadQueue";
		public static const DEFAULT_QUEUE:String="BedrockEvent.onDefaultQueue";

		public static const DO_DEFAULT:String="BedrockEvent.onDoDefault";
		public static const DO_CHANGE:String="BedrockEvent.onDoChange";
		
		public static const DO_LOAD:String="BedrockEvent.onDoLoad";
		public static const DO_INITIALIZE:String="BedrockEvent.onDoInitialize";

		public static const RENDER_VIEW:String="BedrockEvent.onRenderView";
		public static const RENDER_SITE:String="BedrockEvent.onRenderSite";
		public static const RENDER_PAGE:String="BedrockEvent.onRenderPage";
		public static const RENDER_PRELOADER:String="BedrockEvent.onRenderPreloader";

		public static const CONFIG_LOADED:String="BedrockEvent.onConfigLoaded";
		public static const BEDROCK_BOOT_UP:String="BedrockEvent.onBedrockBootUp";
		public static const BEDROCK_PROGRESS:String="BedrockEvent.onBedrockProgress";
		public static const BEDROCK_COMPLETE:String="BedrockEvent.onBedrockComplete";

		public static const URL_CHANGE:String="BedrockEvent.onURLChange";
		public static const DEEP_LINK_INITIALIZE:String="BedrockEvent.onDeepLinkInitialize";

		public static const LOAD_BEGIN:String="BedrockEvent.onLoadBegin";
		public static const LOAD_ERROR:String="BedrockEvent.onLoadError";
		public static const LOAD_COMPLETE:String="BedrockEvent.onLoadComplete";
		public static const LOAD_CLOSE:String="BedrockEvent.onLoadClose";
		public static const LOAD_PROGRESS:String="BedrockEvent.onLoadProgress";
		public static const LOAD_NEXT:String="BedrockEvent.onLoadNext";
		public static const LOAD_RESET:String="BedrockEvent.onLoadReset";

		public static const FILE_ADDED:String="BedrockEvent.onFileAdded";
		public static const FILE_OPEN:String="BedrockEvent.onFileOpen";
		public static const FILE_PROGRESS:String="BedrockEvent.onFileProgress";
		public static const FILE_COMPLETE:String="BedrockEvent.onFileComplete";
		public static const FILE_INIT:String="BedrockEvent.onFileInitialize";
		public static const FILE_UNLOAD:String="BedrockEvent.onFileUnload";
		public static const FILE_HTTP_STATUS:String="BedrockEvent.onFileStatus";
		public static const FILE_ERROR:String="BedrockEvent.onFileError";
		public static const FILE_SECURITY_ERROR:String="BedrockEvent.onFileSecurityError";

		public static const INITIALIZE_COMPLETE:String="BedrockEvent.onInitializeComplete";
		public static const INTRO_COMPLETE:String="BedrockEvent.onIntroComplete";
		public static const OUTRO_COMPLETE:String="BedrockEvent.onOutroComplete";
		
		public static const PRELOADER_INITIALIZE_COMPLETE:String="BedrockEvent.onPreloaderInitializeComplete";
		public static const PRELOADER_INTRO_COMPLETE:String="BedrockEvent.onPreloaderIntroComplete";
		public static const PRELOADER_OUTRO_COMPLETE:String="BedrockEvent.onPreloaderOutroComplete";

		public static const SHOW_BLOCKER:String="BedrockEvent.onShowBlocker";
		public static const HIDE_BLOCKER:String="BedrockEvent.onHideBlocker";
		
		public static const LOAD_COPY:String="BedrockEvent.onLoadCopy";
		public static const COPY_LOADED:String="BedrockEvent.onCopyLoaded";
		public static const COPY_ERROR:String="BedrockEvent.onCopyError";
		
		public static const ADD_SOUND:String = "BedrockEvent.onAddSound";
		public static const PLAY_SOUND:String = "BedrockEvent.onPlaySound";
		public static const STOP_SOUND:String = "BedrockEvent.onStopSound";
		public static const ADJUST_SOUND_PAN:String = "BedrockEvent.onAdjustSoundPan";
		public static const ADJUST_SOUND_VOLUME:String = "BedrockEvent.onAdjustSoundVolume";
		public static const FADE_IN_SOUND:String = "BedrockEvent.onFadeInSound";
		public static const FADE_OUT_SOUND:String = "BedrockEvent.onFadeOutSound";		
		public static const MUTE:String = "BedrockEvent.onMute";
		public static const UNMUTE:String = "BedrockEvent.onUnmute";
		public static const ADJUST_GLOBAL_PAN:String = "BedrockEvent.onAdjustGlobalPan";
		public static const ADJUST_GLOBAL_VOLUME:String = "BedrockEvent.onAdjustGlobalVolume";
		
		public static const SHARED_ASSETS_LOADED:String = "BedrockEvent.onSharedAssetsLoaded";

		public function BedrockEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}