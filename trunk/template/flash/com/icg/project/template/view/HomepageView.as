package com.autumntactics.project.template.view
{
	import flash.display.MovieClip;
	import com.autumntactics.bedrock.view.View;
	import com.autumntactics.bedrock.view.IView;
	
	import caurina.transitions.Tweener;
	import com.autumntactics.bedrock.dispatcher.MadagascarDispatcher;
	import com.autumntactics.bedrock.events.MadagascarEvent;
	import flash.events.MouseEvent;
	import com.autumntactics.util.ButtonUtil;
	public class HomepageView extends View implements IView
	{
		/*
		Variable Declarations
		*/
		public var mcChangeButton:MovieClip;
		/*
		Constructor
		*/
		public function HomepageView()
		{
			this.alpha=0;
		}
		public function initialize($properties:Object=null):void
		{
			ButtonUtil.addListeners(this.mcChangeButton,{down:this.onChangeClicked});
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			Tweener.addTween(this,{alpha:1,transition:"linear",time:1,onComplete:this.introComplete});
			//this.introComplete();
		}
		public function outro($properties:Object=null):void
		{
			Tweener.addTween(this,{alpha:0,transition:"linear",time:1,onComplete:this.outroComplete});
			//this.outroComplete();
		}
		public function clear():void
		{
			output("clear");
		}
		
		private function onChangeClicked($event:MouseEvent):void
		{
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.DO_CHANGE,this,{alias:"sub_page"}));
		}
	}
}