package com.bedrock.framework.engine.data
{
	import com.bedrock.extras.util.VariableUtil;
	
	dynamic public class BedrockContentData extends GenericData
	{
		
		public var id:String;
		public var container:String;
		public var indexed:Boolean;
		public var priority:int;
		public var deeplink:String;
		
		public function BedrockContentData( $data:Object )
		{
			super( $data );
			
			this.name = this.id;
			this.deeplink = "/" + this.id + "/";
			
			if ( this.initialTransition ) this.initialLoad = true;
			
		}
		
	}
}