package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.command.ICommand;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.manager.*;
	import com.autumntactics.bedrock.model.SectionStorage;

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