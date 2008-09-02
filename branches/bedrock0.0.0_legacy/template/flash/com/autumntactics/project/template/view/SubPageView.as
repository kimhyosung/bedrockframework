package com.builtonbedrock.project.template.view
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.builtonbedrock.bedrock.view.View;
	import com.builtonbedrock.bedrock.view.IView;
	
	import caurina.transitions.Tweener;
	import com.builtonbedrock.bedrock.dispatcher.BedrockDispatcher;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	import com.builtonbedrock.project.template.events.SiteEvent;
	import flash.events.MouseEvent;
	import com.builtonbedrock.util.ButtonUtil;
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
			BedrockDispatcher.addEventListener(SiteEvent.DATA_RESPONSE,this.onResponse);
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
			BedrockDispatcher.removeEventListener(SiteEvent.DATA_RESPONSE,this.onResponse);
		}
		private function onChangeClicked($event:MouseEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE,this,{alias:"homepage"}));
		}
		private function onRequestClicked($event:MouseEvent):void
		{
			BedrockDispatcher.dispatchEvent(new SiteEvent(SiteEvent.DATA_REQUEST,this, {form:"registration"}));
		}
		private function onResponse($event:SiteEvent):void
		{
			this.txtDisplay.text = $event.details.data;
		}
		
		
	}
}