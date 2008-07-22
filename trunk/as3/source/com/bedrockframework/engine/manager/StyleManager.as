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
		private static var __objStyleSheet:StyleSheet = new StyleSheet();
		/*
		Constructor
		*/
		Logger.log(StyleManager, LogLevel.CONSTRUCTOR, "Constructed");
		/*
		Parse the StyleSheet
		*/
		public static function parseCSS($stylesheet:String):void
		{
			StyleManager.__objStyleSheet = new StyleSheet();
			StyleManager.__objStyleSheet.parseCSS($stylesheet);
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
			return StyleManager.__objStyleSheet.getStyle($style);
		}
		/*
		Get Format Object
		*/
		public static function getFormat($style:String):TextFormat
		{
			return StyleManager.__objStyleSheet.transform(StyleManager.getStyle($style));
		}
		/*
		Property Definitions
		*/
		public static function get styleNames():Array
		{
			return StyleManager.__objStyleSheet.styleNames;
		}
		public static function get styleSheet():StyleSheet
		{
			return StyleManager.__objStyleSheet;
		}
	}
}