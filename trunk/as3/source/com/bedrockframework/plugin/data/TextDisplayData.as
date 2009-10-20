package com.bedrockframework.plugin.data
{
	
	public class TextDisplayData
	{
		public var text:String;
		
		public var resourceKey:String;
		public var resourceGroup:String;
		
		public var width:Number;
		public var height:Number;
		
		public var styleName:String;
		public var autoPopulate:Boolean;
		
		public function TextDisplayData( )
		{
			this.text = "";
			this.width = 200;
			this.height = 50;
		}
		
	}
}