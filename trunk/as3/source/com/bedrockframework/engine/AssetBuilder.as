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
	
	public class AssetBuilder extends MovieClipWidget
	{
		public function AssetBuilder()
		{
			this.visible = false;
		}
		
		protected function addView( $id:String, $linkage:String ):void
		{
			BedrockEngine.assetManager.addView( $id, $linkage );
		}
		protected function addPreloader( $id:String, $linkage:String ):void
		{
			BedrockEngine.assetManager.addPreloader( $id, $linkage );
		}
		protected function addBitmap( $id:String, $linkage:String ):void
		{
			BedrockEngine.assetManager.addBitmap( $id, $linkage );
		}
		protected function addSound( $id:String, $linkage:String ):void
		{
			BedrockEngine.assetManager.addSound( $id, $linkage );
		}
	}
}