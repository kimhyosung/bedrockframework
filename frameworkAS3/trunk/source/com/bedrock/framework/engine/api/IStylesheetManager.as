package com.bedrock.framework.engine.api
{
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public interface IStylesheetManager
	{
		function initialize( $stylesheet:StyleSheet ):void;
		function getStyleAsObject( $style:String ):Object;
		function getStyleAsTextFormat( $style:String ):TextFormat;
		function get styleNames():Array;
		function get data():StyleSheet;
	}
}