package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.api.IStyleManager;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	
	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	public class StyleManager extends StandardWidget implements IStyleManager
	{
		/*
		Variable Declarations
		*/
		private var _objBackgroundLoader:BackgroundLoader;
		private var _objStyleSheet:StyleSheet;
		/*
		Constructor
		*/
		public function StyleManager()
		{
			this._objStyleSheet = new StyleSheet();
			this.createLoader();
		}
		
		private function createLoader():void
		{
			this._objBackgroundLoader = new BackgroundLoader;
			this._objBackgroundLoader.addEventListener(LoaderEvent.COMPLETE, this.onLoadComplete);
			this._objBackgroundLoader.addEventListener(LoaderEvent.IO_ERROR, this.onLoadError);
			this._objBackgroundLoader.addEventListener(LoaderEvent.SECURITY_ERROR, this.onLoadError);
		}
		/*
		Parse the StyleSheet
		*/
		public function parseCSS($stylesheet:String):void
		{
			this._objStyleSheet = new StyleSheet();
			this._objStyleSheet.parseCSS($stylesheet);
		}
		/*
		Apply Tag
		*/
		public function applyTag($text:String, $tag:String):String
		{
			return "<" +$tag +">" + $text +"</" +$tag +">";
		}
		/*
		Apply Style
		*/
		public function applyClass($text:String, $class:String):String
		{
			return "<span class='" +$class +"'>" + $text +"</span>";
		}
		/*
		Apply ID
		*/
		public function applyID($text:String, $id:String):String
		{
			return "<span id='" +$id +"'>" + $text +"</span>";
		}
		/*
		Get Style Object
		*/
		public function getStyleAsObject( $style:String ):Object
		{
			return this._objStyleSheet.getStyle( $style );
		}
		/*
		Get Format Object
		*/
		public function getStyleAsTextFormat($style:String):TextFormat
		{
			return this._objStyleSheet.transform( this.getStyleAsObject( $style ) );
		}
		/*
		Event Handlers
		*/
		private function onLoadComplete($event:LoaderEvent):void
		{
			this.status("Style Sheet Loaded");
			this.parseCSS( this._objBackgroundLoader.data );
		}
		private function onLoadError($event:Event):void
		{
			this.warning("Could not parse stylesheet!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RESOURCE_BUNDLE_ERROR, this ));
		}
		/*
		Property Definitions
		*/
		public function get styleNames():Array
		{
			return this._objStyleSheet.styleNames;
		}
		public function get styleSheet():StyleSheet
		{
			return this._objStyleSheet;
		}
		public function get loader():BackgroundLoader
		{
			return this._objBackgroundLoader;
		}
	}
}