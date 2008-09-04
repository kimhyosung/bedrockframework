package com.autumntactics.form
{
	import flash.events.MouseEvent;
	import flash.events.Event;

	//import com.autumntactics.events.RadioEvent;
	import com.autumntactics.util.ButtonUtil;
	import com.autumntactics.bedrock.base.DispatcherWidget;
	import com.autumntactics.storage.ArrayCollection;

	public class Radio extends DispatcherWidget
	{
		// Variables
		private var arrRadioCollection:Array;
		private var numLength:Number;
		private var numSelected:int;

		// Constructor
		public function Radio()
		{
			this.numLength = 0;
			this.arrRadioCollection = new ArrayCollection();
		}
		// Add new radio button
		public function addButton($mcButton):void
		{
			if ($mcButton) {
				this.arrRadioCollection.push($mcButton);
				this.numLength = this.arrRadioCollection.length-1;
				$mcButton.index = this.numLength;

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
			this.arrRadioCollection[0].play();
			this.manageSelection();
		}
		// Manage selection enable
		private function manageSelection():void
		{
			for (var a:int = 0; a < this.arrRadioCollection.length; a++) {
				if (this._selected != a) {
					this.arrRadioCollection[a].gotoAndStop(1);
					ButtonUtil.addListeners(this.arrRadioCollection[a],{down:this.select});
				} else {
					ButtonUtil.removeListeners(this.arrRadioCollection[a],{down:this.select});
				}
			}
		}
		// Getters and setters
		public function set _selected($numIndex:int):void
		{
			this.numSelected = $numIndex;
		}
		public function get _selected():int
		{
			return this.numSelected;
		}
	}
}

