package __template
{
	import com.bedrockframework.engine.AssetBuilder;
	import com.bedrockframework.engine.data.BedrockData;

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