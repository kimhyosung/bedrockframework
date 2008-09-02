package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.manager.CopyManager;

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