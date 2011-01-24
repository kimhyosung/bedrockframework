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
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.plugin.view.MovieClipView;
	import com.bedrock.framework.plugin.view.ViewEvent;

	public class BedrockModuleView extends MovieClipView
	{
		/*
		Variable Declarations
		*/
		public var details:BedrockModuleData;
		public var assets:BedrockAssetGroupData;
		public var bundle:*;
		/*
		Constructor
		*/
		public function BedrockModuleView()
		{
			super();
		}
		
	}
	
}