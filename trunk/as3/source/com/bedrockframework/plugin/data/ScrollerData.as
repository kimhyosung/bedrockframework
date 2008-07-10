package com.bedrockframework.plugin.data
{
	import flash.display.Sprite;

	public class ScrollerData
	{
		public static  var HORIZONTAL:String = "horizontal";
		public static  var VERTICAL:String = "vertical";
		public static  var CENTER:String = "center";
		public static  var TOP:String = "top";
		public static  var BOTTOM:String = "bottom";
		public static  var LEFT:String = "top";
		public static  var RIGHT:String = "bottom";

		public var trackContainer:Sprite;
		public var trackBackground:Sprite;
		public var drag:Sprite;
		public var content:Sprite;
		public var mask:Sprite;

		public var resize:Boolean;
		public var autohide:Boolean;
		public var updateOnDrag:Boolean;
		public var direction:String;
		public var alignment:String;
		public var manualIncrement:int

		public function ScrollerData():void
		{
			this.resize = true;
			this.autohide = true;
			this.updateOnDrag = false;
			this.direction = ScrollerData.VERTICAL;
			this.alignment = ScrollerData.TOP;
		}

	}

}