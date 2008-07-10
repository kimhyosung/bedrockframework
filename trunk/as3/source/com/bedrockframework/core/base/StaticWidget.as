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
package com.bedrockframework.core.base
{
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	
	public class StaticWidget
	{
		public function StaticWidget()
		{
			Logger.log(this, LogLevel.ERROR, "Cannot Instantiate static class!");
		}
	}
}