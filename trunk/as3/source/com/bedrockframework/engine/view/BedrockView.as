/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@builtonbedrock.com
 * website: http://www.builtonbedrock.com/
 * blog: http://blog.builtonbedrock.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.engine.view
{
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.view.MovieClipView;

	public class BedrockView extends MovieClipView
	{
		/*
		Variable Declarations
		*/
		public var data:Object;
		public var assets:HashMap;
		/*
		Constructor
		*/
		public function BedrockView()
		{
			super();
		}
		
	}
	
}