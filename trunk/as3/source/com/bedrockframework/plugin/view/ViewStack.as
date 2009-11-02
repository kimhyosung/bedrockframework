package com.bedrockframework.plugin.view
{
	import com.bedrockframework.core.base.SpriteWidget;
	import com.bedrockframework.plugin.data.ViewStackData;
	import com.bedrockframework.plugin.event.TriggerEvent;
	import com.bedrockframework.plugin.event.ViewEvent;
	import com.bedrockframework.plugin.event.ViewStackEvent;
	import com.bedrockframework.plugin.storage.ArrayBrowser;
	import com.bedrockframework.plugin.timer.TimeoutTrigger;
	import com.bedrockframework.plugin.util.ArrayUtil;
	
	import flash.display.Sprite;

	public class ViewStack extends SpriteWidget
	{
		/*
		Variable Declarations
		*/
		public var data:ViewStackData;
		private var _objArrayBrowser:ArrayBrowser;
		private var _objContainer:Sprite;
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
			this._objArrayBrowser = new ArrayBrowser;
		}
		public function initialize($data:ViewStackData):void
		{
			this.clear();
			
			this.data = $data;
			this._objArrayBrowser.data = this.data.stack;
			this._objArrayBrowser.setSelected( this.data.startingIndex );
			this._objArrayBrowser.wrapIndex = this.data.wrap;
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
			this._objPreviousItem = this._objCurrentItem;
			this._objCurrentItem = this._objArrayBrowser.selectedItem;
			if (this.data.addAsChildren) {
				this._objContainer.addChild(this._objCurrentItem.view);
			}
			var objView:View = this._objCurrentItem.view as View;
			this.addListeners(this._objCurrentItem.view);
			if (this.data.autoInitialize ) {
				if ( objView != null && !objView.hasInitialized ) {
					this.call( ViewStackData.INITIALIZE );
				} else {
					this.call( ViewStackData.INTRO );
				}
			} else {
				this.call( ViewStackData.INTRO );
			}
			this.dispatchEvent(new ViewStackEvent(ViewStackEvent.SHOW, this, this.getDetailObject()));
		}
		private function dequeue():void
		{
			this.removeListeners(this._objCurrentItem.view);
			if (this.data.addAsChildren) {
				this._objContainer.removeChild(this._objCurrentItem.view);
			}
			this.queue();
		}
		/*
		Show View
		*/
		public function selectByIndex($index:Number):void
		{
			this.stopTimer();
			this._objArrayBrowser.setSelected($index);
			this.call(ViewStackData.OUTRO);
		}
		public function selectByAlias( $alias:String ):void
		{
			var numIndex:int = ArrayUtil.findIndex( this.data.stack, $alias, "alias" );
			this.selectByIndex( numIndex );
		}
		/*
		External Next/ Previous
		*/
		public function selectNext():void
		{
			if (this._objArrayBrowser.hasNext() || ( !this._objArrayBrowser.hasNext() && this.data.wrap )){
				this._objArrayBrowser.selectNext();
				this.data.mode = ViewStackData.FORWARD;
				this.call(ViewStackData.OUTRO);
			}			
		}
		public function selectPrevious():void
		{
			if (this._objArrayBrowser.hasPrevious() || ( !this._objArrayBrowser.hasPrevious() && this.data.wrap ) ){
				this._objArrayBrowser.selectPrevious();
				this.data.mode = ViewStackData.REVERSE;
				this.call( ViewStackData.OUTRO );
			}
		}
		/*
		Call Functions
	 	*/
	 	private function call($type:String):void
		{
			var objView:IView = IView(this._objCurrentItem.view);
			switch ($type) {
				case ViewStackData.INITIALIZE :
					objView.initialize(this._objCurrentItem.initialize);
					break;
				case ViewStackData.INTRO :
					objView.intro(this._objCurrentItem.intro);
					break;
				case ViewStackData.OUTRO :
					objView.outro(this._objCurrentItem.outro);
					break;
			}
		}
		/*
		Internal Next/ Previous
		*/
		private function sequentialNext():void
		{
			if (this._objArrayBrowser.hasNext()) {
				this._objArrayBrowser.selectNext();
				this.queue();
				this.dispatchEvent(new ViewStackEvent(ViewStackEvent.NEXT, this, this.getDetailObject()))
			}else{
				this.status("Hit Ending");
				this.dispatchEvent(new ViewStackEvent(ViewStackEvent.ENDING, this, this.getDetailObject()))
			}
		}
		private function sequentialPrevious():void
		{
			if (this._objArrayBrowser.hasPrevious()) {
				this._objArrayBrowser.selectPrevious();
				this.queue();
				this.dispatchEvent(new ViewStackEvent(ViewStackEvent.PREVIOUS, this, this.getDetailObject()))
			}else{
				this.status("Hit Beginning");
				this.dispatchEvent(new ViewStackEvent(ViewStackEvent.BEGINNING, this, this.getDetailObject()))
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
			var objData:Object = this._objArrayBrowser.getSelected();
			objData.index = this._objArrayBrowser.selectedIndex;
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
			this.call( ViewStackData.INTRO );
			this.dispatchEvent(new ViewStackEvent(ViewStackEvent.INITIALIZE_COMPLETE, this, this.getDetailObject()))
		}
		private  function onIntroComplete($event:ViewEvent):void
		{
			// do something
			if (this.data.timerEnabled) this.startTimer();	
			this.dispatchEvent(new ViewStackEvent(ViewStackEvent.INTRO_COMPLETE, this, this.getDetailObject()))
		}
		private function onOutroComplete($event:ViewEvent):void
		{
			this.dequeue();
			this.dispatchEvent(new ViewStackEvent(ViewStackEvent.OUTRO_COMPLETE, this, this.getDetailObject()))
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
			return this._objArrayBrowser.selectedIndex;
		}
		public function get selectedItem():*
		{
			return this._objArrayBrowser.selectedItem;
		}
		public function get running():Boolean
		{
			return this._objTrigger.running;
		}
	}

}
