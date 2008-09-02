package com.builtonbedrock.project.template.view
{
	import flash.display.MovieClip;
	import com.builtonbedrock.bedrock.view.View;
	import com.builtonbedrock.bedrock.view.IView;
	
	import caurina.transitions.Tweener;
	import com.builtonbedrock.bedrock.dispatcher.BedrockDispatcher;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	import flash.events.MouseEvent;
	import com.builtonbedrock.util.ButtonUtil;
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
			this.status("clear");
		}
		
		private function onChangeClicked($event:MouseEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE,this,{alias:"sub_page"}));
		}
	}
}