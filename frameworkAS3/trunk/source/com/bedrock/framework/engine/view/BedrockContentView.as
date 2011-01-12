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
package com.bedrock.framework.engine.view
{
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockContentData;
	import com.bedrock.framework.plugin.view.MovieClipView;

	public class BedrockContentView extends MovieClipView
	{
		/*
		Variable Declarations
		*/
		public var data:BedrockContentData;
		public var assets:BedrockAssetGroupData;
		public var bundle:*;
		/*
		Constructor
		*/
		public function BedrockContentView()
		{
			super();
		}
		
	}
	
}