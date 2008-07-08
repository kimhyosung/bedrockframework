package com.autumntactics.util
{
	import com.autumntactics.bedrock.base.StaticWidget;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	public class DisplayObjectUtil extends StaticWidget
	{
		/**
	     * duplicateDisplayObject
	     * creates a duplicate of the DisplayObject passed.
	     * similar to duplicateMovieClip in AVM1
	     * @param target the display object to duplicate
	     * @param autoAdd if true, adds the duplicate to the display list
	     * in which target was located
	     * @return a duplicate instance of target
	     */
	    public static  function duplicate($target:DisplayObject, $parent:DisplayObjectContainer = null, $autoAdd:Boolean = false):*
	    {
	        
	        var objTarget:DisplayObject = $target;
	        var objParent:DisplayObjectContainer = $parent || objTarget.parent;
	        var clsTargetConstructor:Class = Object(objTarget).constructor;
	        
	        // create duplicate
	        var objDuplicate:* = new clsTargetConstructor();
	       
	        // Duplicate properties
	        objDuplicate.transform = objTarget.transform;
	        objDuplicate.filters = objTarget.filters;
	        objDuplicate.cacheAsBitmap = objTarget.cacheAsBitmap;
	        objDuplicate.opaqueBackground = objTarget.opaqueBackground;
	        
	        if (objTarget.scale9Grid) {
	            var objRect:Rectangle = objTarget.scale9Grid;
	            // Flash 9 bug where returned scale9Grid is 20x larger than assigned
	            objRect.x /= 20, objRect.y /= 20, objRect.width /= 20, objRect.height /= 20;
	            objDuplicate.scale9Grid = objRect;
	        }
	       
	        // add to target parent's display list
	        // if autoAdd was provided as true
	        if ($autoAdd) {
	            objParent.addChild(objDuplicate);
	        }
	        return objDuplicate;
	    }
		
		public static function getScaleRectangle($target:DisplayObject, $gutter:uint):Rectangle
		{
			return new Rectangle($gutter, $gutter, $target.width-($gutter *2), $target.height-($gutter *2))
		}
	}
}