package com.bedrock.framework.engine.data
{
	import com.bedrock.framework.engine.*;
	
	dynamic public class BedrockModuleData extends GenericData
	{
		
		public var id:String;
		public var container:String;
		public var indexed:Boolean;
		public var priority:int;
		public var deeplink:String;
		
		public function BedrockModuleData( $data:Object )
		{
			super( $data );
			
			this.name = this.id;
			if ( this.assetGroup == BedrockData.NONE ) this.assetGroup = this.id;
			
			this.deeplink = "/" + this.id + "/";
			
			if ( this.initialTransition ) this.initialLoad = true;
		}
		
		public function get url():String
		{
			return Bedrock.data.swfPath + this.id + ".swf";
		}
		
		public function get loader():*
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