﻿package __template.view{	import __template.event.SiteEvent;		import com.bedrockframework.core.dispatcher.BedrockDispatcher;	import com.bedrockframework.engine.BedrockEngine;	import com.bedrockframework.engine.event.BedrockEvent;	import com.bedrockframework.engine.view.BedrockView;	import com.bedrockframework.plugin.util.ButtonUtil;	import com.bedrockframework.plugin.view.IView;	import com.greensock.TweenLite;		import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.text.TextField;		public class SubPageView extends BedrockView implements IView	{		/*		Variable Declarations		*/		public var changeButton:MovieClip;		public var requestButton:MovieClip;		public var display:TextField;		/*		Constructor		*/		public function SubPageView()		{			this.alpha=0;		}		public function initialize($properties:Object=null):void		{			BedrockDispatcher.addEventListener(SiteEvent.DATA_RESPONSE,this.onResponse);						ButtonUtil.addListeners(this.changeButton,{down:this.onChangeClicked});			ButtonUtil.addListeners(this.requestButton,{down:this.onRequestClicked});			this.initializeComplete();		}		public function intro($properties:Object=null):void		{			BedrockEngine.soundManager.play( "asia_background" );						TweenLite.to(this, 1, {alpha:1, onComplete:this.introComplete});			//this.introComplete();		}		public function outro($properties:Object=null):void		{			BedrockEngine.soundManager.stop( "asia_background" );						TweenLite.to(this, 1, {alpha:0, onComplete:this.outroComplete});			//this.outroComplete();		}		public function clear():void		{			BedrockDispatcher.removeEventListener(SiteEvent.DATA_RESPONSE,this.onResponse);		}		private function onChangeClicked($event:MouseEvent):void		{			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE,this,{ alias:"homepage" }));		}		private function onRequestClicked($event:MouseEvent):void		{			BedrockDispatcher.dispatchEvent(new SiteEvent(SiteEvent.DATA_REQUEST,this, {form:"registration"}));		}		private function onResponse($event:SiteEvent):void		{			this.display.text = $event.details.data;		}					}}