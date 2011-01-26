package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.engine.api.IStylesheetManager;
	
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	/**
	 * @private
	 */
	public class StylesheetManager implements IStylesheetManager
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
		public function initialize( $stylesheet:StyleSheet ):void
		{
			this._data = $stylesheet;
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