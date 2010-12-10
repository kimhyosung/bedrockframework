package com.bedrock.extension.event
{
	import com.bedrock.framework.core.event.GenericEvent;

	public class ExtensionEvent extends GenericEvent
	{
		public static const PROJECT_CREATED:String = "InterfaceEvent.onProjectCreated";
		public static const PROJECT_LOADED:String = "InterfaceEvent.onProjectLoaded";
		public static const PROJECT_GENERATED:String = "InterfaceEvent.onProjectGenerated";
		public static const PROJECT_REFRESH:String = "InterfaceEvent.onProjectRefresh";
		public static const PROJECT_UPDATE:String = "InterfaceEvent.onProjectUpdate";
		public static const SAVE_PROJECT:String = "InterfaceEvent.onSaveProject";
		
		public static const DELETE_CONTENT:String = "InterfaceEvent.onDeleteContent";
		public static const DELETE_CONTENT_CONFIRMED:String = "InterfaceEvent.onDeleteContentConfirmed";
		
		public static const RELOAD_CONFIG:String = "InterfaceEvent.onReloadConfig";
		public static const CONFIG_LOADED:String = "InterfaceEvent.onConfigLoaded";
		
		public static const CREATE_ATTRIBUTE:String = "createAttribute";
		public static const UPDATE_ATTRIBUTE:String = "updateAttribute";
		public static const DELETE_ATTRIBUTE:String = "deleteAttribute";
		
		public static const CREATE_NODE:String = "createNode";
		public static const DESELECT_NODE:String = "deselectNode";
		public static const DELETE_NODE:String = "deleteNode";
		public static const DUPLICATE_NODE:String = "duplicateNode";
		
		public static const CREATE:String = "create";
		public static const CANCEL:String = "cancel";
		public static const CLOSE:String = "close";
		
		public function ExtensionEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
		
	}
}