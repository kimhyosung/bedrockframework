package com.bedrockframework.plugin.data
{
	import flash.display.Sprite;
	
	public class ViewSequencerData
	{
		
		public var sequence:Array;
		public var container:Sprite;
		public var autoPilot:Boolean;
		public var direction:String;
		public var wrap:Boolean;
		
		public static const FORWARD:String = "forward"
		public static const REVERSE:String = "reverse"
		
		public function ViewSequencerData():void
		{
			this.wrap = false;
			this.autoPilot = true;
			this.direction = ViewSequencerData.FORWARD;
		}
	}
}