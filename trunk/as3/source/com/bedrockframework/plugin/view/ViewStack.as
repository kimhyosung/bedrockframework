﻿package com.bedrockframework.plugin.view
{
	import com.bedrockframework.core.base.SpriteWidget;
	import com.bedrockframework.plugin.data.ViewStackData;
	import com.bedrockframework.plugin.event.TriggerEvent;
	import com.bedrockframework.plugin.event.ViewEvent;
	import com.bedrockframework.plugin.event.ViewStackEvent;
	import com.bedrockframework.plugin.storage.SuperArray;
	import com.bedrockframework.plugin.timer.TimeoutTrigger;
	import com.bedrockframework.plugin.util.ArrayUtil;
	
	import flash.display.Sprite;

	public class ViewStack extends SpriteWidget
	{
		/*
		Variable Declarations
		*/
		public static const INITIALIZE:String = "initialize";
		public static const INTRO:String = "intro";
		public static const OUTRO:String = "outro";
		
		public var data:ViewStackData;
		private var _objViewBrowser:SuperArray;
		private var _objContainer:Sprite;
		private var _objQueueItem:Object;
		private var _objCurrentItem:Object;
		private var _objPreviousItem:Object;
		
		private var _strDirection:String;
		
		private var _objTrigger:TimeoutTrigger;
		
		private var _bolRunning:Boolean;
		/*
		Constructor
		*/
		public function ViewStack()
		{
			this._objViewBrowser = new SuperArray;
		}
		public function initialize($data:ViewStackData):void
		{
			this.clear();
			
			this.data = $data;
			this._objViewBrowser.data = this.data.stack;
			this._objQueueItem = this._objViewBrowser.setSelected( this.data.startingIndex );
			this._objViewBrowser.wrapIndex = this.data.wrap;
			this.setContainer(this.data.container);
			
			if ( this.data.autoStart ) this.queue();
			this.createTrigger(); 
		}
		public function clear():void
		{
			if ( this._objCurrentItem != null && this._objContainer != null ) {
				this.removeListeners(this._objCurrentItem.view);
				if ( this.data.addAsChildren ) {
					this._objContainer.removeChild(this._objCurrentItem.view);
				}
			}
		}
		/*
		Creation Functions
		*/
		private function createTrigger():void
		{
			this._objTrigger = new TimeoutTrigger;
			this._objTrigger.addEventListener( TriggerEvent.TRIGGER, this.onTrigger );
			this._objTrigger.silenceLogging = true;
		}
		
		/*
		Timer Functions
		*/
		public function startTimer($time:Number = 0):void
		{
			if (  this.data.mode == ViewStackData.SELECT ) this.data.mode = ViewStackData.FORWARD;
			this.data.timerEnabled = true;
			this.advance();
		}
		public function stopTimer():void
		{
			this.data.timerEnabled = false;
			this._objTrigger.stop();
		}
		/*
		Set the container where the views will be showing up
		*/
		private function setContainer( $container:Sprite = null ):void
		{
			this._objContainer=$container || this;
		}
		/*
		Queue/ Dequeue
		*/
		private function queue():void
		{
			this._objCurrentItem = this._objQueueItem;
			this._objQueueItem = null;
			
			if (this.data.addAsChildren) {
				this._objContainer.addChild(this._objCurrentItem.view);
			}
			var objView:View = this._objCurrentItem.view as View;
			this.addListeners(this._objCurrentItem.view);
			if (this.data.autoInitialize ) {
				if ( objView != null && !objView.hasInitialized ) {
					this.call( ViewStack.INITIALIZE );
				} else {
					this.call( ViewStack.INTRO );
				}
			} else {
				this.call( ViewStack.INTRO );
			}
		}
		private function dequeue():void
		{
			this._objPreviousItem = this._objCurrentItem;
			this._objCurrentItem = null;
			
			this.removeListeners(this._objPreviousItem.view);
			if (this.data.addAsChildren) {
				this._objContainer.removeChild(this._objPreviousItem.view);
			}
			if ( this._objQueueItem != null ) this.queue();
		}
		/*
		Show View
		*/
		public function selectByIndex($index:uint):void
		{
			this.stopTimer();
			this._objQueueItem = this._objViewBrowser.setSelected( $index );
			if ( this._objCurrentItem != null ) {
				this.call( ViewStack.OUTRO );
			} else {
				this.queue();
			}
			this.dispatchEvent( new ViewStackEvent( ViewStackEvent.CHANGE, this ) );
		}
		public function selectByAlias( $alias:String ):void
		{
			var numIndex:int = ArrayUtil.findIndex( this.data.stack, $alias, "alias" );
			if ( numIndex != -1 ) {
				this.selectByIndex( numIndex );
			} else {
				this.error( "Alias not found!" );
			}
		}
		/*
		Get View
		*/
		public function getByIndex( $index:uint ):Object
		{
			return this._objViewBrowser.getItemAt( $index );
		}
		public function getByAlias( $alias:String ):Object
		{
			return this._objViewBrowser.findItem( $alias, "alias" );
		}
		/*
		External Next/ Previous
		*/
		public function selectNext():void
		{
			if ( this._objViewBrowser.hasNext() || ( !this._objViewBrowser.hasNext() && this.data.wrap ) ) {
				this._objQueueItem = this._objViewBrowser.selectNext();
				this.data.mode = ViewStackData.FORWARD;
				if ( this._objCurrentItem != null ) {
					this.call( ViewStack.OUTRO );
				} else {
					this.queue();
				}
				this.dispatchEvent( new ViewStackEvent( ViewStackEvent.NEXT, this, this.getDetailObject() ) );
			} else if ( !this._objViewBrowser.hasNext() && !this.data.wrap ) {
				this.status("Hit Ending");
				this.dispatchEvent( new ViewStackEvent( ViewStackEvent.ENDING, this, this.getDetailObject() ) );
			}
		}
		public function selectPrevious():void
		{
			if ( this._objViewBrowser.hasPrevious() || ( !this._objViewBrowser.hasPrevious() && this.data.wrap ) ){
				this._objQueueItem = this._objViewBrowser.selectPrevious();
				this.data.mode = ViewStackData.REVERSE;
				if ( this._objCurrentItem != null ) {
					this.call( ViewStack.OUTRO );
				} else {
					this.queue();
				}
				this.dispatchEvent( new ViewStackEvent( ViewStackEvent.PREVIOUS, this, this.getDetailObject() ) );
			} else if ( !this._objViewBrowser.hasPrevious() && !this.data.wrap ) {
				this.status( "Hit Beginning" );
				this.dispatchEvent( new ViewStackEvent( ViewStackEvent.BEGINNING, this, this.getDetailObject() ) );
			}
		}
		/*
		Call Functions
	 	*/
	 	private function call($type:String):void
		{
			var objView:IView = IView( this._objCurrentItem.view );
			switch ($type) {
				case ViewStack.INITIALIZE :
					objView.initialize( this._objCurrentItem.initialize );
					break;
				case ViewStack.INTRO :
					objView.intro( this._objCurrentItem.intro );
					break;
				case ViewStack.OUTRO :
					objView.outro( this._objCurrentItem.outro );
					break;
			}
		}
		/*
		Manager Event Listening
		*/
		private function addListeners($target:* = null):void
		{
			if ($target != null) {
				$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onInitializeComplete);
				$target.addEventListener(ViewEvent.INTRO_COMPLETE,this.onIntroComplete);
				$target.addEventListener(ViewEvent.OUTRO_COMPLETE,this.onOutroComplete);
			}
		}
		private function removeListeners($target:* = null):void
		{
			if ($target != null) {
				$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onInitializeComplete);
				$target.removeEventListener(ViewEvent.INTRO_COMPLETE,this.onIntroComplete);
				$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,this.onOutroComplete);
			}
		}
		
		public function toggleMode():void
		{
			this.data.mode = (  this.data.mode != ViewStackData.FORWARD ) ? ViewStackData.FORWARD : ViewStackData.REVERSE;
		}
		/*
		*/
		private function getDetailObject():Object
		{
			var objData:Object = this._objViewBrowser.getSelected();
			objData.index = this._objViewBrowser.selectedIndex;
			return objData;
		}
		/*
		Individual Preloader Handlers
		*/
		private function advance():void
		{
			switch( this.data.mode ) 
			{
				case ViewStackData.FORWARD :
					this.selectNext();
					break;
				case ViewStackData.REVERSE :
					this.selectPrevious();
					break;
			}
		}
		private  function onInitializeComplete($event:ViewEvent):void
		{
			this.call( ViewStack.INTRO );
			this.dispatchEvent( new ViewStackEvent( ViewStackEvent.INITIALIZE_COMPLETE, this, this.getDetailObject() ) );
		}
		private  function onIntroComplete($event:ViewEvent):void
		{
			if (this.data.timerEnabled) this.startTimer();	
			this.dispatchEvent( new ViewStackEvent( ViewStackEvent.INTRO_COMPLETE, this, this.getDetailObject() ) );
		}
		private function onOutroComplete($event:ViewEvent):void
		{
			this.dequeue();
			this.dispatchEvent( new ViewStackEvent( ViewStackEvent.OUTRO_COMPLETE, this, this.getDetailObject() ) );
		}
		private function onTrigger($event:TriggerEvent):void
		{
			this.advance();
		}
		/*
		Property Definitions
		*/
		public function get selectedIndex():uint
		{
			return this._objViewBrowser.selectedIndex;
		}
		public function get selectedItem():*
		{
			return this._objViewBrowser.selectedItem;
		}
		public function get running():Boolean
		{
			return this._objTrigger.running;
		}
	}

}
