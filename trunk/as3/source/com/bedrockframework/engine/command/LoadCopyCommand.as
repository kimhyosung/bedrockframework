package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;

	public class LoadCopyCommand extends Command implements ICommand
	{
		public function LoadCopyCommand()
		{
		
		}
		
		public function execute($event:GenericEvent):void
		{
			BedrockEngine.copyManager.loadXML($event.details.url);
		}
		
	}
}