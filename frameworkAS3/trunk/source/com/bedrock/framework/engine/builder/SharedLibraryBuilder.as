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
package com.bedrock.framework.engine.builder
{
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.*;
	
	import flash.display.MovieClip;

	public class SharedLibraryBuilder extends MovieClip
	{
		public function SharedLibraryBuilder()
		{
			this.visible = false;
		}
		
		protected function registerView( $id:String, $linkage:String ):void
		{
			Bedrock.engine::libraryManager.registerView( $id, $linkage );
		}
		protected function registerPreloader( $id:String, $linkage:String ):void
		{
			Bedrock.engine::libraryManager.registerPreloader( $id, $linkage );
		}
		protected function registerBitmap( $id:String, $linkage:String ):void
		{
			Bedrock.engine::libraryManager.registerBitmap( $id, $linkage );
		}
		protected function registerSound( $id:String, $linkage:String ):void
		{
			Bedrock.engine::libraryManager.registerSound( $id, $linkage );
		}
		
	}
}