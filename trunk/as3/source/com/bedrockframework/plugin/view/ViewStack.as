package com.bedrockframework.plugin.view
{
	import com.bedrockframework.core.base.SpriteWidget;
	import com.bedrockframework.plugin.data.ViewStackData;
	import com.bedrockframework.plugin.event.SequencerEvent;
	import com.bedrockframework.plugin.event.TriggerEvent;
	import com.bedrockframework.plugin.event.ViewEvent;
	import com.bedrockframework.plugin.storage.ArrayBrowser;
	import com.bedrockframework.plugin.timer.TimeoutTrigger;
	
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
		
		private var _bolOverride:Boolean;
		private var _bolAutoPilot:Boolean;
		private var _bolRunning:Boolean;
		/*
		Constructor
		*/
		public function ViewStack()
		{
			this._bolRunning = false;
			this._objArrayBrowser = new ArrayBrowser;
		}
		public function initialize($data:ViewStackData):void
		{
			this.clear();
			
			this.data = $data;
			this._objArrayBrowser.data = this.data.sequence;
			this._objArrayBrowser.setSelected(this.data.startAt);
			this._objArrayBrowser.wrapIndex = this.data.wrap;
			this.setContainer(this.data.container);
			
			if (this.data.autoStart) this.startSequence();
			this.createTrigger(); 
		}
		private function createTrigger():void
		{
			this._objTrigger = new TimeoutTrigger;
			this._objTrigger.addEventListener( TriggerEvent.TRIGGER, this.onTrigger );
			this._objTrigger.silenceLogging = true;
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
		Start the sequence
		*/
		public function startSequence():void
		{
			this._bolRunning = true;
			this.prepare()
		}
		public function stopSequence():void
		{
			this._bolRunning = false;
			this.call(ViewStackData.OUTRO);
		}
		/*
		Timer Functions
		*/
		public function startTimer($time:Number = 0):void
		{
			this.data.timerEnabled = true;
			this._objTrigger.start($time || this.data.time);
		}
		public function stopTimer():void
		{
			this.data.timerEnabled = false;
			this._objTrigger.stop();
		}
		/*
		Set the container where the views will be showing up
		*/
		public function setContainer($container:Sprite =null):void
		{
			this._objContainer=$container || this;
		}
		/*
		
		*/
		private function prepare():void
		{
			this._objPreviousItem = this._objCurrentItem;
			this._objCurrentItem = this._objArrayBrowser.selectedItem;
			if (this.data.addAsChildren) {
				this._objContainer.addChild(this._objCurrentItem.view);
			}
			this.addListeners(this._objCurrentItem.view);
			if (this.data.autoInitialize) {
				this.call(ViewStackData.INITIALIZE);
			} else {
				this.call(ViewStackData.INTRO);
			}
			this.dispatchEvent(new SequencerEvent(SequencerEvent.SHOW, this, this.getDetailObject()));
		}
		/*
		Show View
		*/
		public function show($index:Number):void
		{
			this._bolOverride = true;
			this.stopTimer();
			this._objArrayBrowser.setSelected($index);
			this.followInternalSequence();
		}
		/*
		External Next/ Previous
		*/
		public function next():void
		{
			if (this._objArrayBrowser.hasNext()){
				this.direction = ViewStackData.FORWARD;
				this.call(ViewStackData.OUTRO);
			}			
		}
		public function previous():void
		{
			if (this._objArrayBrowser.hasPrevious()){
				this.direction = ViewStackData.REVERSE;
				this.call(ViewStackData.OUTRO);
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
		private function callback($type:String, $item:Object):void
		{
			if ($item != null) {
				var objData:Object;
				switch ($type) {
					case ViewStackData.INITIALIZE :
						objData = $item.initialize;
						break;
					case ViewStackData.INTRO :
						objData = $item.intro;
						break;
					case ViewStackData.OUTRO :
						objData = $item.outro;
						break;
				}
			
				if (objData != null && objData.callback != null) {
					objData.callback.apply(this, objData.callbackParams);
				}
			}
		}
		/*
		Internal Next/ Previous
		*/
		private function followInternalSequence():void
		{
			this.removeListeners(this._objCurrentItem.view);
			if (this.data.addAsChildren) {
				this._objContainer.removeChild(this._objCurrentItem.view);
			}
			if (!this._bolOverride) {
				if (this.data.direction == ViewStackData.FORWARD)		{
					this.nextInternal();
				}else{
					this.previousInternal();
				}
			} else {
				this._bolOverride = false;
				this.prepare();
			}
		}
		private function nextInternal():void
		{
			if(this._bolRunning){
				if (this._objArrayBrowser.hasNext()) {
					this._objArrayBrowser.selectNext();
					this.prepare();
					this.dispatchEvent(new SequencerEvent(SequencerEvent.NEXT, this, this.getDetailObject()))
				}else{
					this.status("Hit Ending");
					this.dispatchEvent(new SequencerEvent(SequencerEvent.ENDING, this, this.getDetailObject()))
				}
			}		
		}
		private function previousInternal():void
		{
			if(this._bolRunning){
				if (this._objArrayBrowser.hasPrevious()) {
					this._objArrayBrowser.selectPrevious();
					this.prepare();
					this.dispatchEvent(new SequencerEvent(SequencerEvent.PREVIOUS, this, this.getDetailObject()))
				}else{
					this.status("Hit Beginning");
					this.dispatchEvent(new SequencerEvent(SequencerEvent.BEGINNING, this, this.getDetailObject()))
				}	
			}			
		}
		/*
		Change Sequence Direction
		*/
		public function toggleDirection($status:String = null):String
		{
			if ($status == null) {
				if (this.data.direction == ViewStackData.FORWARD) {
					this.data.direction = ViewStackData.REVERSE;
				} else {
					this.data.direction = ViewStackData.FORWARD;
				}
			} else {
				this.data.direction = $status;
			}		
			return this.data.direction;
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
		
		
		/*
		*/
		private function getDetailObject():Object
		{
			return {index:this._objArrayBrowser.selectedIndex, view:this._objArrayBrowser.selectedItem};
		}
		/*
		Individual Preloader Handlers
		*/
		
		private  function onInitializeComplete($event:ViewEvent):void
		{
			this.callback(ViewStackData.INITIALIZE, this._objCurrentItem);
			this.call(ViewStackData.INTRO);
			this.dispatchEvent(new SequencerEvent(SequencerEvent.INITIALIZE_COMPLETE, this, this.getDetailObject()))
		}
		private  function onIntroComplete($event:ViewEvent):void
		{
			// do something
			this.callback(ViewStackData.INTRO, this._objCurrentItem);
			if (this.data.timerEnabled) this.startTimer(); 			
			this.dispatchEvent(new SequencerEvent(SequencerEvent.INTRO_COMPLETE, this, this.getDetailObject()))
		}
		private function onOutroComplete($event:ViewEvent):void
		{
			this.callback(ViewStackData.OUTRO, this._objPreviousItem);
			this.followInternalSequence();
			this.dispatchEvent(new SequencerEvent(SequencerEvent.OUTRO_COMPLETE, this, this.getDetailObject()))
		}
		private function onTrigger($event:TriggerEvent):void
		{
			this.call(ViewStackData.OUTRO);
		}
		/*
		Property Definitions
		*/
		public function get currentView():*
		{
			return this._objArrayBrowser.getSelected();
		}
		public function set direction($direction:String):void
		{
			this.data.direction = $direction;
		}
		public function get direction():String
		{
			return this.data.direction;
		}
		public function get running():Boolean
		{
			return this._bolRunning;
		}
	}

}
