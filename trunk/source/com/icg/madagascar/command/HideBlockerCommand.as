package com.icg.madagascar.command
{
	import com.icg.madagascar.command.ICommand;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.manager.*;
	import com.icg.madagascar.model.SectionStorage;

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