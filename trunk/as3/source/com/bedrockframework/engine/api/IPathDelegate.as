package com.bedrockframework.engine.api
{
	public interface IPathDelegate
	{
		function getFontPath( $locale:String = null ):String
		function getStylesheetPath( $locale:String = null ):String;
		function getResourceBundlePath( $locale:String = null ):String;
		function getSharedPath( $locale:String = null ):String;
	}
}