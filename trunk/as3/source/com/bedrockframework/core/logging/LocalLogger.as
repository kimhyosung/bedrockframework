package com.bedrockframework.core.logging
{
	import com.bedrockframework.core.logging.ILogger;
	
	

	public class LocalLogger implements ILogger
	{
		
		public function LocalLogger()
		{
						
		}
		
		public function log($target:*, $category:int, $message:String):void
		{
			trace($message);
		}
	}
}