package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.manager.ContainerManager;

	public class ShowBlockerCommand extends Command implements ICommand
	{
		public function ShowBlockerCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			ContainerManager.getContainer("blocker").show();
		}
	}

}