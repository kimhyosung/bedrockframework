package com.icg.madagascar.events
{
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.events.ChainLoaderEvent;

	public class MadagascarEvent extends GenericEvent
	{
		public static const SET_QUEUE:String="MadagascarEvent.onSetQueue";
		public static const LOAD_QUEUE:String="MadagascarEvent.onLoadQueue";
		public static const DEFAULT_QUEUE:String="MadagascarEvent.onDefaultQueue";

		public static const DO_DEFAULT:String="MadagascarEvent.onDoDefault";
		public static const DO_CHANGE:String="MadagascarEvent.onDoChange";
		public static const DO_LOAD:String="MadagascarEvent.onDoLoad";
		public static const DO_INITIALIZE:String="MadagascarEvent.onDoInitialize";

		public static const RENDER_VIEW:String="MadagascarEvent.onRenderView";
		public static const RENDER_SITE:String="MadagascarEvent.onRenderSite";
		public static const RENDER_PAGE:String="MadagascarEvent.onRenderPage";
		public static const RENDER_PRELOADER:String="MadagascarEvent.onRenderPreloader";

		public static const CONFIG_LOADED:String="MadagascarEvent.onConfigLoaded";
		public static const MADAGASCAR_BOOT_UP:String="MadagascarEvent.onMadagascarBootUp";
		public static const MADAGASCAR_PROGRESS:String="MadagascarEvent.onMadagascarProgress";
		public static const MADAGASCAR_COMPLETE:String="MadagascarEvent.onMadagascarComplete";

		public static const URL_CHANGE:String="MadagascarEvent.onURLChange";

		public static const LOAD_BEGIN:String="MadagascarEvent.onLoadBegin";
		public static const LOAD_ERROR:String="MadagascarEvent.onLoadError";
		public static const LOAD_COMPLETE:String="MadagascarEvent.onLoadComplete";
		public static const LOAD_CLOSE:String="MadagascarEvent.onLoadClose";
		public static const LOAD_PROGRESS:String="MadagascarEvent.onLoadProgress";
		public static const LOAD_NEXT:String="MadagascarEvent.onLoadNext";
		public static const LOAD_RESET:String="MadagascarEvent.onLoadReset";

		public static const FILE_ADDED:String="MadagascarEvent.onFileAdded";
		public static const FILE_OPEN:String="MadagascarEvent.onFileOpen";
		public static const FILE_PROGRESS:String="MadagascarEvent.onFileProgress";
		public static const FILE_COMPLETE:String="MadagascarEvent.onFileComplete";
		public static const FILE_INIT:String="MadagascarEvent.onFileInitialize";
		public static const FILE_UNLOAD:String="MadagascarEvent.onFileUnload";
		public static const FILE_HTTP_STATUS:String="MadagascarEvent.onFileStatus";
		public static const FILE_ERROR:String="MadagascarEvent.onFileError";
		public static const FILE_SECURITY_ERROR:String="MadagascarEvent.onFileSecurityError";

		public static const INITIALIZE_COMPLETE:String="MadagascarEvent.onInitializeComplete";
		public static const INTRO_COMPLETE:String="MadagascarEvent.onIntroComplete";
		public static const OUTRO_COMPLETE:String="MadagascarEvent.onOutroComplete";

		public static const SHOW_BLOCKER:String="MadagascarEvent.onShowBlocker";
		public static const HIDE_BLOCKER:String="MadagascarEvent.onHideBlocker";
		
		public static const LOAD_COPY:String="MadagascarEvent.onLoadCopy";
		public static const COPY_LOADED:String="MadagascarEvent.onCopyLoaded";

		public function MadagascarEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}