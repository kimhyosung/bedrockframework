package com.bedrock.framework.plugin.keyCapture
{
	import com.bedrock.framework.core.event.GenericEvent;

	public class KeyCaptureEvent extends GenericEvent
	{
		public static const PHRASE_MATCHED:String = "KeyboardCaptureEvent";
		
		public function KeyCaptureEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
		
	}
}