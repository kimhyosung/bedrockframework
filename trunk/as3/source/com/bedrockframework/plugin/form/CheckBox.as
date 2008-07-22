package com.bedrockframework.plugin.form
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import com.bedrockframework.plugin.event.CheckBoxEvent;
	import com.bedrockframework.plugin.util.ButtonUtil;
	import com.bedrockframework.core.base.MovieClipWidget ;
	
	public class CheckBox extends MovieClipWidget
	{
		/*
		* Variable Declarations
		*/		
		private var _bolSelected:Boolean;

		/*
Constructor
		*/
		public function CheckBox()
		{
			this._bolSelected = false;
			this.setup();
		}
		/*
		* Setup mouse events
	 	*/
		private function setup():void
		{
			ButtonUtil.addListeners(this,{down:this.onClicked});
		}
		/**
		* Sets the check box status to selected and changes it's appearance
	 	*/
		public function check():void
		{
			this._bolSelected = true;
			this.gotoAndStop(2);
			this.dispatchEvent(new CheckBoxEvent(CheckBoxEvent.CHECK, this));
		}
		/*
		* Sets the check box status to deselected and changes it's appearance
	 	*/
		public function uncheck():void
		{
			this._bolSelected = false;
			this.gotoAndStop(1);
			this.dispatchEvent(new CheckBoxEvent(CheckBoxEvent.UNCHECK, this));
		}
		/*
		* Event Handlers
	 	*/
		private function onClicked($event:Event):void
		{
			if (!this._bolSelected) {
				this.check();
			} else {
				this.uncheck();
			}
		}
		/*
		* Property Definitions
	 	*/
		public function get selected():Boolean
		{
			return this._bolSelected;
		}
	}
}
