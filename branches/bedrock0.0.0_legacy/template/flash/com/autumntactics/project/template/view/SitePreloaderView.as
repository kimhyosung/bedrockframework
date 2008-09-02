package com.builtonbedrock.project.template.view
{
	import com.builtonbedrock.bedrock.base.MovieClipWidget;
	import com.builtonbedrock.bedrock.view.View;
	import com.builtonbedrock.bedrock.view.IView;
	import com.builtonbedrock.bedrock.view.IPreloader;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	
	import caurina.transitions.Tweener;
	import flash.text.TextField;
	public class SitePreloaderView extends View implements IPreloader
	{
		/*
		* Variable Declarations
		*/
		public var txtDisplay:TextField;
		/*
		* Constructor
		*/
		public function SitePreloaderView()
		{
			this.alpha = 0 ;
		}
		/*
		* Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.displayProgress(0);
			this.x=this.stage.stageWidth / 2;
			this.y=this.stage.stageHeight / 2;
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			Tweener.addTween(this, {alpha:1, transition:"linear", time:1, onComplete:this.introComplete});
			//this.introComplete();
		}
		public function displayProgress($percent:uint):void
		{
			this.txtDisplay.text=$percent + " %";
		}
		public function outro($properties:Object=null):void
		{
			Tweener.addTween(this, {alpha:0, transition:"linear", time:1, onComplete:this.outroComplete});
			//this.outroComplete();
		}
		
		public function clear():void
		{
		}
		

	}
}