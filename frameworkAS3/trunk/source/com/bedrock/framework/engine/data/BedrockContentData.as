package com.bedrock.framework.engine.data
{
	public class BedrockContentData
	{
		
		public var id:String;
		public var container:String;
		public var indexed:Boolean;
		public var priority:int;
		public var contents:Array;
		public var isComplex:Boolean;
		
		public function BedrockContentData( $data:Object )
		{
			this.id = $data.id;
			this.container = $data.container;
			this.indexed = $data.indexed;
			this.priority = $data.priority;
			
			this.contents = new Array;
			if( $data.contents != null && $data.contents.length > 0 ) this._convertContents( $data.contents );
			this.isComplex = ( this.contents.length > 0 );
		}
		
		private function _convertContents( $contents:Array ):void
		{
			this.contents = new Array;
			for each( var data:Object in $contents ) {
				this.contents.push( new BedrockContentData( data ) );
			}
		}
	}
}