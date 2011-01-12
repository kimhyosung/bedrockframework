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
	
	import flash.text.Font;
	import flash.display.MovieClip;

	public class SharedFontsBuilder extends MovieClip
	{
		public function SharedFontsBuilder()
		{
			super();
		}
		
		protected function registerFont( $font:Class ):void
		{
			Font.registerFont( $font );
		}
	}
}