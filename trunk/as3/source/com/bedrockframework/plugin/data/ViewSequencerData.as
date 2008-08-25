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
		public var startAt:uint;
		
		public static const FORWARD:String = "forward"
		public static const REVERSE:String = "reverse"
		
		public function ViewSequencerData():void
		{
			this.sequence = new Array;
			this.startAt = 0;
			this.wrap = false;
			this.autoPilot = true;
			this.direction = ViewSequencerData.FORWARD;
		}
	}
}