package com.autumntactics.project.template
{
	import flash.display.MovieClip;
	import com.autumntactics.bedrock.AssetBuilder;

	public class SharedBuilder extends AssetBuilder
	{
		public function SharedBuilder()
		{
			super();
		}
		override public function initialize():void
		{
			this.addPreloader("default",DefaultPreloader);
			this.addPreloader("homepage",SubPagePreloader);
		}
	}
}