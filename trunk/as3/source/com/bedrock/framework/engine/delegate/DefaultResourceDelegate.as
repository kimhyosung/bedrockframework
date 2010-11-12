package com.bedrock.framework.engine.delegate
{
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.IResourceDelegate;
	import com.bedrock.framework.engine.data.BedrockData;

	public class DefaultResourceDelegate extends StandardBase implements IResourceDelegate
	{
		public function DefaultResourceDelegate()
		{
		}
		
		public function getFontPath( $locale:String = null ):String
		{
			var strPath:String = BedrockEngine.config.getPathValue( BedrockData.FONTS_PATH );
			strPath += BedrockEngine.config.getSettingValue( BedrockData.FONTS_FILENAME );
			
			if ( $locale == null ) {
				strPath += ".swf";
			} else {
				strPath += BedrockEngine.localeManager.delimiter + $locale + ".swf";
			}
			return strPath;
		}
		
		public function getStylesheetPath( $locale:String = null ):String
		{
			var strPath:String = BedrockEngine.config.getPathValue( BedrockData.STYLESHEET_PATH );
			strPath += BedrockEngine.config.getSettingValue( BedrockData.STYLESHEET_FILENAME );
			
			if ( $locale == null ) {
				strPath += ".css";
			} else {
				strPath += BedrockEngine.localeManager.delimiter + $locale + ".css";
			}
			return strPath;
		}
		
		public function getDataBundlePath( $locale:String = null ):String
		{
			var strPath:String = BedrockEngine.config.getPathValue( BedrockData.DATA_BUNDLE_PATH );
			strPath += BedrockEngine.config.getSettingValue( BedrockData.DATA_BUNDLE_FILENAME );
			
			if ( $locale == null ) {
				strPath += ".xml";
			} else {
				strPath += BedrockEngine.localeManager.delimiter + $locale + ".xml";
			}
			return strPath;
		}
		
		public function getSharedAssetsPath( $locale:String = null ):String
		{
			var strPath:String = BedrockEngine.config.getPathValue( BedrockData.SHARED_ASSETS_PATH );
			strPath += BedrockEngine.config.getSettingValue( BedrockData.SHARED_FILENAME );
			
			if ( $locale == null ) {
				strPath +=  ".swf";
			} else {
				strPath += BedrockEngine.localeManager.delimiter + $locale + ".swf";
			}
			return strPath;
		}
		
	}
}