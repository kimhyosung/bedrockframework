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
			this.visible = false;
			this.loaderInfo.applicationDomain
		}
		
		protected function addView( $alias:String ):void
		{
			BedrockEngine.assetManager.addView( $alias );
		}
		protected function addPreloader( $alias:String ):void
		{
			BedrockEngine.assetManager.addPreloader( $alias );
		}
		protected function addBitmap( $alias:String ):void
		{
			BedrockEngine.assetManager.addBitmap( $alias );
		}
		protected function addSound( $alias:String ):void
		{
			BedrockEngine.assetManager.addSound( $alias );
		}
	}
}