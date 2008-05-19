package com.autumntactics.form
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import com.autumntactics.events.CheckBoxEvent;
	import com.autumntactics.util.ButtonUtil;
	import com.autumntactics.bedrock.base.MovieClipWidget ;
	
	public class CheckBox extends MovieClipWidget{
		// Varibales
		private var bolStatus:Boolean;
		
		// Constructor
		public function CheckBox()
		{
			this.bolStatus = false;
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
			this.bolStatus = true;
			this.gotoAndStop(2);
			this.dispatchEvent(new CheckBoxEvent(CheckBoxEvent.CHECK, this));
		}
		// Check off
		public function uncheck():void
		{
			this.bolStatus = false;
			this.gotoAndStop(1);
			this.dispatchEvent(new CheckBoxEvent(CheckBoxEvent.UNCHECK, this));
		}
		// Toggle check/uncheck
		private function toggleCheckBox($event:Event):void
		{
			if (!this.bolStatus) {
				this.check();
			} else {
				this.uncheck();
			}
		}
		// getters
		public function get _status():Boolean
		{
			return this.bolStatus;
		}
	}
}
