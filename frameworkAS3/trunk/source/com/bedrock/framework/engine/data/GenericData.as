package com.bedrock.framework.engine.data
{
	dynamic public class GenericData
	{
		public function GenericData( $data:Object )
		{
			for (var d:String in $data) {
				this[ d ] = $data[ d ];
			}
		}

	}
}