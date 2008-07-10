package com.bedrockframework.plugin.tracking
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.engine.tracking.ITrackingService;
	
	import flash.external.ExternalInterface;
	
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