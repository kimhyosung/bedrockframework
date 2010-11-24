package com.bedrock.framework.engine.api
{
	public interface IResourceDelegate
	{
		function getFontPath( $locale:String = null ):String
		function getStylesheetPath( $locale:String = null ):String;
		function getDataBundlePath( $locale:String = null ):String;
		function getLibraryPath( $locale:String = null ):String;
	}
}