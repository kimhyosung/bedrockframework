package com.yourdomain.project.template.view
{
	import com.bedrockframework.engine.view.IView;
	import com.bedrockframework.engine.view.View;
	public class HomepageView extends View implements IView
	{
		/*
		Variable Declarations
		*/
		
		/*
		Constructor
		*/
		public function HomepageView()
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
			this.status("clear");
		}
	}
}