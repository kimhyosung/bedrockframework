package com.icg.madagascar.events
{
	import flash.events.Event;
	import com.icg.madagascar.events.GenericEvent;
	public dynamic class ViewEvent extends GenericEvent
	{
		public static const INITIALIZE_COMPLETE:String="ViewEvent.onInitializeComplete";
		public static const INTRO_COMPLETE:String="ViewEvent.onIntroComplete";
		public static const OUTRO_COMPLETE:String="ViewEvent.onOutroComplete";
		public static const CHANGE:String = "ViewEvent.onChange"

		public function ViewEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	
	}
}