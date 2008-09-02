package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.command.ICommand;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.model.SectionStorage;

	public class SetQueueCommand extends Command implements ICommand
	{
		public function SetQueueCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			SectionStorage.setQueue($event.details.alias);
		}
	}

}