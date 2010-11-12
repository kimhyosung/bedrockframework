package com.bedrock.framework.plugin.tracking
{
	import com.bedrock.framework.core.base.BasicWidget;
	
	import flash.external.ExternalInterface;
	import com.bedrock.framework.core.base.BasicWidget	
	public class Omniture extends BasBasicWidgetments ITrackingService
	{
		/*
		Constructor
		*/
		public function Omniture()
		{
			
		}
		/**
		 * Will make the call to javascript using the external interface.
		 * @param $details Generic object will all of the necessary information for the tracking.
		 */		 
		public function track($details:Object):void 
		{
	    	if (ExternalInterface.available && $details) {
	    		this.status($details);
	    		ExternalInterface.call("TMSSite.analytics.sendEvent", $details);	
	    	}	    	 
		}
	}
}