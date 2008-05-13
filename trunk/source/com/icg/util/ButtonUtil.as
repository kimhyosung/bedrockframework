package com.icg.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.icg.madagascar.base.StaticWidget;
	import flash.events.Event;

	public class ButtonUtil extends StaticWidget
	{
		public static function addListeners($clip:DisplayObject,$properties:Object,$buttonMode:Boolean=true,$mouseChildren:Boolean=false):void
		{
			Sprite($clip).buttonMode=$buttonMode;
			Sprite($clip).mouseChildren = $mouseChildren;
			if ($properties) {
				ButtonUtil.addEvent($clip,MouseEvent.MOUSE_DOWN,$properties.down);
				ButtonUtil.addEvent($clip,MouseEvent.MOUSE_UP,$properties.up);
				if ($properties.doubleclick) {
					Sprite($clip).doubleClickEnabled=true;
					ButtonUtil.addEvent($clip,MouseEvent.DOUBLE_CLICK,$properties.doubleclick);
				}
				ButtonUtil.addEvent($clip,MouseEvent.MOUSE_OVER,$properties.over);
				ButtonUtil.addEvent($clip,MouseEvent.MOUSE_OUT,$properties.out);
			}
		}
		public static function removeListeners($clip:DisplayObject,$properties:Object,$buttonMode:Boolean=false, $mouseChildren:Boolean=true):void
		{
			Sprite($clip).buttonMode=$buttonMode;
			Sprite($clip).mouseChildren = $mouseChildren;
			if ($properties) {
				ButtonUtil.removeEvent($clip,MouseEvent.MOUSE_DOWN,$properties.down);
				ButtonUtil.removeEvent($clip,MouseEvent.MOUSE_UP,$properties.up);
				if ($properties.doubleclick) {
					Sprite($clip).doubleClickEnabled=false;
					ButtonUtil.removeEvent($clip,MouseEvent.DOUBLE_CLICK,$properties.doubleclick);
				}
				ButtonUtil.removeEvent($clip,MouseEvent.MOUSE_OVER,$properties.over);
				ButtonUtil.removeEvent($clip,MouseEvent.MOUSE_OUT,$properties.out);
			}
		}
		private static function addEvent($clip:DisplayObject,$event:String,$function:Function=null, $capture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void
		{
			if ($function != null) {
				$clip.addEventListener($event,$function, $capture, $priority, $weak);
			}
		}
		private static function removeEvent($clip:DisplayObject,$event:String,$function:Function=null, $capture:Boolean = false):void
		{
			if ($function != null) {
				$clip.removeEventListener($event,$function,$capture);
			}
		}
		
	}
}