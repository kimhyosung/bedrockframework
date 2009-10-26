package com.bedrockframework.plugin.data
{
	import com.bedrockframework.plugin.view.IView;
	
	import flash.display.Sprite;
	
	public class ViewStackData
	{
		public static const FORWARD:String = "forward";
		public static const REVERSE:String = "reverse";
		
		public static const INITIALIZE:String = "initialize";
		public static const INTRO:String = "intro";
		public static const OUTRO:String = "outro";
		
		private var _arrStack:Array;
		
		public var container:Sprite;
		public var autoPilot:Boolean;
		public var direction:String;
		public var wrap:Boolean;
		public var startAt:uint;
		public var addAsChildren:Boolean;
		
		public var time:Number;
		public var timerEnabled:Boolean;
		
		public var autoInitialize:Boolean;
		public var autoStart:Boolean;
		
		public var initializeData:Array;
		public var introData:Array;
		public var outroData:Array;
		
		public function ViewStackData():void
		{
			this._arrStack = new Array;
			this.startAt = 0;
			this.addAsChildren = true;
			this.wrap = false;
			this.autoPilot = true;
			this.autoStart = true;
			this.time = 0;
			this.timerEnabled = false;
			this.direction = ViewStackData.FORWARD;
		}
		
		public function addToStack($view:IView, $initializeData:Object = null, $introData:Object = null, $outroData:Object = null, $callback:Function = null):void
		{
			this._arrStack.push({view:$view, initialize:$initializeData, intro:$introData, outro:$outroData});
		}
		
		public function get sequence():Array
		{
			return this._arrStack;
		}
	}
}