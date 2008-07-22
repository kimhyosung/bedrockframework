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
package com.bedrockframework.engine.tracking
{
	public interface ITrackingService
	{
		/**
		 * Will make the necessary calls to send a tracking tag.
		 * @param $details Generic object will all of the necessary information for the tracking.
		 */
		function track($details:Object):void
	}
}