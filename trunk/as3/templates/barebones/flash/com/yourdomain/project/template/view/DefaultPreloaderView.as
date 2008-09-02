package com.yourdomain.project.template.view
{
	import com.bedrockframework.engine.view.*;
	
	import flash.text.TextField;
	
	public class DefaultPreloaderView extends BedrockView implements IPreloader
	{
		/*
		Variable Declarations
		*/
		public var txtDisplay:TextField;
		/*
		Constructor
		*/
		public function DefaultPreloaderView()
		{
		}
		/*
		Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.displayProgress(0);
			this.x=this.stage.stageWidth / 2;
			this.y=this.stage.stageHeight / 2;
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			this.introComplete();
		}
		public function displayProgress($percent:uint):void
		{
			this.txtDisplay.text=$percent + " %";
		}
		public function outro($properties:Object=null):void
		{
			this.outroComplete();
		}
		public function clear():void
		{
		}
		

	}
}