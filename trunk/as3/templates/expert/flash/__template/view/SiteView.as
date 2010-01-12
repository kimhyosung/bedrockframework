﻿package __template.view
{
	import com.bedrockframework.engine.view.BedrockView;
	import com.bedrockframework.plugin.view.IView;
	
	import gs.TweenLite;
	
	public class SiteView extends BedrockView implements IView
	{
		/*
		Variable Declarations
		*/
		/*
		Constructor
	 	*/
		public function SiteView()
		{
			this.alpha = 0;
		}
		/*
		Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			//BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_DEFAULT,this));
			TweenLite.to(this, 1, {alpha:1, onComplete:this.introComplete});
			//this.introComplete();
		}
		public function outro($properties:Object=null):void
		{
			TweenLite.to(this, 1, {alpha:0, onComplete:this.outroComplete});
			//this.outroComplete();
		}
		public function clear():void
		{
		}
	}
}