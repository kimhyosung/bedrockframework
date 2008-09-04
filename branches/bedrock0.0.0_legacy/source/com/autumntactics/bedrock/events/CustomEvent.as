package com.autumntactics.bedrock.events
{
	import com.autumntactics.bedrock.events.GenericEvent;

	public class CustomEvent extends GenericEvent
	{
		public function CustomEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
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