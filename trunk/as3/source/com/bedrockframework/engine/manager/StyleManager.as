package com.bedrockframework.engine.manager
{
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.core.logging.LogLevel;
	
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	public class StyleManager extends StaticWidget
	{
		
		/*
		Variable Declarations
		*/
		private static var OBJ_STYLE_SHEET:StyleSheet = new StyleSheet();
		
		Logger.log(StyleManager, LogLevel.CONSTRUCTOR, "Constructed");
		/*
		Parse the StyleSheet
		*/
		private static function parseCSS($stylesheet:String):void
		{
			StyleManager.OBJ_STYLE_SHEET = new StyleSheet();
			StyleManager.OBJ_STYLE_SHEET.parseCSS($stylesheet);
		}
		/*
		Apply Tag
		*/
		public static function applyTag($text:String, $tag:String):String
		{
			return "<" +$tag +">" + $text +"</" +$tag +">"
		}
		/*
		Apply Style
		*/
		public static function applyStyle($text:String, $style:String):String
		{
			return "<span class='" +$style +"'>" + $text +"</span>"
		}
		/*
		Get Style Object
		*/
		public static function getStyle($style:String):Object
		{
			return StyleManager.OBJ_STYLE_SHEET.getStyle($style);
		}
		/*
		Get Format Object
		*/
		public static function getFormat($style:String):TextFormat
		{
			return StyleManager.OBJ_STYLE_SHEET.transform(StyleManager.getStyle($style));
		}
		/*
		Event Handlers
		*/
		public static function onCSSLoaded($event:LoaderEvent):void
		{
			StyleManager.parseCSS($event.details.data);
		}
		/*
		Property Definitions
		*/
		public static function get styleNames():Array
		{
			return StyleManager.OBJ_STYLE_SHEET.styleNames;
		}
		public static function get styleSheet():StyleSheet
		{
			return StyleManager.OBJ_STYLE_SHEET;
		}
	}
}