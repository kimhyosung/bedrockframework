package __template
{
	import com.bedrock.framework.engine.AssetsBuilder;
	import com.bedrock.framework.engine.api.IAssetsBuilder;

	public class SharedAssetsBuilder extends AssetsBuilder implements IAssetsBuilder
	{
		/*
		Constructor
	 	*/
		public function SharedAssetsBuilder()
		{
			super();
		}
		/*
		View Behavior
		*/
		public function initialize():void
		{
			/* this.addPreloader( BedrockData.DEFAULT_PRELOADER, "DefaultPreloader" );*/
			this.status( "Initialize" );
		}
	}
}