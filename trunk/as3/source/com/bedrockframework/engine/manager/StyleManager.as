package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.api.IStyleManager;
	
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	public class StyleManager extends StandardWidget implements IStyleManager
	{
		/*
		Variable Declarations
		*/
		private var _objStyleSheet:StyleSheet;
		/*
		Constructor
		*/
		public function StyleManager()
		{
			this._objStyleSheet = new StyleSheet();
		}
		/*
		Parse the StyleSheet
		*/
		public function parseCSS($stylesheet:String):void
		{
			this._objStyleSheet = new StyleSheet();
			this._objStyleSheet.parseCSS($stylesheet);
		}
		/*
		Apply Tag
		*/
		public function applyTag($text:String, $tag:String):String
		{
			return "<" +$tag +">" + $text +"</" +$tag +">";
		}
		/*
		Apply Style
		*/
		public function applyStyle($text:String, $style:String):String
		{
			return "<span class='" +$style +"'>" + $text +"</span>";
		}
		/*
		Get Style Object
		*/
		public function getStyle($style:String):Object
		{
			return this._objStyleSheet.getStyle($style);
		}
		/*
		Get Format Object
		*/
		public function getFormat($style:String):TextFormat
		{
			return this._objStyleSheet.transform(this.getStyle($style));
		}
		/*
		Property Definitions
		*/
		public function get styleNames():Array
		{
			return this._objStyleSheet.styleNames;
		}
		public function get styleSheet():StyleSheet
		{
			return this._objStyleSheet;
		}
	}
}