package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.core.base.SpriteWidget;
	import com.bedrockframework.plugin.data.ViewSequencerData;
	import com.bedrockframework.plugin.event.TriggerEvent;
	import com.bedrockframework.plugin.event.ViewEvent;
	import com.bedrockframework.plugin.event.ViewSequencerEvent;
	import com.bedrockframework.plugin.storage.ArrayBrowser;
	import com.bedrockframework.plugin.timer.IntervalTrigger;
	import com.bedrockframework.plugin.view.IView;
	import com.bedrockframework.plugin.view.View;
	
	import flash.display.Sprite;

	public class ViewSequencer extends SpriteWidget
	{
		/*
		Variable Declarations
		*/
		private var _objContainer:Sprite;
		private var _objCurrent:View;
		private var _objArrayBrowser:ArrayBrowser;
		private var _bolAutoPilot:Boolean;
		private var _bolRunning:Boolean;
		private var _strDirection:String;
		private var _objData:ViewSequencerData;
		private var _objTrigger:IntervalTrigger;
		/*
		Constructor
		*/
		public function ViewSequencer()
		{
			this._bolRunning = false;
			this._objArrayBrowser = new ArrayBrowser;
		}
		public function initialize($data:ViewSequencerData):void
		{
			this.clear();
			
			this._objData = $data;
			this._objArrayBrowser.data = this._objData.sequence;
			this._objArrayBrowser.setSelected(this._objData.startAt);
			this._objArrayBrowser.wrapIndex = this._objData.wrap;
			this._strDirection = this._objData.direction;
			this.setContainer(this._objData.container);
			
			if (this._objData.autoStart) this.start();
		}
		private function createTrigger():void
		{
			this._objTrigger = new IntervalTrigger;
			this._objTrigger.silenceLogging = true;
		}
		public function clear():void
		{
			this.removeListeners(this._objCurrent);
		}
		/*
		Start the sequence
		*/
		public function start():void
		{
			this._bolRunning = true;
			this.setupView()
		}
		public function stop():void
		{
			this._bolRunning = false;
			IView(this._objCurrent).outro();
		}
		/*
		Set the container when the views will be showing up
		*/
		public function setContainer($container:Sprite =null):void
		{
				this._objContainer=$container || this;
		}
		/*
		
		*/
		private function setupView():void{
			this._objCurrent = this._objArrayBrowser.selectedItem.view;
			if (this._objData.treatAsChildren) {
				this._objContainer.addChild(this._objCurrent);
			}
			this.addListeners(this._objCurrent);
			if (this._objData.autoInitialize) {
				IView(this._objCurrent).initialize(this._objArrayBrowser.selectedItem.initialize);
			} else {
				IView(this._objCurrent).intro(this._objArrayBrowser.selectedItem.intro);
			}
		}
		/*
		Show View
		*/
		public function show($index:Number):void
		{
			this._objArrayBrowser.setSelected($index);
			this.setupView()
		}
		/*
		External Next/ Previous
		*/
		public function next():void
		{
			if (this._objArrayBrowser.hasNext()){
				this.direction = ViewSequencerData.FORWARD;
				IView(this._objCurrent).outro(this._objArrayBrowser.selectedItem.outro);
			}			
		}
		public function previous():void
		{
			if (this._objArrayBrowser.hasPrevious()){
				this.direction = ViewSequencerData.REVERSE;
				IView(this._objCurrent).outro(this._objArrayBrowser.selectedItem.outro);
			}
		}
		/*
		Internal Next/ Previous
		*/
		private function followInternalSequence():void
		{
			if (this._objData.direction == ViewSequencerData.FORWARD)		{
				this.nextInternal();
			}else{
				this.previousInternal();
			}
		}
		private function nextInternal():void
		{
			if(this._bolRunning){
				if (this._objArrayBrowser.hasNext()){
					this._objArrayBrowser.selectNext()
					this.setupView()
					this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.NEXT, this, this.getDetailObject()))
				}else{
					this.status("Hit Ending")
					this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.ENDING, this, this.getDetailObject()))
				}
			}		
		}
		private function previousInternal():void
		{
			if(this._bolRunning){
				if (this._objArrayBrowser.hasPrevious()){
					this._objArrayBrowser.selectPrevious()
					this.setupView()
					this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.PREVIOUS, this, this.getDetailObject()))
				}else{
					this.status("Hit Beginning")
					this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.BEGINNING, this, this.getDetailObject()))
				}	
			}			
		}
		/*
		Change Sequence Direction
		*/
		public function toggleDirection($status:String = null):String
		{
			if ($status == null) {
				if (this._objData.direction == ViewSequencerData.FORWARD) {
					this._objData.direction = ViewSequencerData.REVERSE;
				} else {
					this._objData.direction = ViewSequencerData.FORWARD;
				}
			} else {
				this._objData.direction = $status;
			}		
			return this._objData.direction;
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
			IView(this._objCurrent).intro();
			this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.INITIALIZE_COMPLETE, this, this.getDetailObject()))
		}
		private  function onIntroComplete($event:ViewEvent):void
		{
			// do something
			this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.INTRO_COMPLETE, this, this.getDetailObject()))
		}
		private function onOutroComplete($event:ViewEvent):void
		{
			this.removeListeners(this._objCurrent);
			if (this._objData.treatAsChildren) {
				this._objContainer.removeChild(this._objCurrent);
			}
			this.followInternalSequence();
			this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.OUTRO_COMPLETE, this, this.getDetailObject()))
		}
		private function onTrigger($event:TriggerEvent):void
		{
			this.followInternalSequence();
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
			this._objData.direction = $direction;
		}
		public function get direction():String
		{
			return this._objData.direction;
		}
		public function get running():Boolean
		{
			return this._bolRunning;
		}
	}

}
