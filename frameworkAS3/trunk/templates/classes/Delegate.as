package %%classPackage%%
{
	import com.bedrockframework.plugin.delegate.IDelegate;
	import com.bedrockframework.plugin.delegate.IResponder;
	import com.bedrockframework.plugin.delegate.Delegate;

	public class %%className%% extends Delegate implements IDelegate
	{
		/*
		Variable Delcarations
		*/
		
		/*
		Constructor
		*/
		public function %%className%%($responder:IResponder)
		{
			super( $responder );
		}
		
		public function parse($data:*):void
		{
		}
		
	}
}