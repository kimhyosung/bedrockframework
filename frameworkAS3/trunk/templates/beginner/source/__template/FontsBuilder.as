package __template
{
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
			this.status( "Initialize" );
		}
		
	}
}