package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.manager.CopyManager;

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