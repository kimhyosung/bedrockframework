package com.bedrockframework.plugin.tracking
{
	import com.bedrockframework.core.base.BasicWidget	
	import flash.external.ExternalInterface;

	public class BridgeTrack extends BasBasicWidgetments ITrackingService
	{
		public function BridgeTrack()
		{
		}
		public function track($details:Object):void
		{
			if (ExternalInterface.available) {
				this.status($details);
				ExternalInterface.call("doBridgeTrackMovieEvent", $details.event);
			}
		}
	}
}