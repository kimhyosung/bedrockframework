package com.autumntactics.tracking
{
	import com.autumntactics.bedrock.base.StandardWidget;

	public class TrackingService extends StandardWidget
	{
		public function track():void
		{
			throw new Error("Abstract method 'track' must be overridden!")
		}
	}
	
}