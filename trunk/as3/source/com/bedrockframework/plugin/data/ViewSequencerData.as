package com.bedrockframework.plugin.data
{
	import com.bedrockframework.plugin.view.IView;
	
	import flash.display.Sprite;
	
	public class ViewSequencerData
	{
		
		private var _arrSequence:Array;
		public var container:Sprite;
		public var autoPilot:Boolean;
		public var direction:String;
		public var wrap:Boolean;
		public var startAt:uint;
		public var treatAsChildren:Boolean;
		
		public var autoInitialize:Boolean;
		public var autoStart:Boolean;
		
		public var initializeData:Array;
		public var introData:Array;
		public var outroData:Array;
		
		public static const FORWARD:String = "forward"
		public static const REVERSE:String = "reverse"
		
		public function ViewSequencerData():void
		{
			this._arrSequence = new Array;
			this.startAt = 0;
			this.treatAsChildren = true;
			this.wrap = false;
			this.autoPilot = true;
			this.autoStart = true;
			this.direction = ViewSequencerData.FORWARD;
		}
		
		public function addToSequence($view:IView, $initializeData:Object = null, $introData:Object = null, $outroData:Object = null):void
		{
			this._arrSequence.push({view:$view, initialize:$initializeData, intro:$introData, outro:$outroData});
		}
		
		public function get sequence():Array
		{
			return this._arrSequence;
		}
	}
}