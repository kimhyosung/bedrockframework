package com.bedrockframework.plugin.form
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import com.bedrockframework.plugin.event.CheckBoxEvent;
	import com.bedrockframework.plugin.util.ButtonUtil;
	import com.bedrockframework.core.base.MovieClipWidget ;
	
	public class CheckBox extends MovieClipWidget{
		// Varibales
		private var _bolStatus:Boolean;
		
		// Constructor
		public function CheckBox()
		{
			this._bolStatus = false;
			this.setup();
		}
		// Setup press event
		private function setup():void
		{
			ButtonUtil.addListeners(this,{down:this.toggleCheckBox});
		}
		// Check on
		public function check():void
		{
			this._bolStatus = true;
			this.gotoAndStop(2);
			this.dispatchEvent(new CheckBoxEvent(CheckBoxEvent.CHECK, this));
		}
		// Check off
		public function uncheck():void
		{
			this._bolStatus = false;
			this.gotoAndStop(1);
			this.dispatchEvent(new CheckBoxEvent(CheckBoxEvent.UNCHECK, this));
		}
		/*
		Toggle check/uncheck
		*/
		private function toggleCheckBox($event:Event):void
		{
			if (!this._bolStatus) {
				this.check();
			} else {
				this.uncheck();
			}
		}
		// getters
		public function get _status():Boolean
		{
			return this._bolStatus;
		}
	}
}
