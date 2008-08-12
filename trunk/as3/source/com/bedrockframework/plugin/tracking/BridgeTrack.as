package com.sapient.project.keybank.tracking
{
	
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.engine.tracking.ITrackingService;
	
	import flash.external.ExternalInterface;

	public class BridgeTrack extends BasicWidget implements ITrackingService
	{
		public function BridgeTrack()
		{
		}
		public function track($details:Object):void
		{
			this.status("/" + $details.section);
			if (ExternalInterface.available) {
				ExternalInterface.call("doBridgeTrackMovieEvent", $details.section);
			}
		}
	}
}