package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.command.ICommand;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.model.SectionStorage;

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