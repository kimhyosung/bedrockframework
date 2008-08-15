package com.yourdomain.project.template
{
	import com.bedrockframework.engine.AssetBuilder;
	import com.bedrockframework.engine.data.BedrockData;
	
	import flash.display.MovieClip;

	public class SharedBuilder extends AssetBuilder
	{
		public function SharedBuilder()
		{
			super();
		}
		override public function initialize():void
		{
			this.addPreloader(BedrockData.DEFAULT_PRELOADER, DefaultPreloader);
		}
	}
}