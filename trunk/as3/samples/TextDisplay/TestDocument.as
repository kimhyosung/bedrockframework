package
{
	import flash.media.Sound;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.bedrockframework.plugin.data.TextDisplayData;
	import com.bedrockframework.plugin.gadget.TextDisplay;
	
	public class TestDocument extends MovieClip
	{
		/*
		Variable Declarations
		*/
		public var multilineText:TextDisplay;
		public var singlelineText:TextDisplay;
		public var multisinglelineText:TextDisplay;
		/*
		Constructor
		*/
		public function TestDocument()
		{
			this.loaderInfo.addEventListener(Event.INIT, this.onBootUp);
		}

		/*
		Basic view functions
	 	*/
		public function initialize():void
		{
			this.initializeMultiline();
			this.initializeSingleline();
			this.initializeMultiSingleline();
		}
		
		private function initializeMultiline():void
		{
			var objData:TextDisplayData = new TextDisplayData;
			objData.mode = TextDisplayData.MULTI_LINE;
			objData.autoLocale = false;
			
			this.multilineText.initialize( objData );
			this.multilineText.populate( "Little Ms. Muffet sat on her tuffet, eating her turds in waves." );
		}
		private function initializeSingleline():void
		{
			var objData:TextDisplayData = new TextDisplayData;
			objData.mode = TextDisplayData.SINGLE_LINE;
			objData.autoLocale = false;
			objData.width = 400;
			
			this.singlelineText.initialize( objData );
			this.singlelineText.populate( "Little Ms. Muffet sat on her tuffet, eating her turds in waves." );
		}
		private function initializeMultiSingleline():void
		{
			var objData:TextDisplayData = new TextDisplayData;
			objData.mode = TextDisplayData.MULTI_SINGLE_LINE;
			objData.autoLocale = false;
			objData.width = 150;
			
			this.multisinglelineText.initialize( objData );
			this.multisinglelineText.populate( "Little Ms. Muffet sat on her tuffet, eating her turds in waves." );
		}
		/*
		Event Handlers
		*/
		final private function onBootUp($event:Event):void
		{
			this.initialize();
		}
		
	}
}