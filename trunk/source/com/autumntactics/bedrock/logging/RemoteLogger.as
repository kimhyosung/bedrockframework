package com.autumntactics.bedrock.logging
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class RemoteLogger implements ILogger
	{
		
		public var connection:URLLoader;
		public var request:URLRequest;
		
		public function RemoteLogger()
		{
			this.connection = new URLLoader;
			this.request = new URLRequest("http://localhost/bedrock/dynamic_fixed.html");
		}

		public function log($target:*, $category:int, $message:String):void
		{
			if (this.request.url != null) {
				this.connection.load(this.request);
			}
		}
	
	}
}