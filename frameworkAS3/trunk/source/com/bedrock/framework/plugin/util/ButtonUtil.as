package com.bedrock.framework.plugin.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class ButtonUtil
	{
		public static function addListeners( $target:DisplayObject, $handlers:Object, $buttonMode:Boolean=true, $mouseChildren:Boolean=false):void
		{
			Sprite($target).buttonMode=$buttonMode;
			Sprite($target).mouseChildren = $mouseChildren;
			if ($handlers) {
				ButtonUtil.__addEvent($target,MouseEvent.MOUSE_DOWN,$handlers.down);
				ButtonUtil.__addEvent($target,MouseEvent.MOUSE_UP,$handlers.up);
				if ($handlers.doubleclick) {
					Sprite($target).doubleClickEnabled=true;
					ButtonUtil.__addEvent($target,MouseEvent.DOUBLE_CLICK,$handlers.doubleclick);
				}
				ButtonUtil.__addEvent($target,MouseEvent.MOUSE_OVER,$handlers.over);
				ButtonUtil.__addEvent($target,MouseEvent.MOUSE_OUT,$handlers.out);
			}
		}
		public static function removeListeners( $target:DisplayObject, $handlers:Object, $buttonMode:Boolean=false, $mouseChildren:Boolean=true):void
		{
			Sprite($target).buttonMode=$buttonMode;
			Sprite($target).mouseChildren = $mouseChildren;
			if ($handlers) {
				ButtonUtil.__removeEvent($target,MouseEvent.MOUSE_DOWN,$handlers.down);
				ButtonUtil.__removeEvent($target,MouseEvent.MOUSE_UP,$handlers.up);
				if ($handlers.doubleclick) {
					Sprite($target).doubleClickEnabled=false;
					ButtonUtil.__removeEvent($target,MouseEvent.DOUBLE_CLICK,$handlers.doubleclick);
				}
				ButtonUtil.__removeEvent($target,MouseEvent.MOUSE_OVER,$handlers.over);
				ButtonUtil.__removeEvent($target,MouseEvent.MOUSE_OUT,$handlers.out);
			}
		}
		private static function __addEvent( $target:DisplayObject,$event:String,$function:Function=null, $capture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void
		{
			if ($function != null) {
				$target.addEventListener($event,$function, $capture, $priority, $weak);
			}
		}
		private static function __removeEvent( $target:DisplayObject,$event:String,$function:Function=null, $capture:Boolean = false):void
		{
			if ($function != null) {
				$target.removeEventListener($event,$function,$capture);
			}
		}
		
	}
}