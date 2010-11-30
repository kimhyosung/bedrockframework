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
		
		public static const CREATE_ATTRIBUTE:String = "createAttribute";
		public static const UPDATE_ATTRIBUTE:String = "updateAttribute";
		public static const DELETE_ATTRIBUTE:String = "deleteAttribute";
		
		public static const DESELECT_NODE:String = "deselectNode";
		public static const DELETE_NODE:String = "deleteNode";
		
		public function ExtensionEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
		
	}
}