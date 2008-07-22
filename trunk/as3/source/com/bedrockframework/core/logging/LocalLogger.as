/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@autumntactics.com
 * website: http://www.autumntactics.com/
 * blog: http://blog.autumntactics.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
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