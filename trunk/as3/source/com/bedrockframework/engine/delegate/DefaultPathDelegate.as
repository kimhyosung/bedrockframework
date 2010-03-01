package com.bedrockframework.engine.delegate
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.IPathDelegate;
	import com.bedrockframework.engine.data.BedrockData;

	public class DefaultPathDelegate extends BasicWidget implements IPathDelegate
	{
		public function DefaultPathDelegate()
		{
		}
		
		public function getFontPath( $locale:String = null ):String
		{
			var strPath:String = BedrockEngine.config.getEnvironmentValue( BedrockData.FONTS_PATH );
			strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX );
			strPath += BedrockEngine.config.getSettingValue( BedrockData.FONTS_FILE_NAME );
			
			if ( $locale == null ) {
				strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + ".swf";
			} else {
				strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + this.delimiter + $locale + ".swf";
			}
			return strPath;
		}
		
		public function getCSSPath( $locale:String = null ):String
		{
			var strPath:String = BedrockEngine.config.getEnvironmentValue( BedrockData.CSS_PATH );
			strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX );
			strPath += BedrockEngine.config.getSettingValue( BedrockData.CSS_FILE_NAME );
			
			if ( $locale == null ) {
				strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + ".css";
			} else {
				strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + this.delimiter + $locale + ".css";
			}
			return strPath;
		}
		
		public function getResourceBundlePath( $locale:String = null ):String
		{
			var strPath:String = BedrockEngine.config.getEnvironmentValue( BedrockData.RESOURCE_BUNDLE_PATH );
			strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_PREFIX );
			strPath += BedrockEngine.config.getSettingValue( BedrockData.RESOURCE_BUNDLE_FILE_NAME );
			
			if ( $locale == null ) {
				strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + ".xml";
			} else {
				strPath += BedrockEngine.config.getAvailableValue( BedrockData.FILE_SUFFIX ) + this.delimiter + $locale + ".xml";
			}
			return strPath;
		}
		
		public function get delimiter():String
		{
			return "_";
		}
	}
}