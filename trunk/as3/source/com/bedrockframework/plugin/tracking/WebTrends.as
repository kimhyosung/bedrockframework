package com.bedrockframework.plugin.tracking
{
	import com.asual.swfaddress.SWFAddress;
	import com.bedrockframework.core.base.BasicWidget;
	
	import flash.external.ExternalInterface;

	public class WebTrends extends BasicWidget implements ITrackingService
	{
		/*
		Constructor
		*/
		public function WebTrends()
		{
		}
		/**
		 * Will make the call to javascript using the external interface.
		 * @param $details Generic object will all of the necessary information for the tracking.
		 */
		public function track($details:Object):void
		{
			if (ExternalInterface.available) {
				this.status($details.page + " : " + $details.item + " : " + $details.title);
				ExternalInterface.call("dcsMultiTrack", "DCS.dcsuri", $details.page + "/" + $details.item, "WT.ti", $details.title);
			}
		}
	}
}