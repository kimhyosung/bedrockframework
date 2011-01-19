package com.bedrock.framework.plugin.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class ButtonUtil
	{
		public static function addListeners( $clip:DisplayObject, $handlers:Object, $buttonMode:Boolean=true, $mouseChildren:Boolean=false):void
		{
			Sprite($clip).buttonMode=$buttonMode;
			Sprite($clip).mouseChildren = $mouseChildren;
			if ($handlers) {
				ButtonUtil.__addEvent($clip,MouseEvent.MOUSE_DOWN,$handlers.down);
				ButtonUtil.__addEvent($clip,MouseEvent.MOUSE_UP,$handlers.up);
				if ($handlers.doubleclick) {
					Sprite($clip).doubleClickEnabled=true;
					ButtonUtil.__addEvent($clip,MouseEvent.DOUBLE_CLICK,$handlers.doubleclick);
				}
				ButtonUtil.__addEvent($clip,MouseEvent.MOUSE_OVER,$handlers.over);
				ButtonUtil.__addEvent($clip,MouseEvent.MOUSE_OUT,$handlers.out);
			}
		}
		public static function removeListeners( $clip:DisplayObject, $handlers:Object, $buttonMode:Boolean=false, $mouseChildren:Boolean=true):void
		{
			Sprite($clip).buttonMode=$buttonMode;
			Sprite($clip).mouseChildren = $mouseChildren;
			if ($handlers) {
				ButtonUtil.__removeEvent($clip,MouseEvent.MOUSE_DOWN,$handlers.down);
				ButtonUtil.__removeEvent($clip,MouseEvent.MOUSE_UP,$handlers.up);
				if ($handlers.doubleclick) {
					Sprite($clip).doubleClickEnabled=false;
					ButtonUtil.__removeEvent($clip,MouseEvent.DOUBLE_CLICK,$handlers.doubleclick);
				}
				ButtonUtil.__removeEvent($clip,MouseEvent.MOUSE_OVER,$handlers.over);
				ButtonUtil.__removeEvent($clip,MouseEvent.MOUSE_OUT,$handlers.out);
			}
		}
		private static function __addEvent( $clip:DisplayObject,$event:String,$function:Function=null, $capture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void
		{
			if ($function != null) {
				$clip.addEventListener($event,$function, $capture, $priority, $weak);
			}
		}
		private static function __removeEvent( $clip:DisplayObject,$event:String,$function:Function=null, $capture:Boolean = false):void
		{
			if ($function != null) {
				$clip.removeEventListener($event,$function,$capture);
			}
		}
		
	}
}