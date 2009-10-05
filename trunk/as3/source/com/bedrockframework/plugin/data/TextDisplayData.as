package com.bedrockframework.plugin.data
{
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public class TextDisplayData
	{
		public static var globalStyleSheet:StyleSheet;
		
		public var text:String;
		public var textID:String;
		public var textClass:String;
		public var textTag:String;
		
		public var resourceKey:String;
		public var resourceGroup:String;
		
		public var width:Number;
		public var height:Number;
		
		public var styleSheet:StyleSheet;
		public var autoPopulate:Boolean;
		
		private var _bolUseGlobalStyleSheet:Boolean;
		
		public function TextDisplayData( )
		{
			this.text = "";
		}
		
		public function get useGlobalStyleSheet():Boolean
		{
			return this._bolUseGlobalStyleSheet;
		}
		public function set useGlobalStyleSheet( $status:Boolean ):void
		{
			this._bolUseGlobalStyleSheet = $status;
			if ( this._bolUseGlobalStyleSheet ) this.styleSheet = TextDisplayData.globalStyleSheet;
		}
	}
}