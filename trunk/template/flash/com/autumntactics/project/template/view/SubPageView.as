package com.autumntactics.project.template.view
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.autumntactics.bedrock.view.View;
	import com.autumntactics.bedrock.view.IView;
	
	import caurina.transitions.Tweener;
	import com.autumntactics.bedrock.dispatcher.MadagascarDispatcher;
	import com.autumntactics.bedrock.events.MadagascarEvent;
	import com.autumntactics.project.template.events.SiteEvent;
	import flash.events.MouseEvent;
	import com.autumntactics.util.ButtonUtil;
	public class SubPageView extends View implements IView
	{
		/*
		Variable Declarations
		*/
		public var mcChangeButton:MovieClip;
		public var mcRequestButton:MovieClip;
		public var txtDisplay:TextField;
		/*
		Constructor
		*/
		public function SubPageView()
		{
			this.alpha=0;
		}
		public function initialize($properties:Object=null):void
		{
			MadagascarDispatcher.addEventListener(SiteEvent.DATA_RESPONSE,this.onResponse);
			ButtonUtil.addListeners(this.mcChangeButton,{down:this.onChangeClicked});
			ButtonUtil.addListeners(this.mcRequestButton,{down:this.onRequestClicked});
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
			MadagascarDispatcher.removeEventListener(SiteEvent.DATA_RESPONSE,this.onResponse);
		}
		private function onChangeClicked($event:MouseEvent):void
		{
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.DO_CHANGE,this,{alias:"homepage"}));
		}
		private function onRequestClicked($event:MouseEvent):void
		{
			MadagascarDispatcher.dispatchEvent(new SiteEvent(SiteEvent.DATA_REQUEST,this, {form:"registration"}));
		}
		private function onResponse($event:SiteEvent):void
		{
			this.txtDisplay.text = $event.details.data;
		}
		
		
	}
}