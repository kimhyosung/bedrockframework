package com.builtonbedrock.events
{
	import com.builtonbedrock.bedrock.events.GenericEvent;

	public class CallEvent extends GenericEvent
	{		
		public static const RESULT:String = "CallEvent.onResult";
		public static const FAULT:String = "CallEvent.onFault";
		
		public function CallEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
		
	}
}