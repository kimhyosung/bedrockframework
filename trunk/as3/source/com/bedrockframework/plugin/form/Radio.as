package com.bedrockframework.plugin.form
{
	// Alex, you need to clean this up
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.util.ArrayUtil;
	import com.bedrockframework.plugin.util.ButtonUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Radio extends DispatcherWidget
	{
		/*
		 * Variable Declarations
		*/
		private var _arrRadios:Array;
		private var _numLength:Number;
		private var _numSelected:int;

		/*
		 * Constructor
		*/		
		public function Radio()
		{
			this._arrRadios = new Array();
		}
		/**
		 * Add a new button to the radio button array.
		 * This function will also add listeners for mouse events.
	 	*/
		public function addButton($button:Sprite):void
		{
			this._arrRadios.push($button);
			ButtonUtil.addListeners($button,{down:this.onSelection});
		}
		/*
		 * Manages the states of the radio buttons
	 	*/
		private function manageSelection():void
		{
			for (var a:int = 0; a < this._arrRadios.length; a++) {
				if (this.selected != a) {
					this._arrRadios[a].gotoAndStop(1);
					ButtonUtil.addListeners(this._arrRadios[a],{down:this.onSelection});
				} else {
					this._arrRadios[a].play();
					ButtonUtil.removeListeners(this._arrRadios[a],{down:this.onSelection});
				}
			}
		}
		/*
		 * Event Handlers
	 	*/
		public function onSelection($event:MouseEvent):void
		{
			$event.target.play();
			this.selected = ArrayUtil.findIndex(this._arrRadios, $event.target);
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
			this.manageSelection();
		}
		public function get selected():int
		{
			return this._numSelected;
		}
	}
}

