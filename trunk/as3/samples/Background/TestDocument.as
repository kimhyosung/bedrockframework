package
{

	import com.bedrockframework.plugin.display.Background;
	import com.bedrockframework.plugin.data.BackgroundData;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class TestDocument extends MovieClip
	{
		/*
		Variable Declarations
		*/
		
		private var _objBackground:Background;
		
		/*
		Constructor
		*/
		public function TestDocument()
		{
			this.stage.showDefaultContextMenu = false;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			//
			this.loaderInfo.addEventListener(Event.INIT, this.onBootUp);
		}

		/*
		Basic view functions
	 	*/
		public function initialize():void
		{
			this._objBackground = new Background();
			var objData:BackgroundData = new BackgroundData();
			objData.type = BackgroundData.BITMAP;
			objData.matchStageSize = true;
			objData.bitmapData = new mario_tile(0,0);
			this.addChild(this._objBackground);
			this._objBackground.initialize(objData);
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