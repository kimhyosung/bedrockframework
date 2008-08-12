package com.bedrockframework.plugin.data
{
	import flash.display.DisplayObjectContainer;
	
	public class ClonerData
	{
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		public static const LINEAR:String = "linear";
		public static const GRID:String = "grid";
		public static const RANDOM:String = "random";

		public var spaceX:int;
		public var spaceY:int;
		public var rangeX:int;
		public var rangeY:int;
		
		public var offset:int;
		
		public var wrap:uint;
		public var total:uint;

		public var direction:String;
		public var pattern:String;

		public function ClonerData():void
		{
			this.wrap = 0;
			this.total = 0;
			
			this.direction = ClonerData.HORIZONTAL;
			this.pattern = ClonerData.LINEAR;
		}

	}

}