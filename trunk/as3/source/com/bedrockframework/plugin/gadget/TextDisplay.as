package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
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
			this.populate( this.data.text );
			if ( this.data.autoPopulate ) BedrockDispatcher.addEventListener( BedrockEvent.LOCALE_LOADED, this.onLocaleLoaded );
		}
		
		/*
		Creation Functions
		*/
		public function populate( $text:String ):void
		{
			this.createMultiLine( $text );
		}
		/*
		Paragraph
		*/
		private function createMultiLine( $text:String ):void
		{
			var objSpanElement:SpanElement = new SpanElement();
			objSpanElement.text = $text;
			
			var objParagraphElement:ParagraphElement = new ParagraphElement();
			objParagraphElement.addChildAt(0, objSpanElement);
			
			var objTextFlow:TextFlow = new TextFlow();
			objTextFlow.hostFormat = this.createCustomFormat();
			objTextFlow.addChildAt(0, objParagraphElement);
			
			objTextFlow.flowComposer.addController(new ContainerController(this, this.data.width, this.data.height));
			objTextFlow.flowComposer.updateAllControllers();
		}
		
		private function createCustomFormat():TextLayoutFormat
		{
			if ( this.data.styleName != null ) {
				var objStyle:Object = BedrockEngine.styleManager.getStyleAsObject( this.data.styleName );
				var objFormat:TextLayoutFormat = new TextLayoutFormat();
				
				for (var s:String in objStyle) {
					objFormat[ s ] = VariableUtil.sanitize( objStyle[ s ] );
				}
				
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