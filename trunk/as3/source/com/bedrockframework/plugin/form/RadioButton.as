package com.bedrockframework.plugin.form
{
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.plugin.data.RadioButtonData;
	import com.bedrockframework.plugin.util.ButtonUtil;
	import com.bedrockframework.plugin.util.MovieClipUtil;
	
	import flash.events.MouseEvent;

	public class RadioButton extends MovieClipWidget
	{
		/*
		Variable Declarations
		*/
		
		private var _objData:RadioButtonData;
		public var group:RadioGroup;
		public var index:uint;
		public var label:*;
		/*
		Constructor
		*/
		public function RadioButton()
		{
			this.stop();
			ButtonUtil.addListeners(this, {down:this.onMouseDownHandler, up:this.onMouseUpHandler, over:this.onRollOverHandler, out:this.onRollOutHandler});
		}
		/*
		Populate
		*/
		public function populate( $label:String ):void
		{
			this.label.htmlText = $label;
		}
		/*
		Select/ Deselect
		*/
		public function select():void
		{
			this.mouseEnabled = false;
			this.changeState("SELECTED");
		}
		public function deselect():void
		{
			this.mouseEnabled = true;
			this.changeState("NORMAL");
		}
		/*
		Change State
		*/
		private function changeState($state:String):void
		{
			this.gotoAndStop( MovieClipUtil.getFrame(this, $state) );
		}
		/*
		Event Handlers
	 	*/
		private function onMouseDownHandler($event:MouseEvent):void
		{
			this.group.selectWithIndex( this.index );
		}
		private function onMouseUpHandler($event:MouseEvent):void
		{
			this.changeState( "UP" );
		}
		private function onRollOverHandler($event:MouseEvent):void
		{
			this.changeState( "ROLL_OVER" );
		}
		private function onRollOutHandler($event:MouseEvent):void
		{
			this.changeState( "ROLL_OUT" );
		}
		/*
		Property Definitions
	 	*/
	 	public function set data($data:RadioButtonData):void
	 	{
	 		this._objData = $data;
	 		if ( this.label != null && this.data.autoPopulate ) {
	 			this.label.htmlText = $data.label;
	 		}
	 	}
	 	public function get data():RadioButtonData
	 	{
	 		return this._objData;
	 	}
	 	
	}
}