package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.SectionStorage;import com.bedrockframework.core.command.*;

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