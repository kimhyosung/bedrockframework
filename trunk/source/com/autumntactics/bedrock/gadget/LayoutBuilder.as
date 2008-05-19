package com.autumntactics.bedrock.gadget
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;

	import com.autumntactics.bedrock.manager.ContainerManager;
	import com.autumntactics.bedrock.base.StaticWidget;
	import com.autumntactics.loader.VisualLoader;

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