package com.icg.events
{
	import com.icg.madagascar.events.GenericEvent;

	public class CallEvent extends GenericEvent
	{		
		public static const RESULT:String = "CallEvent.onResult";
		public static const FAULT:String = "CallEvent.onFault";
		public static const CONNECTION_ERROR:String = "CallEvent.onConnectionError";
		
		public function CallEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
		
	}
}