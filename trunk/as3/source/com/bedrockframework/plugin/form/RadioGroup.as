package com.bedrockframework.plugin.form
{
	// Alex, you need to clean this up
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.util.ArrayUtil;
	import com.bedrockframework.plugin.util.ButtonUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.bedrockframework.plugin.event.RadioEvent;
	
	public class RadioGroup extends DispatcherWidget
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
		public function RadioGroup()
		{
			this._arrRadios = new Array();
		}
		/**
		 * Add a new button to the radio button array.
	 	*/
		public function addButton($radio:RadioButton, $data:Object):void
		{
			$radio.id = this._arrRadios.length;
			$radio.group = this;
			$radio.data = $data;
			this._arrRadios.push({radio:$radio, data:$data});			
		}
		/*
		 * Manages the states of the radio buttons
	 	*/
		private function manageSelection():void
		{
			var numLength:int = this._arrRadios.length;
			for (var i:int = 0 ; i < numLength; i++) {
				if (i == this.selected) {
					this.getRadioButton(i).select();
				} else {
					this.getRadioButton(i).deselect();
				}
			}
		}
		/*
		Get Radio Button
		*/
		private function getRadioButton($id:Number):RadioButton
		{
			return this._arrRadios[$id].radio;
		}
		/*
		 * Property Definitions
	 	*/
	 	/**
		 * Returns the index of the selected radio button.
	 	*/
		public function set selected($id:int):void
		{
			this._numSelected = $id;
			this.manageSelection();
			this.dispatchEvent(new RadioEvent(RadioEvent.SELECTED, this, this._arrRadios[$id].data));
		}
		public function get selected():int
		{
			return this._numSelected;
		}
	}
}

