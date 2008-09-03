﻿package com.yourdomain.project.template.view{	import caurina.transitions.Tweener;		import com.bedrockframework.core.dispatcher.BedrockDispatcher;	import com.bedrockframework.engine.event.BedrockEvent;	import com.bedrockframework.engine.view.BedrockView;	import com.bedrockframework.plugin.util.ButtonUtil;	import com.bedrockframework.plugin.view.IView;		import flash.display.MovieClip;	import flash.events.MouseEvent;		public class HomepageView extends BedrockView implements IView	{		/*		Variable Declarations		*/		public var changeButton:MovieClip;		/*		Constructor		*/		public function HomepageView()		{			this.alpha=0;		}		public function initialize($properties:Object=null):void		{			ButtonUtil.addListeners(this.changeButton,{down:this.onChangeClicked});			this.initializeComplete();		}		public function intro($properties:Object=null):void		{			Tweener.addTween(this,{alpha:1,transition:"linear",time:1,onComplete:this.introComplete});			//this.introComplete();		}		public function outro($properties:Object=null):void		{			Tweener.addTween(this,{alpha:0,transition:"linear",time:1,onComplete:this.outroComplete});			//this.outroComplete();		}		public function clear():void		{			this.status("clear");		}		/*		Event Handlers		*/		private function onChangeClicked($event:MouseEvent):void		{			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE,this,{alias:"sub_page"}));		}	}}