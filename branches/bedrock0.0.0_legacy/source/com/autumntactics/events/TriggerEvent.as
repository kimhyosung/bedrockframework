package com.builtonbedrock.events
{
	import com.builtonbedrock.bedrock.events.GenericEvent;

	public class TriggerEvent extends GenericEvent
	{
		public static  const START:String = "TriggerEvent.onStart";
		public static  const STOP:String = "TriggerEvent.onStop";
		public static  const TRIGGER:String = "TriggerEvent.onTrigger";
		
		public function TriggerEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}