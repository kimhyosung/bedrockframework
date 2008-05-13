package com.autumntactics.project.template.view
{
	import com.autumntactics.bedrock.base.MovieClipWidget;
	import com.autumntactics.bedrock.view.View;
	import com.autumntactics.bedrock.view.IView;
	import com.autumntactics.bedrock.view.IPreloader;
	import com.autumntactics.bedrock.events.MadagascarEvent;
	
	import caurina.transitions.Tweener;
	import flash.text.TextField;
	public class SitePreloader extends View implements IPreloader
	{

		/*
		Variable Declarations
		*/
		public var txtDisplay:TextField;
		/*
		Constructor
		*/
		public function SitePreloader()
		{
			this.alpha = 0 ;
		}
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
		

	}
}