package com.bedrock.framework.engine.data
{
	import com.bedrock.framework.engine.*;
	import com.greensock.loading.core.LoaderItem;

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
		
		public function BedrockAssetData( $data:Object = null )
		{
			this.path = BedrockData.NONE;
			
			super( $data );
			
			this.name = this.id;
		}
		
		public function get url():String
		{
			var url:String;
			if ( this.localeEnabled && Bedrock.data.localesEnabled ) {
				var localeURL:String = this._replaceString( this.localeURL, "%%locale%%", Bedrock.engine::localeManager.currentLocale );
				if ( this.path != BedrockData.NONE && this.path != null ) {
					url = Bedrock.data[ this.path ] + localeURL;
				} else if ( this.path == BedrockData.NONE && this.path != null ) {
					url = localeURL;
				}
			} else {
				if ( this.path != BedrockData.NONE && this.path != null && this.path != undefined ) {
					url = ( Bedrock.data[ this.path ] + this.defaultURL );
				} else {
					url = this.defaultURL;
				}
			}
			return url;
		}
		
		private function _replaceString( $raw:String, $tag:String, $content:String):String
		{
			return $raw.split( $tag ).join( $content );
		}
		
		public function get loader():LoaderItem
		{
			return Bedrock.engine::loadController.getLoader( this.id );
		}
		public function get content():*
		{
			return Bedrock.engine::loadController.getLoaderContent( this.id );
		}
		public function get rawContent():*
		{
			return Bedrock.engine::loadController.getRawLoaderContent( this.id );
		}

	}
}