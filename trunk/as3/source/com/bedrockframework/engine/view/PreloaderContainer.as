package com.bedrockframework.engine.view
{
	import com.bedrockframework.core.base.SpriteWidget;
	
	import flash.display.DisplayObject;

	public class PreloaderContainer extends SpriteWidget
	{
		public function PreloaderContainer($silenceConstruction:Boolean=false)
		{
			
		}
		
		override public function addChild($child:DisplayObject):DisplayObject
		{
			if (this.numChildren != 0) {
				throw new Error("Cannot add more than one preloader!");
			} else {
				return super.addChild($child);
			}
		} 
		
		public function get preloader():*
		{
			return this.getChildAt(0);
		}
	}
}