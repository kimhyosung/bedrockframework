package
{
	import com.bedrockframework.plugin.gadget.Scroller;
	import com.bedrockframework.plugin.data.ScrollerData;
	import com.bedrockframework.plugin.event.ScrollerEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TestDocument extends MovieClip
	{
		/*
		Variable Declarations
		*/
		
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
			var objPropertiesH = new ScrollerData();
			objPropertiesH.content = this.mcContent;
			objPropertiesH.mask = this.mcMask;
			objPropertiesH.scrubberContainer = this.mcTrackH;
			objPropertiesH.scrubberBackground = this.mcTrackH.mcBackground;
			objPropertiesH.scrubber = this.mcTrackH.mcDrag;
			objPropertiesH.resize = true;
			objPropertiesH.alignment = ScrollerData.LEFT;
			objPropertiesH.direction = ScrollerData.HORIZONTAL;
			//
			objScrollerH = new Scroller();
			objScrollerH.initialize(objPropertiesH);
			//
			var objPropertiesV = new ScrollerData();
			objPropertiesV.content = this.mcContent;
			objPropertiesV.mask = this.mcMask;
			objPropertiesV.scrubberContainer = this.mcTrackV;
			objPropertiesV.scrubberBackground = this.mcTrackV.mcBackground;
			objPropertiesV.scrubber = this.mcTrackV.mcDrag;
			objPropertiesV.resize = true;
			objPropertiesV.alignment = ScrollerData.CENTER;
			objPropertiesV.direction = ScrollerData.VERTICAL;
			//
			objScrollerV = new Scroller();
			objScrollerV.initialize(objPropertiesV);
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