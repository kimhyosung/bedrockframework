package com.builtonbedrock.bedrock.logging
{
	import com.builtonbedrock.bedrock.logging.ILogger;
	
	

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