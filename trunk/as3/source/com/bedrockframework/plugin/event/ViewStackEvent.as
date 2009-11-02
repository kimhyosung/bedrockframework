package com.bedrockframework.plugin.event
{
	import com.bedrockframework.core.event.GenericEvent;

	public class ViewStackEvent extends GenericEvent
	{		
		public static  const INITIALIZE_COMPLETE:String = "ViewStackEvent.onNext";
		public static  const INTRO_COMPLETE:String = "ViewStackEvent.onNext";
		public static  const OUTRO_COMPLETE:String = "ViewStackEvent.onPrevious";
	
		public static const SHOW:String = "ViewStackEvent.onShow";
		public static const NEXT:String = "ViewStackEvent.onNext";
		public static const PREVIOUS:String = "ViewStackEvent.onPrevious";
		public static const BEGINNING:String =  "ViewStackEvent.onBeginning";
		public static const ENDING:String =  "ViewStackEvent.onEnding";
		
		public function ViewStackEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}