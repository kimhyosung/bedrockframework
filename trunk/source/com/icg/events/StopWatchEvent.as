package com.icg.events
{
	import com.icg.madagascar.events.GenericEvent;

	public class StopWatchEvent extends GenericEvent
	{
		public static  const START:String = "StopWatchEvent.onStart";
		public static  const STOP:String = "StopWatchEvent.onStop";
		
		public function StopWatchEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}