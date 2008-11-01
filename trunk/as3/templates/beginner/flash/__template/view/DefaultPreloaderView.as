﻿package __template.view
{
	import caurina.transitions.Tweener;
	
	import com.bedrockframework.engine.view.IPreloader;
	import com.bedrockframework.engine.view.BedrockView;
	
	import flash.text.TextField;
	
	public class DefaultPreloaderView extends BedrockView implements IPreloader
	{
		/*
		Variable Declarations
		*/
		public var display:TextField;
		public var label:TextField;
		/*
		Constructor
		*/
		public function DefaultPreloaderView()
		{
			this.alpha=0;
		}
		/*
		* Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.displayProgress(0)
			this.label.text = this.current.label;
			this.x=this.stage.stageWidth / 2;
			this.y=this.stage.stageHeight / 2;
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			Tweener.addTween(this,{alpha:1,transition:"linear",time:1,onComplete:this.introComplete});
			//this.introComplete();
		}
		public function displayProgress($percent:uint):void
		{
			this.display.text=$percent + " %";
		}
		public function outro($properties:Object=null):void
		{
			Tweener.addTween(this,{alpha:0,transition:"linear",time:1,onComplete:this.outroComplete});
			//this.outroComplete();
		}
		public function clear():void
		{
		}

	}
}