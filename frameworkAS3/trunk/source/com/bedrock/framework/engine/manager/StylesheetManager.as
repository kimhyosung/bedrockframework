package com.bedrock.framework.engine.manager
{
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	public class StylesheetManager
	{
		/*
		Variable Declarations
		*/
		private var _data:StyleSheet;
		/*
		Constructor
		*/
		public function StylesheetManager()
		{
		}
		
		/*
		Parse the StyleSheet
		*/
		public function parse( $data:String ):void
		{
			this._data = new StyleSheet();
			this._data.parseCSS( $data );
		}
		/*
		Get Style Object
		*/
		public function getStyleAsObject( $style:String ):Object
		{
			return this._data.getStyle( $style );
		}
		/*
		Get Format Object
		*/
		public function getStyleAsTextFormat( $style:String ):TextFormat
		{
			return this._data.transform( this.getStyleAsObject( $style ) );
		}
		/*
		Property Definitions
		*/
		public function get styleNames():Array
		{
			return this._data.styleNames;
		}
		public function get data():StyleSheet
		{
			return this._data;
		}
	}
}