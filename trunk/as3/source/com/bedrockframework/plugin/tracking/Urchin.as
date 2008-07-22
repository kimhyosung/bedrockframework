package com.bedrockframework.plugin.tracking
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.engine.tracking.ITrackingService;
	
	import flash.external.ExternalInterface;
	
	public class Urchin extends BasicWidget implements ITrackingService
	{
		/*
		Constructor
		*/
		public function Urchin()
		{
		}
		/**
		 * Will make the call to javascript using the external interface.
		 * @param $details Generic object will all of the necessary information for the tracking.
		 */
		public function track($details:Object):void
		{
			if (ExternalInterface.available) {
				this.status("/" + $details.item + "/" + $details.title);
				ExternalInterface.call("urchinTracker", $details.item + "/" + $details.title);
			}		
		}
	}
}