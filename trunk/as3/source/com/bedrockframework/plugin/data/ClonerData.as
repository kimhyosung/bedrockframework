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

		public var xspace:int;
		public var yspace:int;
		public var offset:uint;
		public var xrange:int;
		public var yrange:int;
		public var wrap:uint;
		public var total:uint;

		public var direction:String;
		public var pattern:String;


		public function ClonerData():void
		{
			this.wrap = 0;
			this.total = 0;
		}

	}

}