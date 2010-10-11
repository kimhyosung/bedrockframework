package %%classPackage%%
{
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.event.GenericEvent;

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