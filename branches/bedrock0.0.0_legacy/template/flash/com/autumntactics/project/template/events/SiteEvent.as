package com.builtonbedrock.project.template.events
{
	import com.builtonbedrock.bedrock.events.GenericEvent;
	
	public class SiteEvent extends GenericEvent
	{
		public static const DATA_REQUEST:String="SiteEvent.onDataRequest";
		public static const DATA_RESPONSE:String="SiteEvent.onDataResponse";
		/*
		Constructor
		*/
		public function SiteEvent($type:String,$origin:Object,$details:Object=null, $bubbles:Boolean = false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}