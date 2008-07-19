package com.bedrockframework.plugin.form
{
	// Alex, you need to clean this up
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.util.ButtonUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class Radio extends DispatcherWidget
	{
		/*
		 * Variable Declarations
		*/
		private var _arrRadioCollection:Array;
		private var _numLength:Number;
		private var _numSelected:int;

		/*
		 * Constructor
		*/		
		public function Radio()
		{
			this._numLength = 0;
			this._arrRadioCollection = new Array();
		}
		/**
		 * Add a new button to the radio button array.
		 * This function will also add listeners for mouse events.
	 	*/
		public function addButton($button:DisplayObject):void
		{
			if ($button) {
				this._arrRadioCollection.push($button);
				this._numLength = this._arrRadioCollection.length-1;
				$button.index = this._numLength;

				ButtonUtil.addListeners($button,{down:this.onSelection});
				//
				if ($button.index == 0) {
					this.selectInital();
				}
			}
		}

		/*
		 * Sets the default selection for the radio buttons
	 	*/
		private function selectInital():void
		{
			this.selected = 0;
			this._arrRadioCollection[0].play();
			this.manageSelection();
		}
		/*
		 * Manages the states of the radio buttons
	 	*/
		private function manageSelection():void
		{
			for (var a:int = 0; a < this._arrRadioCollection.length; a++) {
				if (this.selected != a) {
					this._arrRadioCollection[a].gotoAndStop(1);
					ButtonUtil.addListeners(this._arrRadioCollection[a],{down:this.select});
				} else {
					ButtonUtil.removeListeners(this._arrRadioCollection[a],{down:this.select});
				}
			}
		}
		/*
		 * Event Handlers
	 	*/
		public function onSelection($event:MouseEvent):void
		{
			$event.target.play();
			this.selected = $event.target.index;
			this.manageSelection();
		}
		/*
		 * Property Definitions
	 	*/
	 	/**
		 * Returns the index of the selected radio button.
	 	*/
		public function set selected($numIndex:int):void
		{
			this._numSelected = $numIndex;
		}
		public function get selected():int
		{
			return this._numSelected;
		}
	}
}

