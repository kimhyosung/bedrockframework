package com.autumntactics.tracking
{
	import flash.external.ExternalInterface;
	
	public class Urchin extends TrackingService
	{
		public function Urchin()
		{
		}
		override public function track($section:String, $item:String):void
		{
			this.status("/" + $section + "/" + $item);
			if (ExternalInterface.available) {
				ExternalInterface.call("urchinTracker", $section + "/" + $item);
			}
		}
	}
}