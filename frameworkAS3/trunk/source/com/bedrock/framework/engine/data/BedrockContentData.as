package com.bedrock.framework.engine.data
{
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.bedrock;
	
	dynamic public class BedrockContentData extends GenericData
	{
		
		public var id:String;
		public var url:String;
		public var container:String;
		public var indexed:Boolean;
		public var priority:int;
		public var deeplink:String;
		
		public function BedrockContentData( $data:Object )
		{
			super( $data );
			
			this.name = this.id;
			if ( this.assetGroup == BedrockData.NONE ) this.assetGroup = this.id;
			
			this.deeplink = "/" + this.id + "/";
			
			this.url = BedrockEngine.data.swfPath + this.id + ".swf";
			
			if ( this.initialTransition ) this.initialLoad = true;
			
		}
		
	}
}