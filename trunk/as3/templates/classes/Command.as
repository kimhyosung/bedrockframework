package %%classPackage%%
{
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.command.Command;
	import com.bedrock.framework.core.event.GenericEvent;

	public class %%className%% extends Command implements ICommand
	{
		/*
		Variable Delcarations
		*/
		
		/*
		Constructor
		*/
		public function %%className%%()
		{
			super();
		}
		
		public function execute( $event:GenericEvent ):void
		{
		}
		
	}
}