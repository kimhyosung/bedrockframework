﻿package __template.view
{
	import com.bedrockframework.engine.view.BedrockView;
	import com.bedrockframework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	
	public class HomepageView extends BedrockView implements IView
	{
		/*
		Variable Declarations
		*/
		public var label:TextField;
		/*
		Constructor
		*/
		public function HomepageView()
		{
			this.alpha = 0;
		}
		/*
		Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.label.text = this.data.label;
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			TweenLite.to(this, 1, { alpha:1, onComplete:this.introComplete } );
			//this.introComplete();
		}
		public function outro($properties:Object=null):void
		{
			TweenLite.to(this, 1, { alpha:0, onComplete:this.outroComplete } );
			//this.outroComplete();
		}
		public function clear():void
		{
			this.status("Clear");
		}
	}
}