package com.builtonbedrock.project.template
{
	import flash.display.MovieClip;
	import com.builtonbedrock.bedrock.AssetBuilder;

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