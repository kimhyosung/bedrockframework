package com.bedrockframework.plugin.event
{
	import com.bedrockframework.core.event.GenericEvent;

	public class TimeoutTriggerEvent extends GenericEvent
	{
		public static  const START:String = "DelayEvent.onStart";
		public static  const STOP:String = "DelayEvent.onStop";
		public static  const TRIGGER:String = "DelayEvent.onTrigger";
		
		public function TimeoutTriggerEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}