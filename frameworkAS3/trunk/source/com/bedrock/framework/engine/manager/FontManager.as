package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.core.util.CoreUtil;
	import com.bedrock.framework.engine.api.IFontManager;
	
	import flash.text.Font;
	
	public class FontManager extends BasicWidget implements IFontManager
	{
		/*
		Variable Declarations
		*/
		/*
		Constructor
		*/
		public function FontManager()
		{
		}
				
		public function parseFonts( $content:* ):void
		{
			var arrVariables:Array = CoreUtil.getVariables( $content );
			
			var numLength:int = arrVariables.length;
			for ( var i:int = 0; i < numLength; i++ ) {
				try {
					Font.registerFont( $content[ arrVariables[ i ] ] );
					this.debug("Font Loaded! - " + arrVariables[ i ] );
				} catch ( $error:Error ) {
				}
			}
			
			this.debug( Font.enumerateFonts( false ) );
		}
		/*
		Event Handlers
		*/
		private function onFontLoadComplete($event:LoaderEvent):void 
		{
			
			
		}
		private function onFontLoadError($event:LoaderEvent ):void
		{
			this.warning("Failed to load fonts!");
		}
		/*
		Accessor Definitions
		*/
		public function get loader():VisualLoader
		{
			return null
		}
	}
}