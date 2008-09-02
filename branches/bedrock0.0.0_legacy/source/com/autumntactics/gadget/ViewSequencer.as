package com.builtonbedrock.gadget
{
	import com.builtonbedrock.data.ViewSequencerData;
	import com.builtonbedrock.events.ViewSequencerEvent;
	import com.builtonbedrock.bedrock.base.DispatcherWidget;
	import com.builtonbedrock.bedrock.events.ViewEvent;
	import com.builtonbedrock.bedrock.view.IView;
	import com.builtonbedrock.bedrock.view.View;
	import com.builtonbedrock.storage.ArrayBrowser;
	
	import flash.display.Sprite;

	public class ViewSequencer extends DispatcherWidget
	{

		private var objContainer:Sprite;
		private var objCurrent:View;
		private var objArrayBrowser:ArrayBrowser;
		private var bolAutoPilot:Boolean;
		private var bolRunning:Boolean;
		private var strDirection:String;

		public function ViewSequencer()
		{
			this.bolRunning = false;
			this.objArrayBrowser = new ArrayBrowser();
		}
		public function initialize($data:ViewSequencerData):void
		{
			this.objArrayBrowser.data = $data.sequence;
			this.objArrayBrowser.wrapIndex = $data.wrap;
			this.strDirection = $data.direction;
			this.setContainer($data.container);
			this.start();
		}
		/*
		Start the sequence
		*/
		public function start():void
		{
			this.bolRunning = true;
			this.setupView(this.objArrayBrowser.selectedItem)
		}
		public function stop():void
		{
			this.bolRunning = false;
			IView(this.objCurrent).outro();
		}
		/*
		Set the container when the views will be showing up
		*/
		public function setContainer($container:Sprite):void{
				this.objContainer=$container;
		}
		/*
		
		*/
		private function setupView($view:*):void{
			this.objCurrent = $view;
			this.objContainer.addChild(this.objCurrent)
			this.addListeners(this.objCurrent);
			IView(this.objCurrent).initialize();
		}
		/*
		Show View
		*/
		public function show($index:Number):void
		{
			this.setupView(this.objArrayBrowser.setSelected($index))
		}
		/*
		External Next/ Previous
		*/
		public function next():void
		{
			if (this.objArrayBrowser.hasNext()){
				this.direction = ViewSequencerData.FORWARD;
				IView(this.objCurrent).outro();
			}			
		}
		public function previous():void
		{
			if (this.objArrayBrowser.hasPrevious()){
				this.direction = ViewSequencerData.REVERSE;
				IView(this.objCurrent).outro();
			}
		}
		/*
		Internal Next/ Previous
		*/
		private function nextInternal():void
		{
			if(this.bolRunning){
				if (this.objArrayBrowser.hasNext()){
					this.setupView(this.objArrayBrowser.selectNext())
					this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.NEXT, this, this.getDetailObject()))
				}else{
					this.status("Hit Ending")
					this.dispatchEvent(new ViewSequencerEvent(ViewSequencerEvent.ENDING, this, this.getDetailObject()))
				}
			}		
		}
		private function previousInternal():void
		{
			if(this.bolRunning){
				if (this.objArrayBrowser.hasPrevious()){
					this.setupView(this.objArrayBrowser.selectPrevious())
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
				if (this.strDirection == ViewSequencerData.FORWARD) {
					this.strDirection = ViewSequencerData.REVERSE;
				} else {
					this.strDirection = ViewSequencerData.FORWARD;
				}
			} else {
				this.strDirection = $status;
			}		
			return this.strDirection;
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
			return {index:this.objArrayBrowser.selectedIndex, view:this.objArrayBrowser.selectedItem};
		}
		/*
		Individual Preloader Handlers
		*/
		
		private  function onInitializeComplete($event:ViewEvent):void
		{
			IView(this.objCurrent).intro();
		}
		private  function onIntroComplete($event:ViewEvent):void
		{
			// do something
		}
		private function onOutroComplete($event:ViewEvent):void
		{
			this.removeListeners(this.objCurrent);
			this.objContainer.removeChild(this.objCurrent);
			if (this.strDirection == ViewSequencerData.FORWARD)		{
				this.nextInternal();
			}else{
				this.previousInternal();
			}			
		}
		/*
		Property Definitions
		*/
		public function set direction($direction:String):void
		{
			this.strDirection = $direction;
		}
		public function get direction():String
		{
			return this.strDirection;
		}
		public function get running():Boolean
		{
			return this.bolRunning;
		}
	}

}
