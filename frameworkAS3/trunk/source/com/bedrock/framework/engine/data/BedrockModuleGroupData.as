package com.bedrock.framework.engine.data
{
	dynamic public class BedrockModuleGroupData extends BedrockModuleData
	{
		public var modules:Array;
		
		public function BedrockModuleGroupData( $data:Object )
		{
			super( $data );
			this.modules = new Array;
		}
	}
}