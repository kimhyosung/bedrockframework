package com.bedrockframework.plugin.form
{
	import com.bedrockframework.core.base.MovieClipWidget;
	import flash.events.MouseEvent;
	import com.bedrockframework.plugin.util.ButtonUtil;
	import com.bedrockframework.plugin.util.MovieClipUtil;
	import flash.text.TextField;

	public class RadioButton extends MovieClipWidget
	{
		/*
		Variable Declarations
		*/
		
		private var _objData:Object;
		public var group:RadioGroup;
		public var id:int;
		public var label:TextField;
		/*
		Constructor
		*/
		public function RadioButton()
		{
			this.stop();
			ButtonUtil.addListeners(this, {down:this.onMouseDownHandler, up:this.onMouseUpHandler, over:this.onRollOverHandler, out:this.onRollOutHandler});
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
			this.gotoAndStop(MovieClipUtil.getFrame(this, $state));
		}
		/*
		Event Handlers
	 	*/
		private function onMouseDownHandler($event:MouseEvent):void
		{
			this.group.selected = this.id;
		}
		private function onMouseUpHandler($event:MouseEvent):void
		{
			this.changeState("UP");
		}
		private function onRollOverHandler($event:MouseEvent):void
		{
			this.changeState("ROLL_OVER");
		}
		private function onRollOutHandler($event:MouseEvent):void
		{
			this.changeState("ROLL_OUT");
		}
		/*
		Property Definitions
	 	*/
	 	public function set data($data:Object):void
	 	{
	 		this._objData = $data;
	 		if ( this.label != null ) this.label.htmlText = $data.label;
	 	}
	 	public function get data():Object
	 	{
	 		return this._objData;
	 	}
	 	
	}
}