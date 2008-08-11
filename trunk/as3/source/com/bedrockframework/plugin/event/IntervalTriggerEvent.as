package com.bedrockframework.plugin.event
{
	import com.bedrockframework.core.event.GenericEvent;

	public class IntervalTriggerEvent extends GenericEvent
	{
		public static  const START:String = "TriggerEvent.onStart";
		public static  const STOP:String = "TriggerEvent.onStop";
		public static  const TRIGGER:String = "TriggerEvent.onTrigger";
		
		public function IntervalTriggerEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}