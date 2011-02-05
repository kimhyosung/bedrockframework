package com.bedrock.framework.engine.data
{
	import com.bedrock.framework.Bedrock;
	
	public class BedrockDeeplinkData
	{
		public function BedrockDeeplinkData()
		{
		}
		
		public function get url():String
		{
			return Bedrock.deeplinking.getAddress();
		}
		public function get paths():Array
		{
			return Bedrock.deeplinking.getPathNames();
		}
		public function get parameters():Object
		{
			return Bedrock.deeplinking.getParametersAsObject();
		}
	}
}