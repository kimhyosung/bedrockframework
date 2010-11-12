
package com.bedrock.framework.engine
{
	import com.bedrock.framework.core.base.MovieClipBase;

	public class AssetsBuilder extends MovieClipBase
	{
		public function AssetsBuilder()
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