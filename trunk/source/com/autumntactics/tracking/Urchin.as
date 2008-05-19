package com.autumntactics.tracking
{
	import com.autumntactics.bedrock.base.BasicWidget;
	
	import flash.external.ExternalInterface;
	
	import com.autumntactics.tracking.ITrackingService;
	
	public class Urchin extends BasicWidget implements ITrackingService
	{
		public function Urchin()
		{
		}
		public function track(...$arguments:Array):void
		{
			if ($arguments.length == 2) {
				this.status("/" + $arguments[0] + "/" + $arguments[1]);
				if (ExternalInterface.available) {
					ExternalInterface.call("urchinTracker", $arguments[0] + "/" + $arguments[1]);
				}
			}
		}
	}
}