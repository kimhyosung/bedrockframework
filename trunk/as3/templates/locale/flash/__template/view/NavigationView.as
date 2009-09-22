﻿package __template.view
{
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.util.ButtonUtil;
	import com.bedrockframework.plugin.view.IView;
	import com.bedrockframework.plugin.view.View;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	import gs.easing.Quad;

	public class NavigationView extends View implements IView
	{
		/*
		Variable Declarations
		*/
		public var homepageButton:MovieClip;
		public var subpageButton:MovieClip;
		/*
		Constructor
		*/
		
		public function NavigationView()
		{
			this.alpha = 0;
		}
		
		public function initialize($properties:Object=null):void
		{
			this.createMouseHandlers();
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			TweenLite.to(this, 1, {alpha:1, ease:Quad.easeOut, onComplete:this.introComplete});
		}
		public function outro($properties:Object=null):void
		{
			
		}
		public function clear():void
		{
			
		}
		/*
		Create Mouse Handlers
		*/
		private function createMouseHandlers():void
		{
			ButtonUtil.addListeners(this.homepageButton, {down:this.onHomepageClick});
			ButtonUtil.addListeners(this.subpageButton, {down:this.onSubPageClick});
		}
		/*
		Event Handlers
	 	*/
		private function onHomepageClick($event:MouseEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE, this, {alias:"homepage"}));
		}
		private function onSubPageClick($event:MouseEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE, this, {alias:"sub_page"}));
		}
		/*
		Property Definitions
	 	*/
	}
}