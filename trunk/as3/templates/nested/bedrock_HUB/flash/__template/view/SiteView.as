﻿package __template.view
{
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.view.BedrockView;
	import com.bedrockframework.plugin.view.IView;
	
	import gs.TweenLite;
	import gs.easing.Quad;
	
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
			this.alpha=0;
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
			TweenLite.to( this, 1, {alpha:1, ease:Quad.easeOut, onComplete:this.introComplete} );
			//this.introComplete();
		}
		
		public function outro($properties:Object=null):void
		{
			TweenLite.to( this, 1, {alpha:0, ease:Quad.easeOut, onComplete:this.outroComplete} );
			//this.outroComplete();
		}
		public function clear():void
		{

		}
		/*
		Event Handlers
		*/
		private function onIntroTweenComplete():void
		{
			this.introComplete();
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.DO_DEFAULT, this ) );
		}
	}
}