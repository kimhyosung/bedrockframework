package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.core.base.SpriteWidget;
	import com.bedrockframework.engine.event.ViewEvent;
	import com.bedrockframework.engine.view.IView;
	import com.bedrockframework.engine.view.View;
	import com.bedrockframework.plugin.data.ViewSequencerData;
	import com.bedrockframework.plugin.event.ViewSequencerEvent;
	import com.bedrockframework.plugin.storage.ArrayBrowser;
	
	import flash.display.Sprite;

	public class ViewSequencer extends SpriteWidget
	{

		private var _objContainer:Sprite;
		private var _objCurrent:View;
		private var _objArrayBrowser:ArrayBrowser;
		private var _bolAutoPilot:Boolean;
		private var _bolRunning:Boolean;
		private var _strDirection:String;

		public function ViewSequencer()
		{
			this._bolRunning = false;
			this._objArrayBrowser = new ArrayBrowser();
		}
		public function initialize($data:ViewSequencerData):void
		{
			this._objArrayBrowser.data = $data.sequence;
			this._objArrayBrowser.setSelected($data.startAt);
			this._objArrayBrowser.wrapIndex = $data.wrap;
			this._strDirection = $data.direction;
			this.setContainer($data.container);
			this.start();
		}
		/*
		Start the sequence
		*/
		public function start():void
		{
			this._bolRunning = true;
			this.setupView(this._objArrayBrowser.selectedItem)
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
		private function setupView($view:*):void{
			this._objCurrent = $view;
			this._objContainer.addChild(this._objCurrent)
			this.addListeners(this._objCurrent);
			IView(this._objCurrent).initialize();
		}
		/*
		Show View
		*/
		public function show($index:Number):void
		{
			this.setupView(this._objArrayBrowser.setSelected($index))
		}
		/*
		External Next/ Previous
		*/
		public function next():void
		{
			if (this._objArrayBrowser.hasNext()){
				this.direction = ViewSequencerData.FORWARD;
				IView(this._objCurrent).outro();
			}			
		}
		public function previous():void
		{
			if (this._objArrayBrowser.hasPrevious()){
				this.direction = ViewSequencerData.REVERSE;
				IView(this._objCurrent).outro();
			}
		}
		/*
		Internal Next/ Previous
		*/
		private function nextInternal():void
		{
			if(this._bolRunning){
				if (this._objArrayBrowser.hasNext()){
					this.setupView(this._objArrayBrowser.selectNext())
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
					this.setupView(this._objArrayBrowser.selectPrevious())
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
				if (this._strDirection == ViewSequencerData.FORWARD) {
					this._strDirection = ViewSequencerData.REVERSE;
				} else {
					this._strDirection = ViewSequencerData.FORWARD;
				}
			} else {
				this._strDirection = $status;
			}		
			return this._strDirection;
		}
		/*
		Manager Event Listening
		*/
		private function addListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,this.onIntroComplete);
			$target.addEventListener(ViewEvent.OUTRO_COMPLETE,this.onOutroComplete);
		}
		private function removeListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,this.onInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,this.onIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,this.onOutroComplete);
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
			this._objContainer.removeChild(this._objCurrent);
			if (this._strDirection == ViewSequencerData.FORWARD)		{
				this.nextInternal();
			}else{
				this.previousInternal();
			}
			this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.OUTRO_COMPLETE, this, this.getDetailObject()))
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
			this._strDirection = $direction;
		}
		public function get direction():String
		{
			return this._strDirection;
		}
		public function get running():Boolean
		{
			return this._bolRunning;
		}
	}

}
