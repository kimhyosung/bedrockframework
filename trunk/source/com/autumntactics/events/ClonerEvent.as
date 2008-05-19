package com.autumntactics.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.autumntactics.bedrock.events.GenericEvent;

	public class ClonerEvent extends GenericEvent
	{
		public static  const INIT:String = "ClonerEvent.onInitialize";
		public static  const CREATE:String = "ClonerEvent.onCreate";
		public static  const REMOVE:String = "ClonerEvent.onRemove";		
		public static  const COMPLETE:String = "ClonerEvent.onComplete";		
		public static  const CLEAR:String = "ClonerEvent.onClear";


		public function ClonerEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}