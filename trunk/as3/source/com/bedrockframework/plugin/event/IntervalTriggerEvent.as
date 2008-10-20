package com.bedrockframework.plugin.event
{
	import com.bedrockframework.core.event.GenericEvent;

	public class IntervalTriggerEvent extends GenericEvent
	{
		public static  const START:String = "IntervalTriggerEvent.onStart";
		public static  const STOP:String = "IntervalTriggerEvent.onStop";
		public static  const TRIGGER:String = "IntervalTriggerEvent.onTrigger";
		
		public function IntervalTriggerEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}