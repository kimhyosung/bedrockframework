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
		
		public var paddingX:int;
		public var paddingY:int;
		
		public var autoSpacing:Boolean;
		
		public var useDummyContainer:Boolean;
		
		public var clone:Class;
		public var container:DisplayObjectContainer;

		public function ClonerData():void
		{
			this.autoSpacing = false;
			
			this.offset = 0;
			this.wrap = 0;
			this.total = 0;
			
			this.direction = ClonerData.VERTICAL;
			this.pattern = ClonerData.LINEAR;
			
			this.useDummyContainer = true;
		}

	}

}