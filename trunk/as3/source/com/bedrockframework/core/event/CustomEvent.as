package com.bedrockframework.core.event
{
	import com.bedrockframework.core.event.GenericEvent;

	public class CustomEvent extends GenericEvent
	{
		public function CustomEvent($type:String, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, this.target, $details, $bubbles, $cancelable);
			this.injectDetails(this.details);
		}
		private function injectDetails($details:Object):void
		{
			try {
				for (var d in $details) {
					this[d] = $details[d];
				}
			} catch($e:Error) {
				
			}
		}
	}
}