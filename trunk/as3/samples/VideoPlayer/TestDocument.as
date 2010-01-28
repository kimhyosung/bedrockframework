package
{
	import com.bedrockframework.plugin.video.VideoPlayer;
	import com.bedrockframework.plugin.event.VideoEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TestDocument extends MovieClip
	{
		/*
		Variable Declarations
		*/
		private var _objVideo:VideoPlayer;
		
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
			this._objVideo = new VideoPlayer();
			this.addChild(this._objVideo);
			this._objVideo.initialize()
			this._objVideo.play( "cuepoints.flv" );
			this._objVideo.volume = 0;
			this._objVideo.bufferTime = 5;
			
			this.playButton.addEventListener("click", this.onPlayClicked)
			this.queueButton.addEventListener("click", this.onQueueClicked)
			this.stopButton.addEventListener("click", this.onStopClicked)
			this._objVideo.addEventListener(VideoEvent.BUFFER_PROGRESS, this.onBufferProgress)
			this._objVideo.addEventListener(VideoEvent.PLAY_PROGRESS, this.onPlayProgress)
		}
		
		/*
		Event Handlers
		*/
		final private function onBootUp($event:Event):void
		{
			this.initialize();
		}
		
		function onBufferProgress ($event)
		{
			this._objVideo.status("Buffer : " + $event.details.percent)
		}
		function onPlayProgress ($event)
		{
			this._objVideo.status("Play : " + $event.details.percent)
		}
		
		function  onPlayClicked($event)
		{
			this._objVideo.play("Phone.flv")
		}
		function  onQueueClicked($event)
		{
			//this._objVideo.queue("Phone.flv")
		}
		
		function  onStopClicked($event) {
			this._objVideo.stop();
		}

		
	}
}