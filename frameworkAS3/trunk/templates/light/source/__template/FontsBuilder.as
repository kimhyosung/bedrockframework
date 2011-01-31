package __template
{
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.engine.api.ISharedFontsBuilder;
	import com.bedrock.framework.engine.builder.SharedFontsBuilder;

	public class FontsBuilder extends SharedFontsBuilder implements ISharedFontsBuilder
	{
		public function FontsBuilder()
		{
			super();
		}
		
		public function initialize():void
		{
			//this.registerFont( FontName );
			Bedrock.logger.status( "Initialize" );
		}
		
	}
}