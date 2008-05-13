package com.icg.madagascar.gadget
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;

	import com.icg.madagascar.manager.ContainerManager;
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.tools.VisualLoader;

	public class LayoutBuilder extends StaticWidget
	{

		public static function initialize()
		{
		}
		public static function buildLayout($layout:Array):void
		{
			for (var i = 0; i < $layout.length; i++) {
				LayoutBuilder.buildContainer($layout[i]);
			}
		}
		public static function buildContainer($properties:Object):void
		{
			var strName:String =$properties.name;
			var objView:DisplayObjectContainer = $properties.view || new VisualLoader();
			delete $properties.name;
			delete $properties.view;
			ContainerManager.buildContainer(strName, objView, $properties);
		}
	}
}