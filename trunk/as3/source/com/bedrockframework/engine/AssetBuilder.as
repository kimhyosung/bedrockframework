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
package com.bedrockframework.engine
{
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.event.BedrockEvent;
	
	public class AssetBuilder extends MovieClipWidget
	{
		public function AssetBuilder()
		{
		}
		
		protected function addView($alias:String, $class:Class):void
		{
			BedrockEngine.assetManager.addView($alias, $class);
		}
		protected function addPreloader($alias:String, $class:Class):void
		{
			BedrockEngine.assetManager.addPreloader($alias, $class);
		}
		protected function addBitmap($alias:String, $class:Class):void
		{
			BedrockEngine.assetManager.addBitmap($alias, $class);
		}
		protected function addSound($alias:String, $class:Class):void
		{
			BedrockEngine.assetManager.addSound($alias, $class);
		}
	}
}