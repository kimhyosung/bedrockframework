package
{
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	import com.bedrockframework.plugin.event.LoaderEvent;

	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TestDocument extends MovieClip
	{
		/*
		Variable Declarations
		*/
		private var _objBackgroundLoader:BackgroundLoader;
		
		
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
			this._objBackgroundLoader = new BackgroundLoader();
			//this.addChild(this._objBackgroundLoader);
			
			this._objBackgroundLoader.addEventListener(LoaderEvent.COMPLETE, this.onHandler);
			this._objBackgroundLoader.addEventListener(LoaderEvent.OPEN, this.onHandler);
			this._objBackgroundLoader.addEventListener(LoaderEvent.INIT, this.onHandler);
			this._objBackgroundLoader.addEventListener(LoaderEvent.UNLOAD, this.onHandler);
			this._objBackgroundLoader.addEventListener(LoaderEvent.HTTP_STATUS, this.onHandler);
			this._objBackgroundLoader.addEventListener(LoaderEvent.PROGRESS, this.onHandler);
			this._objBackgroundLoader.addEventListener(LoaderEvent.IO_ERROR, this.onHandler);
			this._objBackgroundLoader.addEventListener(LoaderEvent.SECURITY_ERROR, this.onHandler);
			
			
			this._objBackgroundLoader.load(new URLRequest("pic1.jpg"));
			trace(this._objBackgroundLoader.request)
			
			this._objBackgroundLoader.loadURL("pic1.jpg");
			trace(this._objBackgroundLoader.request);
		}
		
		/*
		Event Handlers
		*/
		final private function onBootUp($event:Event):void
		{
			this.initialize();
		}
		
		private function onHandler($event)
		{
			trace("> ", $event.type);
			for (var i in $event.details) {
				trace("   ", i , $event.details[i]);
			}
			trace("")
		}
		
	}
}