package com.bedrock.framework.engine.data
{
	import com.bedrock.extras.util.StringUtil;
	import com.bedrock.framework.engine.BedrockEngine;

	dynamic public class BedrockAssetData extends GenericData
	{
		public static const XML:String = "xml";
		public static const IMAGE:String = "image";
		public static const SWF:String = "swf";
		public static const STYLESHEET:String = "stylesheet";
		public static const AUDIO:String = "audio";
		public static const VIDEO:String = "video";
		public static const DATA:String = "data";
		
		public var id:String;
		public var url:String;
		
		public function BedrockAssetData( $data:Object )
		{
			this.path = BedrockData.NONE;
			
			super( $data );
			
			this.name = this.id;
			if ( this.path != BedrockData.NONE && this.path != null ) {
				this.url = ( BedrockEngine.data[ this.path ] + this.defaultURL );
			} else {
				this.url = this.defaultURL;
			}
			if ( this.localeEnabled && BedrockEngine.data.localesEnabled ) {
				var localeURL:String = StringUtil.replace( this.localeURL, "%%locale%%", BedrockEngine.localeManager.currentLocale );
				if ( this.path != BedrockData.NONE && this.path != null ) {
					this.url = BedrockEngine.data[ this.path ] + localeURL;
				} else if ( this.path == BedrockData.NONE && this.path != null ) {
					this.url = localeURL;
				}
			}
		}

	}
}