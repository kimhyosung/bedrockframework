package com.icg.madagascar.command
{
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.manager.CopyManager;

	public class LoadCopyCommand extends Command implements ICommand
	{
		public function LoadCopyCommand()
		{
		
		}
		
		public function execute($event:GenericEvent):void
		{
			CopyManager.loadXML($event.details.url);
		}
		
	}
}