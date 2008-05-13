package com.icg.madagascar.command
{
	import com.icg.madagascar.command.ICommand;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.model.SectionStorage;

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