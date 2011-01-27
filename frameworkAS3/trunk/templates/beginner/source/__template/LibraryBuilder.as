package __template
{
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.engine.api.ISharedLibraryBuilder;
	import com.bedrock.framework.engine.builder.SharedLibraryBuilder;
	import com.bedrock.framework.engine.data.BedrockData;

	public class LibraryBuilder extends SharedLibraryBuilder implements ISharedLibraryBuilder
	{
		/*
		Constructor
	 	*/
		public function LibraryBuilder()
		{
			super();
		}
		/*
		View Behavior
		*/
		public function initialize():void
		{
			this.registerPreloader( BedrockData.DEFAULT_PRELOADER, "DefaultPreloader" );
			Bedrock.logger.status( "Initialize" );
		}
	}
}