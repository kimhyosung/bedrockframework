package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.data.TextDisplayData;
	import com.bedrockframework.plugin.util.VariableUtil;
	
	import flash.text.TextField;

	public class TextDisplay extends MovieClipWidget
	{
		/*
		Variable Declarations
		*/
		public var textField:TextField;
		private var _txtDisplay:TextField;
		public var data:TextDisplayData;
		/*
		Constructor
		*/
		public function TextDisplay($silenceConstruction:Boolean=false)
		{
			super( true );
			this.createDummyTextField();
			this.mouseChildren = this.mouseEnabled = false;
		}
		/*
		Basic Functions
		*/
		public function initialize( $data:TextDisplayData ):void
		{
			this.data =$data;
			this.populate( this.data.text );
			if ( this.data.autoPopulate ) BedrockDispatcher.addEventListener( BedrockEvent.LOCALE_LOADED, this.onLocaleLoaded );
		}
		
		private function createDummyTextField():void
		{
			this.textField = new TextField;
			this.textField.border = true;
			this.textField.selectable = false;
		}
		
		private function createTextField( $text:String ):void
		{
			this._txtDisplay = new TextField;
			VariableUtil.mimicObject(this._txtDisplay, this.textField);
			this.mouseChildren = this._txtDisplay.selectable;
			this.addChild( this._txtDisplay );
		}
		private function destroyTextField():void
		{
			if ( this._txtDisplay != null && this.contains( this._txtDisplay ) ) this.removeChild( this._txtDisplay );
			this._txtDisplay = null;
		}
		/*
		Creation Functions
		*/
		public function populate( $text:String ):void
		{
			this.destroyTextField();
			this.createTextField( $text );
			
			this.applyText( $text );
			this.applyData();
		}
		private function applyText( $text:String ):void
		{
			this.textField.text = $text;
			this._txtDisplay.text = $text;
		}
		private function applyData():void
		{
			this._txtDisplay.width = this.data.width;
			this._txtDisplay.height = this.data.height;
			this._txtDisplay.styleSheet = this.data.styleSheet;
		}
		/*
		Event Handlers
	 	*/
	 	private function onLocaleLoaded( $event:BedrockEvent ):void
		{
			this.populate( BedrockEngine.resourceManager.getResource( this.data.resourceKey, this.data.resourceGroup ) );
		}
		/*
		Property Definitions
	 	*/
	}
}