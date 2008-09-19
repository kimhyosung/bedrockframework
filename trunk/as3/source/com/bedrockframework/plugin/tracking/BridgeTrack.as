package com.bedrockframework.plugin.tracking
{
	import com.bedrockframework.core.base.BasicWidget;
	import flash.external.ExternalInterface;

	public class BridgeTrack extends BasicWidget implements ITrackingService
	{
		public function BridgeTrack()
		{
		}
		public function track($details:Object):void
		{
			this.status("/" + $details.page);
			if (ExternalInterface.available) {
				ExternalInterface.call("doBridgeTrackMovieEvent", $details.page);
			}
		}
	}
}