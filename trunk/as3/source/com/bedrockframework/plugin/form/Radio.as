package com.bedrockframework.plugin.form
{
	// alex, you need to clean this up
	import flash.events.MouseEvent;
	import flash.events.Event;

	//import com.bedrockframework.plugin.event.RadioEvent;
	import com.bedrockframework.plugin.util.ButtonUtil;
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.storage.ArrayCollection;

	public class Radio extends DispatcherWidget
	{
		// Variables
		private var _arrRadioCollection:Array;
		private var _numLength:Number;
		private var _numSelected:int;

		// Constructor
		public function Radio()
		{
			this._numLength = 0;
			this._arrRadioCollection = new ArrayCollection();
		}
		// Add new radio button
		public function addButton($mcButton):void
		{
			if ($mcButton) {
				this._arrRadioCollection.push($mcButton);
				this._numLength = this._arrRadioCollection.length-1;
				$mcButton.index = this._numLength;

				ButtonUtil.addListeners($mcButton,{down:this.select});
				//
				if ($mcButton.index == 0) {
					this.selectInital();
				}
			}
		}
		// Select
		public function select($event:Event):void
		{
			$event.target.play();
			this._selected = $event.target.index;
			this.manageSelection();
		}
		// Select initial radio
		private function selectInital():void
		{
			this._selected = 0;
			this._arrRadioCollection[0].play();
			this.manageSelection();
		}
		// Manage selection enable
		private function manageSelection():void
		{
			for (var a:int = 0; a < this._arrRadioCollection.length; a++) {
				if (this._selected != a) {
					this._arrRadioCollection[a].gotoAndStop(1);
					ButtonUtil.addListeners(this._arrRadioCollection[a],{down:this.select});
				} else {
					ButtonUtil.removeListeners(this._arrRadioCollection[a],{down:this.select});
				}
			}
		}
		// Getters and setters
		public function set _selected($numIndex:int):void
		{
			this._numSelected = $numIndex;
		}
		public function get _selected():int
		{
			return this._numSelected;
		}
	}
}

