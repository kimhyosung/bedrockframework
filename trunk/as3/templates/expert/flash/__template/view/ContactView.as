﻿package __template.view
{
	import com.bedrockframework.plugin.view.IView;
	import com.bedrockframework.engine.view.BedrockView;
	
	public class ContactView extends BedrockView implements IView
	{
		/*
		Variable Declarations
		*/
		
		/*
		Constructor
		*/
		public function ContactView()
		{
		}
		/*
		Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			this.introComplete();
		}
		public function outro($properties:Object=null):void
		{
			this.outroComplete();
		}
		public function clear():void
		{
			this.status("Clear");
		}
	}
}