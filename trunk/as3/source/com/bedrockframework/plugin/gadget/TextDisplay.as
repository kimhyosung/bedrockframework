package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.data.TextDisplayData;
	import com.bedrockframework.plugin.util.VariableUtil;
	
	import flash.text.engine.FontLookup;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextLayoutFormat;

	public class TextDisplay extends MovieClipWidget
	{
		/*
		Variable Declarations
		*/
		public var data:TextDisplayData;
		
		private var _objSpanElement:SpanElement;
		private var _objParagraphElement:ParagraphElement;
		private var _objTextFlow:TextFlow;
		
		private var _bolCreated:Boolean;
		/*
		Constructor
		*/
		public function TextDisplay()
		{
			super( false );
			this.mouseChildren = this.mouseEnabled = false;
		}
		/*
		Basic Functions
		*/
		public function initialize( $data:TextDisplayData ):void
		{
			this.data =$data;
			this.createMultiLine();
			this.populate( this.data.text );
			if ( this.data.autoPopulate ) BedrockDispatcher.addEventListener( BedrockEvent.LOCALE_LOADED, this.onLocaleLoaded );
		}
		
		/*
		Creation Functions
		*/
		public function populate( $text:String ):void
		{
			this._objSpanElement.text = $text;
			this._objTextFlow.flowComposer.updateAllControllers();
		}
		/*
		Paragraph
		*/
		private function createMultiLine():void
		{
			this._objSpanElement = new SpanElement();
			
			this._objParagraphElement = new ParagraphElement;
			this._objParagraphElement.addChild( this._objSpanElement );
			
			this._objTextFlow = new TextFlow();
			this._objTextFlow.hostFormat = this.createCustomFormat();
			this._objTextFlow.addChildAt(0, this._objParagraphElement );
			
			this._objTextFlow.flowComposer.addController(new ContainerController(this, this.data.width, this.data.height));
			this._objTextFlow.flowComposer.updateAllControllers();
		}
		
		
		private function createCustomFormat():TextLayoutFormat
		{
			if ( this.data.styleName != null ) {
				
				if ( this.data.autoStyle ) {
					var objStyle:Object = BedrockEngine.styleManager.getStyleAsObject( this.data.styleName );
					var objFormat:TextLayoutFormat = new TextLayoutFormat();
					for (var s:String in objStyle) {
						objFormat[ s ] = VariableUtil.sanitize( objStyle[ s ] );
					}
				}
				
				if ( this.data.autoLocale ) objFormat.locale = BedrockEngine.config.getAvailableValue( BedrockData.CURRENT_LOCALE );
				objFormat.fontLookup = FontLookup.EMBEDDED_CFF;
				objFormat.renderingMode = RenderingMode.CFF;
				
				return objFormat;
			} else {
				return this.createDefaultFormat();
			}
		}
		private function createDefaultFormat():TextLayoutFormat
		{
			var objFormat:TextLayoutFormat = new TextLayoutFormat();
			
			objFormat.direction = Direction.LTR;
			objFormat.color = 0xEBEBEB;
			objFormat.fontSize = 12;
			objFormat.fontLookup = FontLookup.EMBEDDED_CFF;
			objFormat.renderingMode = RenderingMode.CFF;
			if ( this.data.autoLocale ) objFormat.locale = BedrockEngine.config.getAvailableValue( BedrockData.CURRENT_LOCALE );
			
			return objFormat;
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