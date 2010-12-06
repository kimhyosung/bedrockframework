package com.bedrock.framework.engine.data
{
	dynamic public class BedrockAssetData extends GenericData
	{
		public var id:String;
		
		public function BedrockAssetData( $data:Object )
		{
			super( $data );
			this.name = this.id;
		}

	}
}