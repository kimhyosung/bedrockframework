package com.bedrockframework.plugin.data
{
	import com.bedrockframework.plugin.view.IView;
	
	import flash.display.Sprite;
	
	public class SequencerData
	{
		public static const FORWARD:String = "forward";
		public static const REVERSE:String = "reverse";
		
		public static const INITIALIZE:String = "initialize";
		public static const INTRO:String = "intro";
		public static const OUTRO:String = "outro";
		
		private var _arrSequence:Array;
		public var container:Sprite;
		public var autoPilot:Boolean;
		public var direction:String;
		public var wrap:Boolean;
		public var startAt:uint;
		public var treatAsChildren:Boolean;
		
		public var time:Number;
		public var timerEnabled:Boolean;
		
		public var autoInitialize:Boolean;
		public var autoStart:Boolean;
		
		public var initializeData:Array;
		public var introData:Array;
		public var outroData:Array;
		
		
		
		public function SequencerData():void
		{
			this._arrSequence = new Array;
			this.startAt = 0;
			this.treatAsChildren = true;
			this.wrap = false;
			this.autoPilot = true;
			this.autoStart = true;
			this.time = 0;
			this.timerEnabled = false;
			this.direction = SequencerData.FORWARD;
		}
		
		public function addToSequence($view:IView, $initializeData:Object = null, $introData:Object = null, $outroData:Object = null, $callback:Function = null):void
		{
			this._arrSequence.push({view:$view, initialize:$initializeData, intro:$introData, outro:$outroData});
		}
		
		public function get sequence():Array
		{
			return this._arrSequence;
		}
	}
}