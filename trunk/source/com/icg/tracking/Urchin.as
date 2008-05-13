package com.icg.tracking
{
	import flash.external.ExternalInterface;
	
	public class Urchin extends TrackingService
	{
		public function Urchin()
		{
		}
		public function track($section:String, $item:String):void
		{
			this.output("/" + $section + "/" + $item);
			if (ExternalInterface.available) {
				ExternalInterface.call("urchinTracker", $section + "/" + $item);
			}
		}
	}
}