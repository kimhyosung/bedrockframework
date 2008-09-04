package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.manager.CopyManager;

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