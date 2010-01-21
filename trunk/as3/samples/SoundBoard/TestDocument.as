package
{
	import com.bedrockframework.plugin.audio.SoundBoard;
	import com.bedrockframework.plugin.data.SoundData;
	import flash.events.MouseEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TestDocument extends MovieClip
	{
		/*
		Variable Declarations
		*/
		private var _objSoundBoard:SoundBoard;
		
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
			this._objSoundBoard = new SoundBoard();

			var objData:SoundData = new SoundData( "dragonPiece", new DragonPiece() );
			this._objSoundBoard.add( objData );
			this._objSoundBoard.play("dragonPiece", 0, 10000, 0, 0.5 );
			
			
			fadeUpButton.addEventListener(MouseEvent.CLICK, this.onFadeUpClicked);
			fadeDownButton.addEventListener(MouseEvent.CLICK, this.onFadeDownClicked);
			stopButton.addEventListener( MouseEvent.CLICK, this.onStopClicked );
		}
		
		/*
		Event Handlers
		*/
		final private function onBootUp($event:Event):void
		{
			this.initialize();
		}
		
		function onFadeUpClicked($event)
		{
			trace("Raise Volume!")
			//this._objSoundBoard.setVolume("dragonPiece", 0.5);
			this._objSoundBoard.fadeVolume("dragonPiece", 1, 1);
			
		}
		function onFadeDownClicked($event)
		{
			
			trace("Reduce Volume!")
			//this._objSoundBoard.setVolume("dragonPiece", 1);
			this._objSoundBoard.fadeVolume("dragonPiece", 0, 1);	
		}

		function onStopClicked($event)
		{
			this._objSoundBoard.stop( "dragonPiece" );
		}
		
	}
}