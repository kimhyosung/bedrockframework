package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.command.ICommand;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.manager.*;
	import com.builtonbedrock.bedrock.model.SectionStorage;

	public class HideBlockerCommand extends Command implements ICommand
	{
		public function HideBlockerCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			ContainerManager.getContainer("blocker").hide();
		}
	}

}